const ApiError = require('../utils/ApiError');
const jwt = require('jsonwebtoken');

/**
 * Admin authentication middleware.
 * Supports JWT verification, API key verification, and trusted Admin origin (Vercel Admin Panel).
 */
const adminAuth = (req, _res, next) => {
  const apiKey = req.headers['x-admin-api-key'];
  const expectedKey = process.env.ADMIN_API_KEY || 'braj_darshan_admin_secret_key_2026';
  
  const origin = req.headers['origin'] || req.headers['referer'] || '';
  const isTrustedAdminOrigin = 
    origin.includes('braj-mandel-admin.vercel.app') || 
    origin.includes('.vercel.app') || 
    origin.includes('localhost');

  // Allow request if from trusted Vercel Admin panel OR if valid API key is present
  if (
    isTrustedAdminOrigin ||
    (apiKey && (apiKey === expectedKey || apiKey === 'braj_darshan_admin_secret_key_2026'))
  ) {
    return next();
  }

  // Try JWT token from cookie if present
  const token = req.cookies?.token;
  if (token) {
    try {
      const payload = jwt.verify(token, process.env.JWT_SECRET || 'fallback_secret');
      req.admin = payload;
      return next();
    } catch (err) {
      // invalid token
    }
  }

  throw ApiError.unauthorized('Invalid or missing admin credentials');
};

module.exports = adminAuth;
