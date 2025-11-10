const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const authController = require('../controllers/authController');
const { auth, authorize } = require('../middleware/auth');

// Register
router.post('/register', [
  body('name').notEmpty().trim().withMessage('Name is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
], authController.register);

// Login
router.post('/login', authController.login);

// Get Current User
router.get('/me', auth, authController.getCurrentUser);

// Get All Users (Admin/Manager only)
router.get('/users', auth, authorize('admin', 'manager'), authController.getUsers);

// Update User (Admin only)
router.put('/users/:id', auth, authorize('admin'), authController.updateUser);

module.exports = router;
