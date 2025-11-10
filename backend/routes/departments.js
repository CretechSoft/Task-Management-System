const express = require('express');
const router = express.Router();
const departmentController = require('../controllers/departmentController');
const { auth, authorize } = require('../middleware/auth');

// Create Department
router.post('/', auth, authorize('admin'), departmentController.createDepartment);

// Get All Departments
router.get('/', auth, departmentController.getDepartments);

// Get Single Department
router.get('/:id', auth, departmentController.getDepartment);

// Update Department
router.put('/:id', auth, authorize('admin'), departmentController.updateDepartment);

// Delete Department
router.delete('/:id', auth, authorize('admin'), departmentController.deleteDepartment);

module.exports = router;
