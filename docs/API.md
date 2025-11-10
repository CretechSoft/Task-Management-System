# API Documentation

## Base URL
```
https://api.taskmanagement.com/v1
```

## Authentication

All API requests require authentication using Bearer token in the header:
```
Authorization: Bearer {token}
```

### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "usr-001",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "employee",
    "departmentId": "dept-001",
    "avatarUrl": "https://...",
    "isActive": true
  }
}
```

## Tasks

### List Tasks
```http
GET /tasks?status=in_progress&assigneeId=usr-001&projectId=prj-001&page=1&size=20
```

**Query Parameters:**
- `status` - Filter by task status (draft, assigned, in_progress, submitted_for_review, qa_approved, qa_rejected)
- `assigneeId` - Filter by assignee user ID
- `projectId` - Filter by project ID
- `departmentId` - Filter by department ID
- `priority` - Filter by priority (low, medium, high, urgent)
- `q` - Search query
- `dueFrom` - Filter tasks due from this date (ISO 8601)
- `dueTo` - Filter tasks due until this date (ISO 8601)
- `page` - Page number (default: 1)
- `size` - Page size (default: 20, max: 100)

**Response:**
```json
{
  "data": [
    {
      "id": "tsk-001",
      "title": "Implement authentication",
      "description": "Create login and registration",
      "projectId": "prj-001",
      "departmentId": "dept-001",
      "assigneeId": "usr-001",
      "createdBy": "usr-002",
      "priority": "high",
      "status": "in_progress",
      "colorHex": "#FF9800",
      "slaDueAt": "2024-01-15T23:59:59Z",
      "startAt": "2024-01-10T09:00:00Z",
      "endAt": null,
      "progress": 65,
      "tags": ["backend", "security"],
      "createdAt": "2024-01-08T10:00:00Z",
      "updatedAt": "2024-01-12T15:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "size": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

### Create Task
```http
POST /tasks
Content-Type: application/json

{
  "title": "Design user interface",
  "description": "Create mockups for the dashboard",
  "projectId": "prj-001",
  "departmentId": "dept-002",
  "assigneeId": "usr-003",
  "priority": "medium",
  "slaDueAt": "2024-01-20T23:59:59Z",
  "tags": ["design", "ui"]
}
```

### Get Task Details
```http
GET /tasks/{taskId}
```

### Update Task
```http
PUT /tasks/{taskId}
Content-Type: application/json

{
  "title": "Updated title",
  "description": "Updated description",
  "priority": "high",
  "progress": 75
}
```

### Change Task Status
```http
PATCH /tasks/{taskId}/status
Content-Type: application/json

{
  "toStatus": "submitted_for_review",
  "note": "Completed all requirements"
}
```

### Upload Attachment
```http
POST /tasks/{taskId}/attachments
Content-Type: multipart/form-data

file: (binary)
type: "image"
name: "screenshot.png"
```

**Response:**
```json
{
  "id": "att-001",
  "taskId": "tsk-001",
  "type": "image",
  "url": "https://storage.example.com/tsk-001-20240112153045-abc123.png",
  "name": "screenshot.png",
  "size": 1024567,
  "createdBy": "usr-001",
  "createdAt": "2024-01-12T15:30:45Z"
}
```

### List Attachments
```http
GET /tasks/{taskId}/attachments
```

### Add Comment
```http
POST /tasks/{taskId}/comments
Content-Type: application/json

{
  "text": "Great progress! @usr-002 please review",
  "mentions": ["usr-002"]
}
```

### Get Timeline
```http
GET /tasks/{taskId}/timeline
```

**Response:**
```json
{
  "data": [
    {
      "type": "status_change",
      "id": "aud-001",
      "taskId": "tsk-001",
      "fromStatus": "assigned",
      "toStatus": "in_progress",
      "byUserId": "usr-001",
      "note": "Started working on this",
      "at": "2024-01-10T09:00:00Z"
    },
    {
      "type": "comment",
      "id": "cmt-001",
      "taskId": "tsk-001",
      "authorId": "usr-002",
      "text": "Looking good!",
      "mentions": [],
      "createdAt": "2024-01-11T14:00:00Z"
    }
  ]
}
```

## Projects

### List Projects
```http
GET /projects?isActive=true
```

### Get Project
```http
GET /projects/{projectId}
```

## Departments

### List Departments
```http
GET /departments
```

### Get Department
```http
GET /departments/{departmentId}
```

## Users

### List Users
```http
GET /users?departmentId=dept-001&role=employee
```

### Get User
```http
GET /users/{userId}
```

## Notifications

### Get Notifications
```http
GET /notifications?isRead=false&page=1&size=20
```

### Mark as Read
```http
PATCH /notifications/{notificationId}/read
```

### Mark All as Read
```http
POST /notifications/read-all
```

## Reminders

### Create Reminder
```http
POST /tasks/{taskId}/reminders
Content-Type: application/json

{
  "at": "2024-01-14T09:00:00Z",
  "channel": "push"
}
```

## Error Responses

All error responses follow this format:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "title",
        "message": "Title is required"
      }
    ]
  }
}
```

**Common Error Codes:**
- `UNAUTHORIZED` - Invalid or missing authentication token
- `FORBIDDEN` - User doesn't have permission for this action
- `NOT_FOUND` - Requested resource not found
- `VALIDATION_ERROR` - Input validation failed
- `CONFLICT` - Resource conflict (e.g., duplicate)
- `SERVER_ERROR` - Internal server error

## Rate Limiting

API requests are limited to:
- 100 requests per minute for authenticated users
- 20 requests per minute for unauthenticated requests

Rate limit headers are included in responses:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1642089600
```

## Webhooks

The API can send webhooks for important events:

**Events:**
- `task.created`
- `task.updated`
- `task.status_changed`
- `task.assigned`
- `comment.created`
- `attachment.uploaded`

**Webhook Payload:**
```json
{
  "event": "task.status_changed",
  "timestamp": "2024-01-12T15:30:00Z",
  "data": {
    "taskId": "tsk-001",
    "fromStatus": "in_progress",
    "toStatus": "submitted_for_review",
    "byUserId": "usr-001"
  }
}
```
