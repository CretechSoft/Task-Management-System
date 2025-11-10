const express = require('express');
const router = express.Router();
const projectController = require('../controllers/projectController');
const { auth, authorize } = require('../middleware/auth');

// Create Project
router.post('/', auth, authorize('admin', 'manager'), projectController.createProject);

// Get All Projects
router.get('/', auth, projectController.getProjects);

// Get Single Project
router.get('/:id', auth, projectController.getProject);

// Update Project
router.put('/:id', auth, authorize('admin', 'manager'), projectController.updateProject);

// Delete Project
router.delete('/:id', auth, authorize('admin', 'manager'), projectController.deleteProject);

module.exports = router;
