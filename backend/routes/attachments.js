const express = require('express');
const router = express.Router();
const attachmentController = require('../controllers/attachmentController');
const { auth } = require('../middleware/auth');
const upload = require('../config/upload');

// Upload Attachment
router.post('/', auth, upload.single('file'), attachmentController.uploadAttachment);

// Get Attachments for Task
router.get('/task/:taskId', auth, attachmentController.getAttachments);

// Download Attachment
router.get('/:id/download', auth, attachmentController.downloadAttachment);

// Delete Attachment
router.delete('/:id', auth, attachmentController.deleteAttachment);

module.exports = router;
