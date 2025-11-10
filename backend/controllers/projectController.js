const Project = require('../models/Project');

// Create Project
exports.createProject = async (req, res) => {
  try {
    const { name, description, department, manager, members, status, startDate, endDate, color } = req.body;

    const project = new Project({
      name,
      description,
      department,
      manager,
      members,
      status,
      startDate,
      endDate,
      color
    });

    await project.save();

    const populatedProject = await Project.findById(project._id)
      .populate('department', 'name')
      .populate('manager', 'name email')
      .populate('members', 'name email');

    res.status(201).json({
      message: 'Project created successfully',
      project: populatedProject
    });
  } catch (error) {
    console.error('Create project error:', error);
    res.status(500).json({ message: 'Server error while creating project' });
  }
};

// Get All Projects
exports.getProjects = async (req, res) => {
  try {
    const { department, status } = req.query;
    const filter = {};

    if (department) filter.department = department;
    if (status) filter.status = status;

    const projects = await Project.find(filter)
      .populate('department', 'name color')
      .populate('manager', 'name email')
      .populate('members', 'name email')
      .sort({ createdAt: -1 });

    res.json({ projects });
  } catch (error) {
    console.error('Get projects error:', error);
    res.status(500).json({ message: 'Server error while fetching projects' });
  }
};

// Get Single Project
exports.getProject = async (req, res) => {
  try {
    const project = await Project.findById(req.params.id)
      .populate('department', 'name color')
      .populate('manager', 'name email')
      .populate('members', 'name email avatar');

    if (!project) {
      return res.status(404).json({ message: 'Project not found' });
    }

    res.json({ project });
  } catch (error) {
    console.error('Get project error:', error);
    res.status(500).json({ message: 'Server error while fetching project' });
  }
};

// Update Project
exports.updateProject = async (req, res) => {
  try {
    const updates = req.body;
    const project = await Project.findById(req.params.id);

    if (!project) {
      return res.status(404).json({ message: 'Project not found' });
    }

    Object.keys(updates).forEach(key => {
      project[key] = updates[key];
    });

    await project.save();

    const updatedProject = await Project.findById(project._id)
      .populate('department', 'name')
      .populate('manager', 'name email')
      .populate('members', 'name email');

    res.json({
      message: 'Project updated successfully',
      project: updatedProject
    });
  } catch (error) {
    console.error('Update project error:', error);
    res.status(500).json({ message: 'Server error while updating project' });
  }
};

// Delete Project
exports.deleteProject = async (req, res) => {
  try {
    const project = await Project.findById(req.params.id);

    if (!project) {
      return res.status(404).json({ message: 'Project not found' });
    }

    await Project.findByIdAndDelete(req.params.id);

    res.json({ message: 'Project deleted successfully' });
  } catch (error) {
    console.error('Delete project error:', error);
    res.status(500).json({ message: 'Server error while deleting project' });
  }
};
