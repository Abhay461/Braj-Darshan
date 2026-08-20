const asyncHandler = require('../middleware/asyncHandler');
const mapSettingsService = require('../services/mapSettingsService');
const ApiResponse = require('../utils/ApiResponse');

/**
 * @desc    Get global map settings
 * @route   GET /api/v1/map-settings
 * @access  Public
 */
const getMapSettings = asyncHandler(async (req, res) => {
  const settings = await mapSettingsService.getSettings();
  ApiResponse.ok('Map settings retrieved successfully', settings).send(res);
});

/**
 * @desc    Update global map settings
 * @route   PUT /api/v1/map-settings
 * @access  Admin
 */
const updateMapSettings = asyncHandler(async (req, res) => {
  const settings = await mapSettingsService.updateSettings(req.body, req.adminId);
  ApiResponse.ok('Map settings updated successfully', settings).send(res);
});

/**
 * @desc    Reset global map settings to defaults
 * @route   POST /api/v1/map-settings/reset
 * @access  Admin
 */
const resetMapSettings = asyncHandler(async (req, res) => {
  const settings = await mapSettingsService.resetToDefaults(req.adminId);
  ApiResponse.ok('Map settings reset to defaults successfully', settings).send(res);
});

module.exports = {
  getMapSettings,
  updateMapSettings,
  resetMapSettings,
};
