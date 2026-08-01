const festivalRepository = require('../repositories/festivalRepository');
const ApiError = require('../utils/ApiError');

class FestivalService {
  async getFestivals(queryString) {
    return festivalRepository.findAll(queryString);
  }

  async getFestivalByIdOrSlug(idOrSlug) {
    let festival;
    if (/^[0-9a-fA-F]{24}$/.test(idOrSlug)) {
      festival = await festivalRepository.findById(idOrSlug);
    } else {
      festival = await festivalRepository.findBySlug(idOrSlug);
    }

    if (!festival) {
      throw ApiError.notFound('Festival not found');
    }

    return festival;
  }

  async createFestival(data) {
    return festivalRepository.create(data);
  }

  async updateFestival(id, data) {
    const updated = await festivalRepository.updateById(id, data);
    if (!updated) throw ApiError.notFound('Festival not found');
    return updated;
  }

  async deleteFestival(id) {
    const deleted = await festivalRepository.softDelete(id);
    if (!deleted) throw ApiError.notFound('Festival not found');
    return deleted;
  }

  async restoreFestival(id) {
    const restored = await festivalRepository.restore(id);
    if (!restored) throw ApiError.notFound('Festival not found or not deleted');
    return restored;
  }

  async getFestivalsByTemple(templeId) {
    return festivalRepository.findByTemple(templeId);
  }

  async getUpcomingFestivals(limit) {
    return festivalRepository.findUpcoming(limit);
  }
}

module.exports = new FestivalService();
