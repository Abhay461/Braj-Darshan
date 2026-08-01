const asyncHandler = require('../middleware/asyncHandler');
const locationService = require('../services/locationService');
const ApiResponse = require('../utils/ApiResponse');

const getLocations = asyncHandler(async (req, res) => {
  const result = await locationService.getLocations(req.query);
  ApiResponse.ok('Locations retrieved successfully', result.data, result.meta).send(res);
});

const getLocation = asyncHandler(async (req, res) => {
  const location = await locationService.getLocationByIdOrSlug(req.params.idOrSlug);
  ApiResponse.ok('Location retrieved successfully', location).send(res);
});

const createLocation = asyncHandler(async (req, res) => {
  const location = await locationService.createLocation(req.body);
  ApiResponse.created('Location created successfully', location).send(res);
});

const updateLocation = asyncHandler(async (req, res) => {
  const location = await locationService.updateLocation(req.params.id, req.body);
  ApiResponse.ok('Location updated successfully', location).send(res);
});

const deleteLocation = asyncHandler(async (req, res) => {
  await locationService.deleteLocation(req.params.id);
  ApiResponse.ok('Location deleted successfully').send(res);
});

const restoreLocation = asyncHandler(async (req, res) => {
  const location = await locationService.restoreLocation(req.params.id);
  ApiResponse.ok('Location restored successfully', location).send(res);
});

module.exports = {
  getLocations,
  getLocation,
  createLocation,
  updateLocation,
  deleteLocation,
  restoreLocation,
};
