require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./backend/config/database');
const schedule = require('node-schedule');
const Task = require('./backend/models/Task');
const { createNotification } = require('./backend/utils/notificationService');

// Initialize Express
const app = express();

// Connect to Database
connectDB();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Static folder for uploads
app.use('/uploads', express.static('uploads'));

// Routes
app.use('/api/auth', require('./backend/routes/auth'));
app.use('/api/tasks', require('./backend/routes/tasks'));
app.use('/api/attachments', require('./backend/routes/attachments'));
app.use('/api/comments', require('./backend/routes/comments'));
app.use('/api/departments', require('./backend/routes/departments'));
app.use('/api/projects', require('./backend/routes/projects'));
app.use('/api/notifications', require('./backend/routes/notifications'));

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Task Management System API is running' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    message: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ message: 'Route not found' });
});

// Schedule task to check for due tasks and send reminders
// Runs every hour
schedule.scheduleJob('0 * * * *', async () => {
  try {
    const now = new Date();
    const twentyFourHoursFromNow = new Date(now.getTime() + 24 * 60 * 60 * 1000);

    // Find tasks due within 24 hours
    const tasksDueSoon = await Task.find({
      dueDate: { $gte: now, $lte: twentyFourHoursFromNow },
      status: { $nin: ['completed', 'approved'] }
    }).populate('assignedTo');

    for (const task of tasksDueSoon) {
      if (task.assignedTo) {
        await createNotification(
          task.assignedTo._id,
          null,
          task._id,
          'task_due_soon',
          'Task Due Soon',
          `Task "${task.title}" is due within 24 hours`
        );
      }
    }

    // Find overdue tasks
    const overdueTasks = await Task.find({
      dueDate: { $lt: now },
      status: { $nin: ['completed', 'approved'] }
    }).populate('assignedTo');

    for (const task of overdueTasks) {
      if (task.assignedTo) {
        await createNotification(
          task.assignedTo._id,
          null,
          task._id,
          'task_overdue',
          'Task Overdue',
          `Task "${task.title}" is overdue`
        );
      }
    }

    console.log(`Reminder job completed: ${tasksDueSoon.length} tasks due soon, ${overdueTasks.length} overdue tasks`);
  } catch (error) {
    console.error('Error in reminder job:', error);
  }
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = app;
