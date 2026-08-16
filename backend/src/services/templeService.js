const templeRepository = require('../repositories/templeRepository');
const ApiError = require('../utils/ApiError');


// Import robust coordinate extraction from utilRoutes (7 regex patterns + validation)
const { extractLatLngFromText, resolveRedirectsAndExtract } = require('./coordinateUtils');

async function getCoordsFromUrl(url) {
  if (!url || typeof url !== 'string') return null;
  const direct = extractLatLngFromText(url);
  if (direct) return direct;
  if (url.includes('goo.gl') || url.includes('maps.app.goo.gl') || url.includes('maps.google') || url.includes('google.com/maps')) {
    return await resolveRedirectsAndExtract(url.trim());
  }
  return null;
}

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
    if (data.directionsUrl) {
      const extracted = await getCoordsFromUrl(data.directionsUrl);
      if (extracted) {
        if (!data.latitude || data.latitude === 27.5830) data.latitude = extracted.latitude;
        if (!data.longitude || data.longitude === 77.7000) data.longitude = extracted.longitude;
      }
    }
    const temple = await templeRepository.create(data);
    return templeRepository.findById(temple._id);
  }

  /**
   * Update temple by ID.
   */
  async updateTemple(id, data) {
    if (data.directionsUrl) {
      const extracted = await getCoordsFromUrl(data.directionsUrl);
      if (extracted) {
        data.latitude = extracted.latitude;
        data.longitude = extracted.longitude;
      }
    }
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
