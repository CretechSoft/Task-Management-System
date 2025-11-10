const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const { auth } = require('../middleware/auth');

// Get User Notifications
router.get('/', auth, notificationController.getNotifications);

// Mark Notification as Read
router.patch('/:id/read', auth, notificationController.markAsRead);

// Mark All as Read
router.patch('/read-all', auth, notificationController.markAllAsRead);

// Delete Notification
router.delete('/:id', auth, notificationController.deleteNotification);

module.exports = router;
