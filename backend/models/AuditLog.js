const mongoose = require('mongoose');

const auditLogSchema = new mongoose.Schema({
  task: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Task',
    required: true
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  action: {
    type: String,
    required: true,
    enum: [
      'created',
      'assigned',
      'updated',
      'status_changed',
      'started',
      'submitted_for_review',
      'approved',
      'rejected',
      'completed',
      'comment_added',
      'attachment_added',
      'priority_changed',
      'due_date_changed',
      'reassigned'
    ]
  },
  previousValue: mongoose.Schema.Types.Mixed,
  newValue: mongoose.Schema.Types.Mixed,
  description: String,
  ipAddress: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Index for efficient querying
auditLogSchema.index({ task: 1, createdAt: -1 });
auditLogSchema.index({ user: 1, createdAt: -1 });

module.exports = mongoose.model('AuditLog', auditLogSchema);
