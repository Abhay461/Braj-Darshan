const ApiError = require('../utils/ApiError');
const jwt = require('jsonwebtoken');
const cookieParser = require('cookie-parser'); // Ensure cookie parsing middleware is used in app

/**
 * Admin authentication middleware.
 * Supports JWT verification from HttpOnly Secure cookie (preferred) and falls back to static API key for backward compatibility.
 */
module.exports = (req, _res, next) => {
  // Try JWT from cookie
  const token = req.cookies?.token;
  if (token) {
    try {
      const payload = jwt.verify(token, process.env.JWT_SECRET);
      // Optionally attach admin info to request
      req.admin = payload;
      return next();
    } catch (err) {
      // Invalid token – fall back to API key
    }
  }

  // Fallback to static API key (should not be used by frontend)
  const apiKey = req.headers['x-admin-api-key'];
  if (apiKey && apiKey === process.env.ADMIN_API_KEY) {
    return next();
  }

  // No valid credentials
  throw ApiError.unauthorized('Invalid or missing admin credentials');
};

/**
 * Simple API key guard for admin write operations.
 * Checks the x-admin-api-key header against the ADMIN_API_KEY env variable.
 *
 * No JWT, no user accounts, no sessions — just a static key for admin panel calls.
 */
const adminAuth = (req, _res, next) => {
  const apiKey = req.headers['x-admin-api-key'];

  if (!apiKey || apiKey !== process.env.ADMIN_API_KEY) {
    throw ApiError.unauthorized('Invalid or missing admin API key');
  }

  next();
};

module.exports = adminAuth;
