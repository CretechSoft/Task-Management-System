# Task Management System - API Documentation

## Overview

Enterprise task management system that connects employees to departments and projects with complete lifecycle management from assignment to QA approval.

## Features

- 👥 **User Management**: Employees, managers, QA reviewers, and admins
- 🏢 **Department & Project Organization**: Hierarchical structure
- 📋 **Task Lifecycle**: Assignment → Execution → QA Review → Approval/Rejection
- 📎 **File Attachments**: Upload evidence, images, and documents
- 💬 **Comments & Mentions**: Collaborate with team members
- 📊 **Performance Metrics**: Track completion rates and SLA compliance
- 🔔 **Notifications**: Real-time alerts and reminders
- 🎨 **Customization**: Colors, priorities, and tags
- 📜 **Audit Trail**: Complete history of all changes
- ⏰ **SLA Tracking**: Monitor deadline compliance

## Technology Stack

- **Backend**: Node.js, Express.js
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT (JSON Web Tokens)
- **File Upload**: Multer
- **Scheduling**: Node-schedule (for reminders)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/CretechSoft/Task-Management-System.git
cd Task-Management-System
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file (copy from `.env.example`):
```bash
cp .env.example .env
```

4. Configure environment variables in `.env`:
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/task-management
JWT_SECRET=your-secret-key-change-this-in-production
NODE_ENV=development
```

5. Make sure MongoDB is running on your system

6. Start the server:
```bash
# Development mode with auto-reload
npm run dev

# Production mode
npm start
```

## API Endpoints

### Authentication

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "employee",
  "department": "departmentId"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

#### Get Current User
```http
GET /api/auth/me
Authorization: Bearer <token>
```

#### Get All Users
```http
GET /api/auth/users?department=<id>&role=<role>&search=<query>
Authorization: Bearer <token>
```

### Departments

#### Create Department
```http
POST /api/departments
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Engineering",
  "description": "Engineering Department",
  "manager": "userId",
  "color": "#3498db"
}
```

#### Get All Departments
```http
GET /api/departments
Authorization: Bearer <token>
```

#### Get Single Department
```http
GET /api/departments/:id
Authorization: Bearer <token>
```

#### Update Department
```http
PUT /api/departments/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Updated Engineering",
  "description": "Updated description"
}
```

### Projects

#### Create Project
```http
POST /api/projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Website Redesign",
  "description": "Complete website redesign project",
  "department": "departmentId",
  "manager": "userId",
  "members": ["userId1", "userId2"],
  "status": "active",
  "startDate": "2024-01-01",
  "endDate": "2024-06-30",
  "color": "#2ecc71"
}
```

#### Get All Projects
```http
GET /api/projects?department=<id>&status=<status>
Authorization: Bearer <token>
```

#### Get Single Project
```http
GET /api/projects/:id
Authorization: Bearer <token>
```

### Tasks

#### Create Task
```http
POST /api/tasks
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Design Homepage",
  "description": "Create new homepage design mockups",
  "project": "projectId",
  "department": "departmentId",
  "assignedTo": "userId",
  "priority": "high",
  "color": "#e74c3c",
  "dueDate": "2024-02-15",
  "slaThreshold": 48,
  "tags": ["design", "urgent"]
}
```

#### Get All Tasks
```http
GET /api/tasks?status=<status>&department=<id>&project=<id>&assignedTo=<userId>&priority=<priority>&search=<query>&page=1&limit=20
Authorization: Bearer <token>
```

#### Get Single Task
```http
GET /api/tasks/:id
Authorization: Bearer <token>
```

Returns task with attachments, comments, and audit trail.

#### Update Task
```http
PUT /api/tasks/:id
Authorization: Bearer <token>
Content-Type: application/json

{
  "title": "Updated Title",
  "priority": "urgent"
}
```

#### Update Task Status
```http
PATCH /api/tasks/:id/status
Authorization: Bearer <token>
Content-Type: application/json

{
  "status": "in-progress"
}
```

**Status Flow:**
- `assigned` → Initial state when task is created
- `in-progress` → Employee starts working
- `pending-review` → Submitted for QA review
- `approved` → QA approved
- `rejected` → QA rejected
- `completed` → Final state

#### Submit for Review
```http
POST /api/tasks/:id/submit-review
Authorization: Bearer <token>
```

#### QA Review (Approve/Reject)
```http
POST /api/tasks/:id/qa-review
Authorization: Bearer <token>
Content-Type: application/json

