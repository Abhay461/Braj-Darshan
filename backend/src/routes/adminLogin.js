const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const ApiError = require('../utils/ApiError');

// Simple PIN validation (same as client-side list) – replace with proper user store in production
const VALID_PINS = ['123456', '108108', 'admin'];

router.post('/login', (req, res) => {
  const { pin } = req.body;
  if (!VALID_PINS.includes(pin)) {
    throw ApiError.unauthorized('Invalid admin PIN');
  }
  // Generate short-lived JWT (30 minutes)
  const token = jwt.sign({ role: 'admin' }, process.env.JWT_SECRET, { expiresIn: '30m' });
  // Set HttpOnly Secure SameSite cookie
  res.cookie('token', token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 30 * 60 * 1000, // 30 minutes
  });
  res.json({ success: true, message: 'Authenticated' });
});

module.exports = router;
