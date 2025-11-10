const Department = require('../models/Department');

// Create Department
exports.createDepartment = async (req, res) => {
  try {
    const { name, description, manager, color } = req.body;

    const department = new Department({
      name,
      description,
      manager,
      color
    });

    await department.save();

    const populatedDept = await Department.findById(department._id)
      .populate('manager', 'name email');

    res.status(201).json({
      message: 'Department created successfully',
      department: populatedDept
    });
  } catch (error) {
    console.error('Create department error:', error);
    res.status(500).json({ message: 'Server error while creating department' });
  }
};

// Get All Departments
exports.getDepartments = async (req, res) => {
  try {
    const departments = await Department.find({ isActive: true })
      .populate('manager', 'name email')
      .sort({ name: 1 });

    res.json({ departments });
  } catch (error) {
    console.error('Get departments error:', error);
    res.status(500).json({ message: 'Server error while fetching departments' });
  }
};

// Get Single Department
exports.getDepartment = async (req, res) => {
  try {
    const department = await Department.findById(req.params.id)
      .populate('manager', 'name email');

    if (!department) {
      return res.status(404).json({ message: 'Department not found' });
    }

    res.json({ department });
  } catch (error) {
    console.error('Get department error:', error);
    res.status(500).json({ message: 'Server error while fetching department' });
  }
};

// Update Department
exports.updateDepartment = async (req, res) => {
  try {
    const { name, description, manager, color, isActive } = req.body;
    const department = await Department.findById(req.params.id);

    if (!department) {
      return res.status(404).json({ message: 'Department not found' });
    }

    if (name) department.name = name;
    if (description) department.description = description;
    if (manager) department.manager = manager;
    if (color) department.color = color;
    if (typeof isActive !== 'undefined') department.isActive = isActive;

    await department.save();

    const updatedDept = await Department.findById(department._id)
      .populate('manager', 'name email');

    res.json({
      message: 'Department updated successfully',
      department: updatedDept
    });
  } catch (error) {
    console.error('Update department error:', error);
    res.status(500).json({ message: 'Server error while updating department' });
  }
};

// Delete Department
exports.deleteDepartment = async (req, res) => {
  try {
    const department = await Department.findById(req.params.id);

    if (!department) {
      return res.status(404).json({ message: 'Department not found' });
    }

    await Department.findByIdAndDelete(req.params.id);

    res.json({ message: 'Department deleted successfully' });
  } catch (error) {
    console.error('Delete department error:', error);
    res.status(500).json({ message: 'Server error while deleting department' });
  }
};