{
  "qaStatus": "passed",
  "qaComments": "Great work! Approved."
}
```

#### Get Performance Metrics
```http
GET /api/tasks/metrics/performance?userId=<id>&departmentId=<id>&startDate=<date>&endDate=<date>
Authorization: Bearer <token>
```

### Attachments

#### Upload Attachment
```http
POST /api/attachments
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "file": <file>,
  "taskId": "taskId",
  "description": "Evidence of completion",
  "attachmentType": "evidence"
}
```

**Attachment Types:**
- `evidence` - Proof of task completion
- `document` - Supporting documents
- `image` - Images
- `other` - Other files

**Allowed File Types:**
- Images: jpeg, jpg, png, gif
- Documents: pdf, doc, docx, xls, xlsx, txt
- Archives: zip, rar

**Max File Size:** 10MB

#### Get Task Attachments
```http
GET /api/attachments/task/:taskId
Authorization: Bearer <token>
```

#### Download Attachment
```http
GET /api/attachments/:id/download
Authorization: Bearer <token>
```

### Comments

#### Create Comment
```http
POST /api/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "taskId": "taskId",
  "content": "This looks good! @userId great work",
  "mentions": ["userId"]
}
```

#### Get Task Comments
```http
GET /api/comments/task/:taskId
Authorization: Bearer <token>
```

### Notifications

#### Get User Notifications
```http
GET /api/notifications?page=1&limit=20&isRead=false
Authorization: Bearer <token>
```

#### Mark as Read
```http
PATCH /api/notifications/:id/read
Authorization: Bearer <token>
```

#### Mark All as Read
```http
PATCH /api/notifications/read-all
Authorization: Bearer <token>
```

## User Roles

- **admin**: Full system access
- **manager**: Can create tasks, projects, and manage teams
- **qa**: Quality assurance reviewers
- **employee**: Regular employees assigned to tasks

## Task Priorities

- **low**: Low priority tasks
- **medium**: Normal priority (default)
- **high**: High priority
- **urgent**: Urgent tasks requiring immediate attention

## Notification Types

- `task_assigned`: New task assignment
- `task_updated`: Task updated
- `task_due_soon`: Task due within 24 hours
- `task_overdue`: Task is overdue
- `task_commented`: New comment on task
- `task_mentioned`: User mentioned in comment
- `task_approved`: Task approved by QA
- `task_rejected`: Task rejected by QA
- `task_completed`: Task completed
- `reminder`: General reminder

## Automated Features

### Scheduled Reminders
The system automatically runs hourly to:
- Send notifications for tasks due within 24 hours
- Alert users about overdue tasks

### Audit Trail
Every action is automatically logged:
- Task creation
- Status changes
- Assignments/Reassignments
- Comments
- Attachments
- Updates to any field

### SLA Compliance
Tasks track completion time and compare against SLA threshold:
- Automatically calculated when task is completed
- Included in performance metrics

## Performance Metrics

The system tracks:
- Total tasks
- Completed tasks
- Tasks completed on time
- Overdue tasks
- Completion rate percentage
- On-time completion rate percentage

Metrics can be filtered by:
- User
- Department
- Date range

## Error Handling

All API endpoints return consistent error responses:

```json
{
  "message": "Error description"
}
```

**Common HTTP Status Codes:**
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Internal Server Error

## Security

- Passwords are hashed using bcrypt
- JWT tokens for authentication
- Role-based access control (RBAC)
- File type validation for uploads
- File size limits
- Protected routes with middleware

## Database Schema

### User
- name, email, password, role, department
- avatar, isActive

### Department
- name, description, manager, color

### Project
- name, description, department, manager, members
- status, startDate, endDate, color

### Task
- title, description, project, department
- assignedTo, assignedBy, status, priority, color
- startDate, dueDate, completedDate
- slaThreshold, tags
- qaReviewer, qaStatus, qaComments, qaReviewDate
- isCompletedOnTime

### Attachment
- task, uploadedBy, fileName, originalName
- filePath, fileType, fileSize, mimeType
- description, attachmentType

### Comment
- task, user, content, mentions

### AuditLog
- task, user, action
- previousValue, newValue, description

### Notification
- recipient, sender, task, type
- title, message, isRead, readAt

## Development

To extend the system:

1. **Add new models**: Create in `backend/models/`
2. **Add controllers**: Create in `backend/controllers/`
3. **Add routes**: Create in `backend/routes/`
4. **Update server.js**: Import and use new routes

## Support

For issues and questions, please open an issue on GitHub.

## License

ISC
