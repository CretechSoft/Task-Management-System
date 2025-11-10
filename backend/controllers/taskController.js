const Task = require('../models/Task');
const Attachment = require('../models/Attachment');
const Comment = require('../models/Comment');
const AuditLog = require('../models/AuditLog');
const { createAuditLog } = require('../utils/auditLogger');
const { createNotification } = require('../utils/notificationService');

// Create Task
exports.createTask = async (req, res) => {
  try {
    const {
      title,
      description,
      project,
      department,
      assignedTo,
      priority,
      color,
      startDate,
      dueDate,
      slaThreshold,
      tags
    } = req.body;

    const task = new Task({
      title,
      description,
      project,
      department,
      assignedTo,
      assignedBy: req.userId,
      priority,
      color,
      startDate,
      dueDate,
      slaThreshold,
      tags
    });

    await task.save();

    // Create audit log
    await createAuditLog(
      task._id,
      req.userId,
      'created',
      null,
      task.toObject(),
      'Task created',
      req.ip
    );

    // Send notification to assigned user
    if (assignedTo) {
      await createNotification(
        assignedTo,
        req.userId,
        task._id,
        'task_assigned',
        'New Task Assigned',
        `You have been assigned a new task: ${title}`
      );
    }

    const populatedTask = await Task.findById(task._id)
      .populate('assignedTo', 'name email')
      .populate('assignedBy', 'name email')
      .populate('project', 'name')
      .populate('department', 'name');

    res.status(201).json({
      message: 'Task created successfully',
      task: populatedTask
    });
  } catch (error) {
    console.error('Create task error:', error);
    res.status(500).json({ message: 'Server error while creating task' });
  }
};

// Get All Tasks with Filtering
exports.getTasks = async (req, res) => {
  try {
    const {
      status,
      department,
      project,
      assignedTo,
      priority,
      search,
      page = 1,
      limit = 20,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    const filter = {};

    if (status) filter.status = status;
    if (department) filter.department = department;
    if (project) filter.project = project;
    if (assignedTo) filter.assignedTo = assignedTo;
    if (priority) filter.priority = priority;
    
    if (search) {
      filter.$or = [
        { title: { $regex: search, $options: 'i' } },
        { description: { $regex: search, $options: 'i' } },
        { tags: { $in: [new RegExp(search, 'i')] } }
      ];
    }

    const sort = {};
    sort[sortBy] = sortOrder === 'asc' ? 1 : -1;

    const tasks = await Task.find(filter)
      .populate('assignedTo', 'name email avatar')
      .populate('assignedBy', 'name email')
      .populate('project', 'name color')
      .populate('department', 'name color')
      .populate('qaReviewer', 'name email')
      .sort(sort)
      .limit(limit * 1)
      .skip((page - 1) * limit);

    const count = await Task.countDocuments(filter);

    res.json({
      tasks,
      totalPages: Math.ceil(count / limit),
      currentPage: page,
      totalTasks: count
    });
  } catch (error) {
    console.error('Get tasks error:', error);
    res.status(500).json({ message: 'Server error while fetching tasks' });
  }
};

// Get Single Task
exports.getTask = async (req, res) => {
  try {
    const task = await Task.findById(req.params.id)
      .populate('assignedTo', 'name email avatar department')
      .populate('assignedBy', 'name email')
      .populate('project', 'name description color')
      .populate('department', 'name color')
      .populate('qaReviewer', 'name email');

    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    // Get attachments
    const attachments = await Attachment.find({ task: task._id })
      .populate('uploadedBy', 'name email')
      .sort({ createdAt: -1 });

    // Get comments
    const comments = await Comment.find({ task: task._id })
      .populate('user', 'name email avatar')
      .populate('mentions', 'name email')
      .sort({ createdAt: -1 });

    // Get audit logs
    const auditLogs = await AuditLog.find({ task: task._id })
      .populate('user', 'name email')
      .sort({ createdAt: -1 });

    res.json({
      task,
      attachments,
      comments,
      auditLogs
    });
  } catch (error) {
    console.error('Get task error:', error);
    res.status(500).json({ message: 'Server error while fetching task' });
  }
};

// Update Task
exports.updateTask = async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);
    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    const previousTask = task.toObject();
    const updates = req.body;
    const changedFields = [];

    // Track changes
    Object.keys(updates).forEach(key => {
      if (task[key] !== updates[key]) {
        changedFields.push({
          field: key,
          oldValue: task[key],
          newValue: updates[key]
        });
        task[key] = updates[key];
      }
    });

    await task.save();

    // Create audit logs for each change
    for (const change of changedFields) {
      await createAuditLog(
        task._id,
        req.userId,
        'updated',
        change.oldValue,
        change.newValue,
        `Updated ${change.field}`,
        req.ip
      );
    }

    // Send notification if reassigned
    if (updates.assignedTo && updates.assignedTo !== previousTask.assignedTo) {
      await createNotification(
        updates.assignedTo,
        req.userId,
        task._id,
        'task_assigned',
        'Task Reassigned',
        `You have been assigned task: ${task.title}`
      );

      await createAuditLog(
        task._id,
        req.userId,
        'reassigned',
        previousTask.assignedTo,
        updates.assignedTo,
        'Task reassigned',
        req.ip
      );
    }

    const updatedTask = await Task.findById(task._id)
      .populate('assignedTo', 'name email')
      .populate('assignedBy', 'name email')
      .populate('project', 'name')
      .populate('department', 'name');

    res.json({
      message: 'Task updated successfully',
      task: updatedTask
    });
  } catch (error) {
    console.error('Update task error:', error);
    res.status(500).json({ message: 'Server error while updating task' });
  }
};

