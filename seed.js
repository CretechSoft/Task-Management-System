require('dotenv').config();
const mongoose = require('mongoose');
const User = require('./backend/models/User');
const Department = require('./backend/models/Department');
const Project = require('./backend/models/Project');
const Task = require('./backend/models/Task');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('MongoDB Connected');
  } catch (error) {
    console.error('Error connecting to MongoDB:', error);
    process.exit(1);
  }
};

const seedData = async () => {
  try {
    await connectDB();

    // Clear existing data
    console.log('Clearing existing data...');
    await User.deleteMany({});
    await Department.deleteMany({});
    await Project.deleteMany({});
    await Task.deleteMany({});

    // Create Users
    console.log('Creating users...');
    const admin = await User.create({
      name: 'Admin User',
      email: 'admin@taskmanagement.com',
      password: 'admin123',
      role: 'admin'
    });

    const manager = await User.create({
      name: 'Manager User',
      email: 'manager@taskmanagement.com',
      password: 'manager123',
      role: 'manager'
    });

    const qaUser = await User.create({
      name: 'QA Reviewer',
      email: 'qa@taskmanagement.com',
      password: 'qa123',
      role: 'qa'
    });

    const employee1 = await User.create({
      name: 'John Doe',
      email: 'john@taskmanagement.com',
      password: 'employee123',
      role: 'employee'
    });

    const employee2 = await User.create({
      name: 'Jane Smith',
      email: 'jane@taskmanagement.com',
      password: 'employee123',
      role: 'employee'
    });

    console.log('Users created successfully!');

    // Create Departments
    console.log('Creating departments...');
    const engineeringDept = await Department.create({
      name: 'Engineering',
      description: 'Software Engineering Department',
      manager: manager._id,
      color: '#3498db'
    });

    const designDept = await Department.create({
      name: 'Design',
      description: 'Design and UX Department',
      manager: manager._id,
      color: '#9b59b6'
    });

    const marketingDept = await Department.create({
      name: 'Marketing',
      description: 'Marketing and Sales Department',
      manager: manager._id,
      color: '#e74c3c'
    });

    console.log('Departments created successfully!');

    // Update users with departments
    employee1.department = engineeringDept._id;
    await employee1.save();
    employee2.department = designDept._id;
    await employee2.save();
    qaUser.department = engineeringDept._id;
    await qaUser.save();

    // Create Projects
    console.log('Creating projects...');
    const websiteProject = await Project.create({
      name: 'Website Redesign',
      description: 'Complete redesign of company website',
      department: engineeringDept._id,
      manager: manager._id,
      members: [employee1._id, employee2._id],
      status: 'active',
      startDate: new Date('2024-01-01'),
      endDate: new Date('2024-06-30'),
      color: '#2ecc71'
    });

    const mobileProject = await Project.create({
      name: 'Mobile App Development',
      description: 'Develop new mobile application',
      department: engineeringDept._id,
      manager: manager._id,
      members: [employee1._id],
      status: 'active',
      startDate: new Date('2024-02-01'),
      endDate: new Date('2024-08-31'),
      color: '#f39c12'
    });

    const brandingProject = await Project.create({
      name: 'Brand Refresh',
      description: 'Update company branding and visual identity',
      department: designDept._id,
      manager: manager._id,
      members: [employee2._id],
      status: 'planning',
      startDate: new Date('2024-03-01'),
      endDate: new Date('2024-05-31'),
      color: '#e67e22'
    });

    console.log('Projects created successfully!');

    // Create Tasks
    console.log('Creating tasks...');
    const task1 = await Task.create({
      title: 'Design Homepage Mockup',
      description: 'Create high-fidelity mockups for the new homepage',
      project: websiteProject._id,
      department: designDept._id,
      assignedTo: employee2._id,
      assignedBy: manager._id,
      status: 'assigned',
      priority: 'high',
      color: '#e74c3c',
      dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days from now
      slaThreshold: 48,
      tags: ['design', 'homepage', 'urgent']
    });

    const task2 = await Task.create({
      title: 'Implement Authentication API',
      description: 'Build REST API endpoints for user authentication',
      project: websiteProject._id,
      department: engineeringDept._id,
      assignedTo: employee1._id,
      assignedBy: manager._id,
      status: 'in-progress',
      priority: 'high',
      color: '#3498db',
      startDate: new Date(),
      dueDate: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000), // 5 days from now
      slaThreshold: 72,
      tags: ['backend', 'api', 'security']
    });

    const task3 = await Task.create({
      title: 'Setup Mobile App Framework',
      description: 'Initialize React Native project and setup basic structure',
      project: mobileProject._id,
      department: engineeringDept._id,
      assignedTo: employee1._id,
      assignedBy: manager._id,
      status: 'pending-review',
      priority: 'medium',
      color: '#f39c12',
      qaReviewer: qaUser._id,
      startDate: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000), // 3 days ago
      dueDate: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000), // 2 days from now
      slaThreshold: 96,
      tags: ['mobile', 'setup', 'react-native']
    });

    const task4 = await Task.create({
      title: 'Create Brand Style Guide',
      description: 'Document new brand colors, typography, and usage guidelines',
      project: brandingProject._id,
      department: designDept._id,
      assignedTo: employee2._id,
      assignedBy: manager._id,
      status: 'assigned',
      priority: 'medium',
      color: '#9b59b6',
      dueDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000), // 14 days from now
      slaThreshold: 120,
      tags: ['branding', 'documentation']
    });

    const task5 = await Task.create({
      title: 'Database Schema Design',
      description: 'Design and document database schema for the new system',
      project: websiteProject._id,
      department: engineeringDept._id,
      assignedTo: employee1._id,
      assignedBy: manager._id,
      status: 'approved',
      priority: 'high',
      color: '#27ae60',
      qaReviewer: qaUser._id,
      qaStatus: 'passed',
      qaComments: 'Excellent work! Schema is well-designed and scalable.',
      startDate: new Date(Date.now() - 10 * 24 * 60 * 60 * 1000), // 10 days ago
      dueDate: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000), // 3 days ago
      completedDate: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000), // 2 days ago
      qaReviewDate: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000), // 1 day ago
      isCompletedOnTime: true,
      slaThreshold: 120,
      tags: ['database', 'architecture']
    });

    console.log('Tasks created successfully!');

    console.log('\n✅ Database seeded successfully!\n');
    console.log('Sample Accounts:');
    console.log('================');
    console.log('Admin:');
    console.log('  Email: admin@taskmanagement.com');
    console.log('  Password: admin123');
    console.log('');
    console.log('Manager:');
    console.log('  Email: manager@taskmanagement.com');
    console.log('  Password: manager123');
    console.log('');
    console.log('QA Reviewer:');
    console.log('  Email: qa@taskmanagement.com');
    console.log('  Password: qa123');
    console.log('');
    console.log('Employee 1:');
    console.log('  Email: john@taskmanagement.com');
    console.log('  Password: employee123');
    console.log('');
    console.log('Employee 2:');
    console.log('  Email: jane@taskmanagement.com');
    console.log('  Password: employee123');
    console.log('');
    console.log('Summary:');
    console.log('- 5 Users created');
    console.log('- 3 Departments created');
    console.log('- 3 Projects created');
    console.log('- 5 Tasks created');
    console.log('');

    process.exit(0);
  } catch (error) {
    console.error('Error seeding database:', error);
    process.exit(1);
  }
};

seedData();
