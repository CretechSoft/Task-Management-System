const express = require('express');
const router = express.Router();
const commentController = require('../controllers/commentController');
const { auth } = require('../middleware/auth');

// Create Comment
router.post('/', auth, commentController.createComment);

// Get Comments for Task
router.get('/task/:taskId', auth, commentController.getComments);

// Update Comment
router.put('/:id', auth, commentController.updateComment);

// Delete Comment
router.delete('/:id', auth, commentController.deleteComment);

module.exports = router;
