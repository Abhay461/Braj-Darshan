const rateLimit = require('express-rate-limit');

/**
 * General API rate limiter.
 * Default: 200 requests per 15-minute window per IP.
 */
const apiLimiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) || 15 * 60 * 1000,
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS, 10) || 200,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Too many requests from this IP, please try again after 15 minutes',
  },
  skip: (req) => {
    // Skip rate limiting for admin operations with valid API key
    return req.headers['x-admin-api-key'] === process.env.ADMIN_API_KEY;
  },
});

/**
 * Stricter rate limiter for upload endpoints.
 * 30 uploads per 15-minute window.
 */
const uploadLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 30,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    message: 'Upload limit exceeded, please try again later',
  },
});

module.exports = { apiLimiter, uploadLimiter };
