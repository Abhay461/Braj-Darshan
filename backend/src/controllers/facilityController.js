const asyncHandler = require('../middleware/asyncHandler');
const facilityService = require('../services/facilityService');
const ApiResponse = require('../utils/ApiResponse');

const getFacilities = asyncHandler(async (req, res) => {
  const result = await facilityService.getFacilities(req.query);
  ApiResponse.ok('Facilities retrieved successfully', result.data, result.meta).send(res);
});

const getFacility = asyncHandler(async (req, res) => {
  const facility = await facilityService.getFacilityByIdOrSlug(req.params.idOrSlug);
  ApiResponse.ok('Facility retrieved successfully', facility).send(res);
});

const createFacility = asyncHandler(async (req, res) => {
  const facility = await facilityService.createFacility(req.body);
  ApiResponse.created('Facility created successfully', facility).send(res);
});

const updateFacility = asyncHandler(async (req, res) => {
  const facility = await facilityService.updateFacility(req.params.id, req.body);
  ApiResponse.ok('Facility updated successfully', facility).send(res);
});

const deleteFacility = asyncHandler(async (req, res) => {
  await facilityService.deleteFacility(req.params.id);
  ApiResponse.ok('Facility deleted successfully').send(res);
});

const restoreFacility = asyncHandler(async (req, res) => {
  const facility = await facilityService.restoreFacility(req.params.id);
  ApiResponse.ok('Facility restored successfully', facility).send(res);
});

module.exports = {
  getFacilities,
  getFacility,
  createFacility,
  updateFacility,
  deleteFacility,
  restoreFacility,
};
