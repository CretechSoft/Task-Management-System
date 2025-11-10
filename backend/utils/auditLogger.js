const AuditLog = require('../models/AuditLog');

const createAuditLog = async (taskId, userId, action, previousValue, newValue, description, ipAddress) => {
  try {
    const auditLog = new AuditLog({
      task: taskId,
      user: userId,
      action,
      previousValue,
      newValue,
      description,
      ipAddress
    });

    await auditLog.save();
    return auditLog;
  } catch (error) {
    console.error('Error creating audit log:', error);
  }
};

module.exports = { createAuditLog };
