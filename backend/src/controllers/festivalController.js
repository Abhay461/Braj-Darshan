const asyncHandler = require('../middleware/asyncHandler');
const festivalService = require('../services/festivalService');
const ApiResponse = require('../utils/ApiResponse');

const getFestivals = asyncHandler(async (req, res) => {
  const result = await festivalService.getFestivals(req.query);
  ApiResponse.ok('Festivals retrieved successfully', result.data, result.meta).send(res);
});

const getFestival = asyncHandler(async (req, res) => {
  const festival = await festivalService.getFestivalByIdOrSlug(req.params.idOrSlug);
  ApiResponse.ok('Festival retrieved successfully', festival).send(res);
});

const createFestival = asyncHandler(async (req, res) => {
  const festival = await festivalService.createFestival(req.body);
  ApiResponse.created('Festival created successfully', festival).send(res);
});

const updateFestival = asyncHandler(async (req, res) => {
  const festival = await festivalService.updateFestival(req.params.id, req.body);
  ApiResponse.ok('Festival updated successfully', festival).send(res);
});

const deleteFestival = asyncHandler(async (req, res) => {
  await festivalService.deleteFestival(req.params.id);
  ApiResponse.ok('Festival deleted successfully').send(res);
});

const restoreFestival = asyncHandler(async (req, res) => {
  const festival = await festivalService.restoreFestival(req.params.id);
  ApiResponse.ok('Festival restored successfully', festival).send(res);
});

const getUpcomingFestivals = asyncHandler(async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const festivals = await festivalService.getUpcomingFestivals(limit);
  ApiResponse.ok('Upcoming festivals retrieved successfully', festivals).send(res);
});

const getFestivalsByTemple = asyncHandler(async (req, res) => {
  const festivals = await festivalService.getFestivalsByTemple(req.params.templeId);
  ApiResponse.ok('Festivals by temple retrieved successfully', festivals).send(res);
});

module.exports = {
  getFestivals,
  getFestival,
  createFestival,
  updateFestival,
  deleteFestival,
  restoreFestival,
  getUpcomingFestivals,
  getFestivalsByTemple,
};
