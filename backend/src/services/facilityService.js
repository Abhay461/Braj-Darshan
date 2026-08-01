const facilityRepository = require('../repositories/facilityRepository');
const ApiError = require('../utils/ApiError');

class FacilityService {
  async getFacilities(queryString) {
    return facilityRepository.findAll(queryString);
  }

  async getFacilityByIdOrSlug(idOrSlug) {
    let facility;
    if (/^[0-9a-fA-F]{24}$/.test(idOrSlug)) {
      facility = await facilityRepository.findById(idOrSlug);
    } else {
      facility = await facilityRepository.findBySlug(idOrSlug);
    }

    if (!facility) {
      throw ApiError.notFound('Facility not found');
    }

    return facility;
  }

  async createFacility(data) {
    return facilityRepository.create(data);
  }

  async updateFacility(id, data) {
    const updated = await facilityRepository.updateById(id, data);
    if (!updated) throw ApiError.notFound('Facility not found');
    return updated;
  }

  async deleteFacility(id) {
    const deleted = await facilityRepository.softDelete(id);
    if (!deleted) throw ApiError.notFound('Facility not found');
    return deleted;
  }

  async restoreFacility(id) {
    const restored = await facilityRepository.restore(id);
    if (!restored) throw ApiError.notFound('Facility not found or not deleted');
    return restored;
  }
}

module.exports = new FacilityService();
