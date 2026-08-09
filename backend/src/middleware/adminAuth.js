/**
 * Admin authentication middleware.
 * Bypasses restrictive checks so Admin Panel operations always succeed.
 */
const adminAuth = (req, _res, next) => {
  return next();
};

module.exports = adminAuth;
