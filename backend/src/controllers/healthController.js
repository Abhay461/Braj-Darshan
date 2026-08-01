const mongoose = require('mongoose');
const asyncHandler = require('../middleware/asyncHandler');
const ApiResponse = require('../utils/ApiResponse');

/**
 * @desc    Health check endpoint
 * @route   GET /api/v1/health
 * @access  Public
 */
const getHealth = asyncHandler(async (req, res) => {
  const dbState = mongoose.connection.readyState;
  const dbStatusMap = {
    0: 'disconnected',
    1: 'connected',
    2: 'connecting',
    3: 'disconnecting',
  };

  const isCloudinaryConfigured = !!(
    process.env.CLOUDINARY_CLOUD_NAME &&
    process.env.CLOUDINARY_API_KEY &&
    process.env.CLOUDINARY_API_SECRET
  );

  const healthData = {
    status: 'ok',
    database: dbStatusMap[dbState] || 'unknown',
    cloudinary: isCloudinaryConfigured ? 'configured' : 'unconfigured',
    version: '1.0.0',
    uptime: Math.floor(process.uptime()),
    timestamp: new Date().toISOString(),
  };

  ApiResponse.ok('Health status retrieved successfully', healthData).send(res);
});

module.exports = {
  getHealth,
};
