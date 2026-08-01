const templeRepository = require('../repositories/templeRepository');
const ApiError = require('../utils/ApiError');

/**
 * Temple Service — pure business logic layer.
 * Manages temple discovery, search, filtering, soft-delete, and restoration.
 */
class TempleService {
  /**
   * Get paginated, filtered, sorted list of temples.
   */
  async getTemples(queryString) {
    return templeRepository.findAll(queryString);
  }

  /**
   * Get a single temple by ID or slug.
   */
  async getTempleByIdOrSlug(idOrSlug) {
    let temple;

    if (/^[0-9a-fA-F]{24}$/.test(idOrSlug)) {
      temple = await templeRepository.findById(idOrSlug);
    } else {
      temple = await templeRepository.findBySlug(idOrSlug);
    }

    if (!temple) {
      throw ApiError.notFound('Temple not found');
    }

    return temple;
  }

  /**
   * Create a new temple.
   */
  async createTemple(data) {
    const temple = await templeRepository.create(data);
    return templeRepository.findById(temple._id);
  }

  /**
   * Update temple by ID.
   */
  async updateTemple(id, data) {
    const updated = await templeRepository.updateById(id, data);
    if (!updated) {
      throw ApiError.notFound('Temple not found');
    }
    return updated;
  }

  /**
   * Soft delete temple by ID.
   */
  async deleteTemple(id) {
    const deleted = await templeRepository.softDelete(id);
    if (!deleted) {
      throw ApiError.notFound('Temple not found');
    }
    return deleted;
  }

  /**
   * Restore soft-deleted temple by ID.
   */
  async restoreTemple(id) {
    const restored = await templeRepository.restore(id);
    if (!restored) {
      throw ApiError.notFound('Temple not found or not deleted');
    }
    return restored;
  }

  /**
   * Get featured temples.
   */
  async getFeaturedTemples(limit) {
    return templeRepository.findFeatured(limit);
  }

  /**
   * Get popular temples.
   */
  async getPopularTemples(limit) {
    return templeRepository.findPopular(limit);
  }

  /**
   * Get recently added temples.
   */
  async getRecentTemples(limit) {
    return templeRepository.findRecent(limit);
  }

  /**
   * Get nearby temples by latitude/longitude.
   */
  async getNearbyTemples(lat, lng, radius, excludeId, limit) {
    return templeRepository.findNearby(lat, lng, radius, excludeId, limit);
  }

  /**
   * Get temples by category ID.
   */
  async getTemplesByCategory(categoryId, queryString) {
    return templeRepository.findByCategory(categoryId, queryString);
  }

  /**
   * Get temples by location ID.
   */
  async getTemplesByLocation(locationId, queryString) {
    return templeRepository.findByLocation(locationId, queryString);
  }

  /**
   * Search temples using MongoDB Text Search or Atlas Search.
   */
  async searchTemples(query, queryString) {
    return templeRepository.findAll({ ...queryString, search: query });
  }
}

module.exports = new TempleService();
