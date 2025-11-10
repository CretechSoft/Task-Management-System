const express = require('express');
const router = express.Router();
const taskController = require('../controllers/taskController');
const { auth, authorize } = require('../middleware/auth');

// Create Task
router.post('/', auth, authorize('admin', 'manager'), taskController.createTask);

// Get All Tasks
router.get('/', auth, taskController.getTasks);

// Get Single Task
router.get('/:id', auth, taskController.getTask);

// Update Task
router.put('/:id', auth, taskController.updateTask);

// Update Task Status
router.patch('/:id/status', auth, taskController.updateTaskStatus);

// Submit for Review
router.post('/:id/submit-review', auth, taskController.submitForReview);

// QA Review
router.post('/:id/qa-review', auth, authorize('admin', 'manager', 'qa'), taskController.qaReview);

// Delete Task
router.delete('/:id', auth, authorize('admin', 'manager'), taskController.deleteTask);

// Get Performance Metrics
router.get('/metrics/performance', auth, taskController.getPerformanceMetrics);

module.exports = router;
