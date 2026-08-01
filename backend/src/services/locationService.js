const locationRepository = require('../repositories/locationRepository');
const ApiError = require('../utils/ApiError');

class LocationService {
  async getLocations(queryString) {
    return locationRepository.findAll(queryString);
  }

  async getLocationByIdOrSlug(idOrSlug) {
    let location;
    if (/^[0-9a-fA-F]{24}$/.test(idOrSlug)) {
      location = await locationRepository.findById(idOrSlug);
    } else {
      location = await locationRepository.findBySlug(idOrSlug);
    }

    if (!location) {
      throw ApiError.notFound('Location not found');
    }

    return location;
  }

  async createLocation(data) {
    return locationRepository.create(data);
  }

  async updateLocation(id, data) {
    const updated = await locationRepository.updateById(id, data);
    if (!updated) throw ApiError.notFound('Location not found');
    return updated;
  }

  async deleteLocation(id) {
    const deleted = await locationRepository.softDelete(id);
    if (!deleted) throw ApiError.notFound('Location not found');
    return deleted;
  }

  async restoreLocation(id) {
    const restored = await locationRepository.restore(id);
    if (!restored) throw ApiError.notFound('Location not found or not deleted');
    return restored;
  }
}

module.exports = new LocationService();