// Update Task Status
exports.updateTaskStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    const previousStatus = task.status;
    task.status = status;

    if (status === 'completed' || status === 'approved') {
      task.completedDate = new Date();
      task.isCompletedOnTime = task.checkSLACompliance();
    }

    await task.save();

    // Create audit log
    await createAuditLog(
      task._id,
      req.userId,
      'status_changed',
      previousStatus,
      status,
      `Status changed from ${previousStatus} to ${status}`,
      req.ip
    );

    // Send notification to assigned user
    if (task.assignedTo) {
      await createNotification(
        task.assignedTo,
        req.userId,
        task._id,
        'task_updated',
        'Task Status Updated',
        `Task "${task.title}" status changed to ${status}`
      );
    }

    res.json({
      message: 'Task status updated successfully',
      task
    });
  } catch (error) {
    console.error('Update task status error:', error);
    res.status(500).json({ message: 'Server error while updating task status' });
  }
};

// Submit Task for QA Review
exports.submitForReview = async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    task.status = 'pending-review';
    await task.save();

    await createAuditLog(
      task._id,
      req.userId,
      'submitted_for_review',
      'in-progress',
      'pending-review',
      'Task submitted for QA review',
      req.ip
    );

    // Notify QA reviewer
    if (task.qaReviewer) {
      await createNotification(
        task.qaReviewer,
        req.userId,
        task._id,
        'task_updated',
        'Task Ready for Review',
        `Task "${task.title}" is ready for QA review`
      );
    }

    res.json({
      message: 'Task submitted for review successfully',
      task
    });
  } catch (error) {
    console.error('Submit for review error:', error);
    res.status(500).json({ message: 'Server error while submitting for review' });
  }
};

// QA Review - Approve/Reject
exports.qaReview = async (req, res) => {
  try {
    const { qaStatus, qaComments } = req.body;
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    task.qaStatus = qaStatus;
    task.qaComments = qaComments;
    task.qaReviewer = req.userId;
    task.qaReviewDate = new Date();

    if (qaStatus === 'passed') {
      task.status = 'approved';
      task.completedDate = new Date();
      task.isCompletedOnTime = task.checkSLACompliance();
    } else if (qaStatus === 'failed') {
      task.status = 'rejected';
    }

    await task.save();

    await createAuditLog(
      task._id,
      req.userId,
      qaStatus === 'passed' ? 'approved' : 'rejected',
      'pending-review',
      task.status,
      `QA Review: ${qaStatus} - ${qaComments || 'No comments'}`,
      req.ip
    );

    // Notify assigned user
    await createNotification(
      task.assignedTo,
      req.userId,
      task._id,
      qaStatus === 'passed' ? 'task_approved' : 'task_rejected',
      `Task ${qaStatus === 'passed' ? 'Approved' : 'Rejected'}`,
      `Your task "${task.title}" has been ${qaStatus}. ${qaComments || ''}`
    );

    res.json({
      message: `Task ${qaStatus} successfully`,
      task
    });
  } catch (error) {
    console.error('QA review error:', error);
    res.status(500).json({ message: 'Server error during QA review' });
  }
};

// Delete Task
exports.deleteTask = async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }

    await Task.findByIdAndDelete(req.params.id);

    res.json({ message: 'Task deleted successfully' });
  } catch (error) {
    console.error('Delete task error:', error);
    res.status(500).json({ message: 'Server error while deleting task' });
  }
};

// Get Performance Metrics
exports.getPerformanceMetrics = async (req, res) => {
  try {
    const { userId, departmentId, startDate, endDate } = req.query;
    const filter = {};

    if (userId) filter.assignedTo = userId;
    if (departmentId) filter.department = departmentId;
    if (startDate || endDate) {
      filter.createdAt = {};
      if (startDate) filter.createdAt.$gte = new Date(startDate);
      if (endDate) filter.createdAt.$lte = new Date(endDate);
    }

    const totalTasks = await Task.countDocuments(filter);
    const completedTasks = await Task.countDocuments({ ...filter, status: { $in: ['completed', 'approved'] } });
    const tasksCompletedOnTime = await Task.countDocuments({ ...filter, isCompletedOnTime: true });
    const overdueTasks = await Task.countDocuments({
      ...filter,
      dueDate: { $lt: new Date() },
      status: { $nin: ['completed', 'approved'] }
    });

    const metrics = {
      totalTasks,
      completedTasks,
      tasksCompletedOnTime,
      overdueTasks,
      completionRate: totalTasks > 0 ? (completedTasks / totalTasks * 100).toFixed(2) : 0,
      onTimeRate: completedTasks > 0 ? (tasksCompletedOnTime / completedTasks * 100).toFixed(2) : 0
    };

    res.json({ metrics });
  } catch (error) {
    console.error('Get performance metrics error:', error);
    res.status(500).json({ message: 'Server error while fetching metrics' });
  }
};
