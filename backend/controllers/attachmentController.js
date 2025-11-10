const Attachment = require('../models/Attachment');
const { createAuditLog } = require('../utils/auditLogger');
const fs = require('fs');
const path = require('path');

// Upload Attachment
exports.uploadAttachment = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'No file uploaded' });
    }

    const { taskId, description, attachmentType } = req.body;

    const attachment = new Attachment({
      task: taskId,
      uploadedBy: req.userId,
      fileName: req.file.filename,
      originalName: req.file.originalname,
      filePath: req.file.path,
      fileType: path.extname(req.file.originalname),
      fileSize: req.file.size,
      mimeType: req.file.mimetype,
      description,
      attachmentType: attachmentType || 'other'
    });

    await attachment.save();

    // Create audit log
    await createAuditLog(
      taskId,
      req.userId,
      'attachment_added',
      null,
      { fileName: req.file.originalname },
      `Attachment uploaded: ${req.file.originalname}`,
      req.ip
    );

    const populatedAttachment = await Attachment.findById(attachment._id)
      .populate('uploadedBy', 'name email');

    res.status(201).json({
      message: 'File uploaded successfully',
      attachment: populatedAttachment
    });
  } catch (error) {
    console.error('Upload attachment error:', error);
    res.status(500).json({ message: 'Server error while uploading file' });
  }
};

// Get Attachments for Task
exports.getAttachments = async (req, res) => {
  try {
    const { taskId } = req.params;

    const attachments = await Attachment.find({ task: taskId })
      .populate('uploadedBy', 'name email')
      .sort({ createdAt: -1 });

    res.json({ attachments });
  } catch (error) {
    console.error('Get attachments error:', error);
    res.status(500).json({ message: 'Server error while fetching attachments' });
  }
};

// Download Attachment
exports.downloadAttachment = async (req, res) => {
  try {
    const attachment = await Attachment.findById(req.params.id);

    if (!attachment) {
      return res.status(404).json({ message: 'Attachment not found' });
    }

    const filePath = path.resolve(attachment.filePath);

    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ message: 'File not found on server' });
    }

    res.download(filePath, attachment.originalName);
  } catch (error) {
    console.error('Download attachment error:', error);
    res.status(500).json({ message: 'Server error while downloading file' });
  }
};

// Delete Attachment
exports.deleteAttachment = async (req, res) => {
  try {
    const attachment = await Attachment.findById(req.params.id);

    if (!attachment) {
      return res.status(404).json({ message: 'Attachment not found' });
    }

    // Delete file from disk
    if (fs.existsSync(attachment.filePath)) {
      fs.unlinkSync(attachment.filePath);
    }

    await Attachment.findByIdAndDelete(req.params.id);

    res.json({ message: 'Attachment deleted successfully' });
  } catch (error) {
    console.error('Delete attachment error:', error);
    res.status(500).json({ message: 'Server error while deleting attachment' });
  }
};
