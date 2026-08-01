const asyncHandler = require('../middleware/asyncHandler');
const templeService = require('../services/templeService');
const ApiResponse = require('../utils/ApiResponse');

/**
 * @desc    Get all temples with pagination, filtering, sorting, search
 * @route   GET /api/v1/temples
 * @access  Public
 */
const getTemples = asyncHandler(async (req, res) => {
  const result = await templeService.getTemples(req.query);
  ApiResponse.ok('Temples retrieved successfully', result.data, result.meta).send(res);
});

/**
 * @desc    Get single temple by ID or slug
 * @route   GET /api/v1/temples/:idOrSlug
 * @access  Public
 */
const getTemple = asyncHandler(async (req, res) => {
  const temple = await templeService.getTempleByIdOrSlug(req.params.idOrSlug);
  ApiResponse.ok('Temple retrieved successfully', temple).send(res);
});

/**
 * @desc    Create a new temple
 * @route   POST /api/v1/temples
 * @access  Public / Admin
 */
const createTemple = asyncHandler(async (req, res) => {
  const temple = await templeService.createTemple(req.body);
  ApiResponse.created('Temple created successfully', temple).send(res);
});

/**
 * @desc    Update temple
 * @route   PUT /api/v1/temples/:id
 * @access  Public / Admin
 */
const updateTemple = asyncHandler(async (req, res) => {
  const temple = await templeService.updateTemple(req.params.id, req.body);
  ApiResponse.ok('Temple updated successfully', temple).send(res);
});

/**
 * @desc    Soft delete temple
 * @route   DELETE /api/v1/temples/:id
 * @access  Public / Admin
 */
const deleteTemple = asyncHandler(async (req, res) => {
  await templeService.deleteTemple(req.params.id);
  ApiResponse.ok('Temple deleted successfully').send(res);
});

/**
 * @desc    Restore soft-deleted temple
 * @route   PATCH /api/v1/temples/:id/restore
 * @access  Public / Admin
 */
const restoreTemple = asyncHandler(async (req, res) => {
  const temple = await templeService.restoreTemple(req.params.id);
  ApiResponse.ok('Temple restored successfully', temple).send(res);
});

/**
 * @desc    Get featured temples
 * @route   GET /api/v1/temples/featured
 * @access  Public
 */
const getFeaturedTemples = asyncHandler(async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const temples = await templeService.getFeaturedTemples(limit);
  ApiResponse.ok('Featured temples retrieved successfully', temples).send(res);
});

/**
 * @desc    Get popular temples
 * @route   GET /api/v1/temples/popular
 * @access  Public
 */
const getPopularTemples = asyncHandler(async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const temples = await templeService.getPopularTemples(limit);
  ApiResponse.ok('Popular temples retrieved successfully', temples).send(res);
});

/**
 * @desc    Get recently added temples
 * @route   GET /api/v1/temples/recent
 * @access  Public
 */
const getRecentTemples = asyncHandler(async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const temples = await templeService.getRecentTemples(limit);
  ApiResponse.ok('Recent temples retrieved successfully', temples).send(res);
});

/**
 * @desc    Get nearby temples
 * @route   GET /api/v1/temples/nearby
 * @access  Public
 */
const getNearbyTemples = asyncHandler(async (req, res) => {
  const { lat, lng, radius, excludeId, limit } = req.query;

  if (!lat || !lng) {
    return ApiResponse.ok('Latitude and longitude are required', []).send(res);
  }

  const temples = await templeService.getNearbyTemples(
    parseFloat(lat),
    parseFloat(lng),
    parseFloat(radius) || 0.05,
    excludeId || null,
    parseInt(limit, 10) || 10
  );
  ApiResponse.ok('Nearby temples retrieved successfully', temples).send(res);
});

/**
 * @desc    Get temples by category
 * @route   GET /api/v1/temples/category/:categoryId
 * @access  Public
 */
const getTemplesByCategory = asyncHandler(async (req, res) => {
  const result = await templeService.getTemplesByCategory(req.params.categoryId, req.query);
  ApiResponse.ok('Temples by category retrieved successfully', result.data, result.meta).send(res);
});

/**
 * @desc    Get temples by location
 * @route   GET /api/v1/temples/location/:locationId
 * @access  Public
 */
const getTemplesByLocation = asyncHandler(async (req, res) => {
  const result = await templeService.getTemplesByLocation(req.params.locationId, req.query);
  ApiResponse.ok('Temples by location retrieved successfully', result.data, result.meta).send(res);
});

module.exports = {
  getTemples,
  getTemple,
  createTemple,
  updateTemple,
  deleteTemple,
  restoreTemple,
  getFeaturedTemples,
  getPopularTemples,
  getRecentTemples,
  getNearbyTemples,
  getTemplesByCategory,
  getTemplesByLocation,
};
