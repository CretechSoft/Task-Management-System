const Comment = require('../models/Comment');
const { createAuditLog } = require('../utils/auditLogger');
const { createBulkNotifications } = require('../utils/notificationService');

// Create Comment
exports.createComment = async (req, res) => {
  try {
    const { taskId, content, mentions } = req.body;

    const comment = new Comment({
      task: taskId,
      user: req.userId,
      content,
      mentions: mentions || []
    });

    await comment.save();

    // Create audit log
    await createAuditLog(
      taskId,
      req.userId,
      'comment_added',
      null,
      { content },
      'Comment added',
      req.ip
    );

    // Send notifications to mentioned users
    if (mentions && mentions.length > 0) {
      await createBulkNotifications(
        mentions,
        req.userId,
        taskId,
        'task_mentioned',
        'You were mentioned',
        `You were mentioned in a comment on task`
      );
    }

    const populatedComment = await Comment.findById(comment._id)
      .populate('user', 'name email avatar')
      .populate('mentions', 'name email');

    res.status(201).json({
      message: 'Comment added successfully',
      comment: populatedComment
    });
  } catch (error) {
    console.error('Create comment error:', error);
    res.status(500).json({ message: 'Server error while adding comment' });
  }
};

// Get Comments for Task
exports.getComments = async (req, res) => {
  try {
    const { taskId } = req.params;

    const comments = await Comment.find({ task: taskId })
      .populate('user', 'name email avatar')
      .populate('mentions', 'name email')
      .sort({ createdAt: -1 });

    res.json({ comments });
  } catch (error) {
    console.error('Get comments error:', error);
    res.status(500).json({ message: 'Server error while fetching comments' });
  }
};

// Update Comment
exports.updateComment = async (req, res) => {
  try {
    const { content, mentions } = req.body;
    const comment = await Comment.findById(req.params.id);

    if (!comment) {
      return res.status(404).json({ message: 'Comment not found' });
    }

    // Check if user is the comment author
    if (comment.user.toString() !== req.userId.toString()) {
      return res.status(403).json({ message: 'Not authorized to edit this comment' });
    }

    comment.content = content;
    if (mentions) comment.mentions = mentions;

    await comment.save();

    const updatedComment = await Comment.findById(comment._id)
      .populate('user', 'name email avatar')
      .populate('mentions', 'name email');

    res.json({
      message: 'Comment updated successfully',
      comment: updatedComment
    });
  } catch (error) {
    console.error('Update comment error:', error);
    res.status(500).json({ message: 'Server error while updating comment' });
  }
};

// Delete Comment
exports.deleteComment = async (req, res) => {
  try {
    const comment = await Comment.findById(req.params.id);

    if (!comment) {
      return res.status(404).json({ message: 'Comment not found' });
    }

    // Check if user is the comment author or admin
    if (comment.user.toString() !== req.userId.toString() && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Not authorized to delete this comment' });
    }

    await Comment.findByIdAndDelete(req.params.id);

    res.json({ message: 'Comment deleted successfully' });
  } catch (error) {
    console.error('Delete comment error:', error);
    res.status(500).json({ message: 'Server error while deleting comment' });
  }
};
