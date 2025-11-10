# Task Management System - Feature Implementation Guide

## نظام إدارة المهام المؤسسي - دليل تنفيذ المزايا

This document provides a detailed overview of all implemented features and how to use them.

## Table of Contents
1. [User Roles and Permissions](#user-roles-and-permissions)
2. [Task Lifecycle](#task-lifecycle)
3. [Department Management](#department-management)
4. [Project Management](#project-management)
5. [Task Management](#task-management)
6. [File Attachments](#file-attachments)
7. [Comments and Mentions](#comments-and-mentions)
8. [Notifications](#notifications)
9. [Audit Trail](#audit-trail)
10. [Performance Metrics](#performance-metrics)
11. [Filtering and Search](#filtering-and-search)
12. [Automated Features](#automated-features)

---

## User Roles and Permissions

### Admin (المسؤول)
**Full system access including:**
- Create/manage all users
- Create/manage departments
- Create/manage projects
- Create/assign tasks
- View all data
- Access all reports and metrics

**API Permissions:**
- All endpoints available

### Manager (المدير)
**Department and project management:**
- Create/assign tasks
- Manage projects in their department
- View team performance metrics
- Approve/reject QA reviews
- Manage department members

**API Permissions:**
- Task CRUD operations
- Project management
- User viewing (limited)
- Performance metrics

### QA (مراجع الجودة)
**Quality assurance responsibilities:**
- Review submitted tasks
- Approve or reject task completion
- Add QA comments
- View task details and evidence

**API Permissions:**
- Task review endpoints
- View tasks assigned for QA
- Comment on tasks

### Employee (الموظف)
**Task execution:**
- Work on assigned tasks
- Upload evidence and attachments
- Comment on tasks
- Update task status
- View own tasks and notifications

**API Permissions:**
- View assigned tasks
- Update task status
- Upload attachments
- Add comments
- View notifications

---

## Task Lifecycle

### 1. Assignment (الإسناد)
```
Status: assigned
```
- Manager creates task
- Assigns to employee
- Sets deadline and priority
- Employee receives notification

**API Endpoint:**
```http
POST /api/tasks
```

### 2. Execution (التنفيذ)
```
Status: in-progress
```
- Employee starts working
- Updates status to "in-progress"
- Can upload evidence during work
- Can add comments/questions

**API Endpoint:**
```http
PATCH /api/tasks/:id/status
Body: { "status": "in-progress" }
```

### 3. Evidence Upload (رفع الأدلة)
```
Status: in-progress
```
- Employee uploads completion evidence
- Can upload multiple files/images
- Each attachment can have description

**API Endpoint:**
```http
POST /api/attachments
Form-data: file, taskId, description, attachmentType
```

### 4. Submit for Review (إرسال للمراجعة)
```
Status: pending-review
```
- Employee submits task for QA
- QA reviewer receives notification
- Task locked from further employee updates

**API Endpoint:**
```http
POST /api/tasks/:id/submit-review
```

### 5. QA Review (المراجعة)
```
Status: pending-review → approved/rejected
```
- QA reviewer examines evidence
- Reviews task completion
- Makes decision: Approve or Reject
- Adds comments

**API Endpoint:**
```http
POST /api/tasks/:id/qa-review
Body: { "qaStatus": "passed", "qaComments": "..." }
```

### 6. Completion (الإنجاز)
```
Status: approved/completed
```
**If Approved:**
- Task marked as completed
- SLA compliance calculated
- Performance metrics updated
- Employee notified

**If Rejected:**
- Task goes back to in-progress
- Employee must address QA comments
- Can resubmit after fixes

---

## Department Management

### Features
- Hierarchical organization structure
- Department managers
- Custom colors for visual identification
- Active/inactive status

### Operations

**Create Department:**
```javascript
POST /api/departments
{
  "name": "Engineering",
  "description": "Software Engineering Department",
  "manager": "userId",
  "color": "#3498db"
}
```

**Get All Departments:**
```javascript
GET /api/departments
```

**Update Department:**
```javascript
PUT /api/departments/:id
{
  "name": "Updated Name",
  "color": "#e74c3c"
}
```

---

## Project Management

### Features
- Associated with department
- Project manager and team members
- Status tracking (planning, active, on-hold, completed, cancelled)
- Start and end dates
- Custom color coding

### Operations

**Create Project:**
```javascript
POST /api/projects
{
  "name": "Website Redesign",
  "description": "Complete website redesign",
  "department": "departmentId",
  "manager": "userId",
  "members": ["userId1", "userId2"],
  "status": "active",
  "startDate": "2024-01-01",
  "endDate": "2024-06-30",
  "color": "#2ecc71"
}
```

**Filter Projects:**
```javascript
GET /api/projects?department=id&status=active
```

---

## Task Management

### Task Properties
- **Basic Info**: Title, description, tags
- **Organization**: Project, department
- **Assignment**: Assigned to, assigned by
- **Scheduling**: Start date, due date, SLA threshold
- **Status**: Current workflow status
- **Priority**: Low, medium, high, urgent
- **Visual**: Custom color
- **QA**: QA reviewer, status, comments

### Task Operations

**Create Task:**
```javascript
POST /api/tasks
{
  "title": "Design Homepage",
  "description": "Create new homepage design",
  "project": "projectId",
  "department": "departmentId",
  "assignedTo": "userId",
  "priority": "high",
  "color": "#e74c3c",
  "dueDate": "2024-12-31",
  "slaThreshold": 48,
  "tags": ["design", "urgent"]
}
```

**Get Tasks with Filtering:**
```javascript
GET /api/tasks?status=assigned&priority=high&department=id&page=1&limit=20
```

**Update Task:**
```javascript
PUT /api/tasks/:id
{
  "priority": "urgent",
  "dueDate": "2024-12-25"
}
```

---

## File Attachments

### Features
- Multiple file uploads per task
- Support for images, documents, archives
- 10MB file size limit
- File type validation
- Attachment types: evidence, document, image, other
- Download capability

### Supported File Types
- **Images**: jpeg, jpg, png, gif
- **Documents**: pdf, doc, docx, xls, xlsx, txt
- **Archives**: zip, rar

### Operations

**Upload File:**
```javascript
POST /api/attachments
Form-data:
  - file: <file>
  - taskId: "taskId"
  - description: "Completion evidence"
  - attachmentType: "evidence"
```

**Get Task Attachments:**
```javascript
GET /api/attachments/task/:taskId
```

**Download File:**
```javascript
GET /api/attachments/:id/download
```

---

## Comments and Mentions

### Features
- Comment on any task
- Mention users with @userId
- Notifications sent to mentioned users
- Edit and delete own comments
- Timeline integration

### Operations

**Add Comment:**
```javascript
POST /api/comments
{
  "taskId": "taskId",
  "content": "Great progress! @userId123 please review",
  "mentions": ["userId123"]
}
```

**Get Task Comments:**
```javascript
GET /api/comments/task/:taskId
```

**Update Comment:**
```javascript
PUT /api/comments/:id
{
  "content": "Updated comment text"
}
```

---

## Notifications

### Notification Types
1. **task_assigned**: New task assignment
2. **task_updated**: Task details changed
3. **task_due_soon**: Task due within 24 hours
4. **task_overdue**: Task past due date
5. **task_commented**: New comment added
6. **task_mentioned**: User mentioned in comment
7. **task_approved**: QA approval
8. **task_rejected**: QA rejection
9. **task_completed**: Task completed
10. **reminder**: General reminders

### Operations

**Get Notifications:**
```javascript
GET /api/notifications?isRead=false&page=1&limit=20
```

**Mark as Read:**
```javascript
PATCH /api/notifications/:id/read
```

**Mark All as Read:**
```javascript
PATCH /api/notifications/read-all
```

---

## Audit Trail

### Tracked Actions
- Task creation
- Task assignment
- Status changes
- Field updates
- Priority changes
- Due date changes
- Reassignment
- Comments added
- Attachments added
- QA approvals/rejections

### Audit Log Structure
```javascript
{
  "task": "taskId",
  "user": "userId",
  "action": "status_changed",
  "previousValue": "in-progress",
  "newValue": "pending-review",
  "description": "Status changed from in-progress to pending-review",
  "ipAddress": "192.168.1.1",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### Access Audit Trail
Audit logs are automatically included when fetching task details:
```javascript
GET /api/tasks/:id
// Returns task with auditLogs array
```

---

## Performance Metrics

### Metrics Tracked
1. **Total Tasks**: All tasks count
2. **Completed Tasks**: Tasks with status completed/approved
3. **Tasks Completed On Time**: Met SLA threshold
4. **Overdue Tasks**: Past due date and not completed
5. **Completion Rate**: Percentage of completed tasks
6. **On-Time Rate**: Percentage of tasks completed within SLA

### Filtering Options
- By user/employee
- By department
- By date range

### API Endpoint
```javascript
GET /api/tasks/metrics/performance?userId=id&departmentId=id&startDate=2024-01-01&endDate=2024-12-31
```

### Response Format
```javascript
{
  "metrics": {
    "totalTasks": 100,
    "completedTasks": 75,
    "tasksCompletedOnTime": 60,
    "overdueTasks": 10,
    "completionRate": "75.00",
    "onTimeRate": "80.00"
  }
}
```

---

## Filtering and Search

### Available Filters

**Tasks:**
- Status (assigned, in-progress, pending-review, approved, rejected, completed)
- Department
- Project
- Assigned user
- Priority (low, medium, high, urgent)
- Search (title, description, tags)
- Sort by (createdAt, dueDate, priority)
- Pagination (page, limit)

**Example:**
```javascript
GET /api/tasks?status=in-progress&priority=high&department=id&search=homepage&sortBy=dueDate&sortOrder=asc&page=1&limit=20
```

**Projects:**
- Department
- Status

**Users:**
- Department
- Role
- Search (name, email)

---

## Automated Features

### 1. Hourly Reminder Job
**Runs every hour to check:**
- Tasks due within 24 hours → sends "task_due_soon" notification
- Overdue tasks → sends "task_overdue" notification

### 2. SLA Compliance Tracking
**Automatically calculated when task is completed:**
- Compares completion time vs SLA threshold
- Sets `isCompletedOnTime` flag
- Used in performance metrics

### 3. Audit Logging
**Automatically logs all actions:**
- Every task change tracked
- User and timestamp recorded
- Previous and new values stored

### 4. Notification System
**Automatic notifications for:**
- Task assignments
- Status changes
- Comments and mentions
- QA decisions
- Due date reminders

---

## Best Practices

### For Admins
1. Set up departments first
2. Create projects within departments
3. Assign appropriate managers
4. Configure SLA thresholds based on task complexity

### For Managers
1. Clearly define task requirements
2. Set realistic deadlines
3. Assign tasks to appropriate team members
4. Monitor team performance metrics

### For Employees
1. Update task status regularly
2. Upload evidence before submitting for review
3. Add comments for clarifications
4. Submit for review only when fully complete

### For QA Reviewers
1. Review evidence thoroughly
2. Provide constructive feedback in comments
3. Be consistent in approval criteria
4. Act on reviews promptly

---

## Security Considerations

1. **Authentication**: All endpoints require JWT token (except login/register)
2. **Authorization**: Role-based access control
3. **Password Security**: Passwords hashed with bcrypt
4. **File Validation**: File type and size checks
5. **Input Validation**: All inputs validated
6. **Error Handling**: Secure error messages

---

## Troubleshooting

### Common Issues

**Can't create task:**
- Check if you have manager/admin role
- Verify department and project IDs exist
- Ensure due date is in the future

**Can't upload file:**
- Check file size (max 10MB)
- Verify file type is supported
- Ensure you have authentication token

**Notifications not received:**
- Check notification endpoint for unread notifications
- Verify user has valid email
- Check server logs for scheduled job execution

---

## Future Enhancements

Potential features for future releases:
- Real-time notifications with WebSockets
- Email notifications
- Calendar integration
- Task templates
- Gantt charts for project visualization
- Mobile app
- Advanced analytics dashboard
- Team collaboration features
- Time tracking
- Recurring tasks

---

For more information, see:
- [API Documentation](API_DOCUMENTATION.md)
- [README](README.md)
- [Contributing Guide](CONTRIBUTING.md)
