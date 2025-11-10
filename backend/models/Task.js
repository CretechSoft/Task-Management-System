const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    trim: true
  },
  project: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Project',
    required: true
  },
  department: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Department',
    required: true
  },
  assignedTo: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  assignedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  status: {
    type: String,
    enum: ['assigned', 'in-progress', 'pending-review', 'approved', 'rejected', 'completed'],
    default: 'assigned'
  },
  priority: {
    type: String,
    enum: ['low', 'medium', 'high', 'urgent'],
    default: 'medium'
  },
  color: {
    type: String,
    default: '#95a5a6'
  },
  startDate: Date,
  dueDate: {
    type: Date,
    required: true
  },
  completedDate: Date,
  slaThreshold: {
    type: Number, // in hours
    default: 24
  },
  tags: [String],
  // Quality Review fields
  qaReviewer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  qaStatus: {
    type: String,
    enum: ['pending', 'passed', 'failed'],
    default: 'pending'
  },
  qaComments: String,
  qaReviewDate: Date,
  // Performance tracking
  isCompletedOnTime: {
    type: Boolean,
    default: null
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Index for filtering
taskSchema.index({ status: 1, department: 1, project: 1, assignedTo: 1 });
taskSchema.index({ dueDate: 1, status: 1 });

// Virtual for checking if task is overdue
taskSchema.virtual('isOverdue').get(function() {
  if (this.status === 'completed' || this.status === 'approved') return false;
  return this.dueDate < new Date();
});

// Method to check SLA compliance
taskSchema.methods.checkSLACompliance = function() {
  if (!this.completedDate) return null;
  const timeTaken = (this.completedDate - this.createdAt) / (1000 * 60 * 60); // in hours
  return timeTaken <= this.slaThreshold;
};

module.exports = mongoose.model('Task', taskSchema);
