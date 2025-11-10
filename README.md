# Task Management System | نظام إدارة المهام المؤسسي

Enterprise task management system that connects employees to departments and projects with complete lifecycle management from assignment to QA approval.

نظام إدارة مهام مؤسسي بربط الموظفين بالأقسام والمشاريع، مع دورة حياة كاملة: إسناد → تنفيذ مع رفع ملفات وصور → فحص جودة وإقرار/رفض.

## 🌟 Features | المميزات

### Core Features
- ✅ **Complete Task Lifecycle**: Assignment → Execution → QA Review → Approval/Rejection
- 👥 **User Management**: Multiple roles (Admin, Manager, Employee, QA)
- 🏢 **Department & Project Organization**: Hierarchical structure
- 📎 **File Attachments**: Upload evidence, images, and documents (up to 10MB)
- 💬 **Comments & Mentions**: Collaborate with team members using @mentions
- 📊 **Performance Metrics**: Track completion rates and SLA compliance
- 🔔 **Real-time Notifications**: Alerts for assignments, updates, and deadlines
- 🎨 **Customization**: Colors, priorities, tags for tasks and projects
- 📜 **Complete Audit Trail**: Track every change with timestamps
- ⏰ **SLA Tracking**: Monitor deadline compliance with automated reminders
- 🔍 **Advanced Filtering**: By status, department, project, priority, assignee
- 🌐 **Bilingual Support**: Arabic and English

### Task Features
- **Priorities**: Low, Medium, High, Urgent
- **Statuses**: Assigned, In Progress, Pending Review, Approved, Rejected, Completed
- **Colors**: Custom color coding for better organization
- **Tags**: Flexible tagging system
- **Due Dates**: With SLA threshold tracking
- **Timeline**: Visual timeline of all task activities

### Quality Assurance
- QA Review workflow with approval/rejection
- QA comments and feedback
- Evidence upload requirements
- Completion verification

### Notifications & Reminders
- Task assignment notifications
- Due date reminders (24 hours before)
- Overdue task alerts
- Comment and mention notifications
- Status change notifications
- Automated hourly checks

### Performance Tracking
- Total tasks count
- Completion rate
- On-time completion rate
- Overdue tasks tracking
- Filter by user, department, date range

## 🚀 Technology Stack

- **Backend**: Node.js, Express.js
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT (JSON Web Tokens)
- **File Upload**: Multer
- **Scheduling**: Node-schedule (automated reminders)
- **Security**: bcrypt password hashing

## 📋 Prerequisites

- Node.js (v14 or higher)
- MongoDB (v4.4 or higher)
- npm or yarn

## 🛠️ Installation

1. **Clone the repository**
```bash
git clone https://github.com/CretechSoft/Task-Management-System.git
cd Task-Management-System
```

2. **Install dependencies**
```bash
npm install
```

3. **Configure environment variables**
```bash
cp .env.example .env
```

Edit `.env` file with your configuration:
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/task-management
JWT_SECRET=your-secret-key-change-this-in-production
NODE_ENV=development
```

4. **Start MongoDB**
```bash
# Make sure MongoDB is running
mongod
```

5. **Start the server**
```bash
# Development mode (with auto-reload)
npm run dev

# Production mode
npm start
```

The server will start on `http://localhost:5000`

## 📖 Documentation

- **API Documentation**: See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for complete API reference
- **Demo UI**: Open `index.html` in a browser for an overview
- **Health Check**: `GET /api/health`

## 🔑 API Quick Start

### Authentication

**Register**
```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "role": "employee"
  }'
```

**Login**
```bash
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Create Task
```bash
curl -X POST http://localhost:5000/api/tasks \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Design Homepage",
    "description": "Create new homepage design",
    "project": "PROJECT_ID",
    "department": "DEPARTMENT_ID",
    "assignedTo": "USER_ID",
    "priority": "high",
    "dueDate": "2024-12-31"
  }'
```

## 🏗️ Project Structure

```
Task-Management-System/
├── backend/
│   ├── models/          # Database models
│   │   ├── User.js
│   │   ├── Department.js
│   │   ├── Project.js
│   │   ├── Task.js
│   │   ├── Attachment.js
│   │   ├── Comment.js
│   │   ├── AuditLog.js
│   │   └── Notification.js
│   ├── controllers/     # Request handlers
│   │   ├── authController.js
│   │   ├── taskController.js
│   │   ├── attachmentController.js
│   │   ├── commentController.js
│   │   ├── departmentController.js
│   │   ├── projectController.js
│   │   └── notificationController.js
│   ├── routes/          # API routes
│   ├── middleware/      # Custom middleware
│   ├── config/          # Configuration files
│   └── utils/           # Utility functions
├── uploads/             # File uploads storage
├── server.js            # Main application file
├── package.json
├── .env.example
└── README.md
```

## 👥 User Roles

| Role | Permissions |
|------|-------------|
| **Admin** | Full system access, manage users, departments, projects |
| **Manager** | Create/assign tasks, manage projects, view team metrics |
| **QA** | Review tasks, approve/reject, add QA comments |
| **Employee** | Work on assigned tasks, upload evidence, comment |

## 📊 Task Workflow

```
1. Assignment (Assigned)
   ↓
2. Execution (In Progress)
   ↓
3. Submit for Review (Pending Review)
   ↓
4. QA Review
   ↓
5a. Approved → Completed
   OR
5b. Rejected → Back to In Progress
```

## 🔔 Automated Features

- **Hourly Reminder Job**: Checks for tasks due within 24 hours and sends notifications
- **Overdue Alerts**: Automatically notifies users of overdue tasks
- **Audit Logging**: Every action is automatically logged
- **SLA Compliance**: Automatic calculation when tasks are completed

## 🔒 Security Features

- Password hashing with bcrypt
- JWT token-based authentication
- Role-based access control (RBAC)
- File type validation for uploads
- File size limits (10MB max)
- Protected API routes
- Input validation

## 📈 Performance Metrics

Track and measure:
- Total tasks by user/department
- Completion rates
- On-time completion percentage
- Overdue tasks count
- Average completion time
- SLA compliance rates

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

ISC

## 💬 Support

For issues and questions, please open an issue on GitHub.

## 🌟 Acknowledgments

Built with modern web technologies to provide a comprehensive enterprise task management solution.
