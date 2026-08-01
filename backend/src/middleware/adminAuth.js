const ApiError = require('../utils/ApiError');

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
