const Notification = require('../models/Notification');

const createNotification = async (recipientId, senderId, taskId, type, title, message) => {
  try {
    const notification = new Notification({
      recipient: recipientId,
      sender: senderId,
      task: taskId,
      type,
      title,
      message
    });

    await notification.save();
    return notification;
  } catch (error) {
    console.error('Error creating notification:', error);
  }
};

const createBulkNotifications = async (recipientIds, senderId, taskId, type, title, message) => {
  try {
    const notifications = recipientIds.map(recipientId => ({
      recipient: recipientId,
      sender: senderId,
      task: taskId,
      type,
      title,
      message
    }));

    await Notification.insertMany(notifications);
  } catch (error) {
    console.error('Error creating bulk notifications:', error);
  }
};

module.exports = { createNotification, createBulkNotifications };
