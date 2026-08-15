const templeRepository = require('../repositories/templeRepository');
const ApiError = require('../utils/ApiError');

const https = require('https');
const http = require('http');

function extractCoordsFromUrl(url) {
  if (!url || typeof url !== 'string') return null;
  const atMatch = url.match(/@(-?\d+\.\d+),(-?\d+\.\d+)/);
  if (atMatch) return { latitude: parseFloat(atMatch[1]), longitude: parseFloat(atMatch[2]) };

  const paramMatch = url.match(/(?:query|q|ll|destination)=(-?\d+\.\d+),(-?\d+\.\d+)/);
  if (paramMatch) return { latitude: parseFloat(paramMatch[1]), longitude: parseFloat(paramMatch[2]) };

  const dirMatch = url.match(/\/(-?\d{1,2}\.\d+),(-?\d{1,3}\.\d+)/);
  if (dirMatch) return { latitude: parseFloat(dirMatch[1]), longitude: parseFloat(dirMatch[2]) };

  const pairMatch = url.match(/(-?\d{1,2}\.\d{3,}),\s*(-?\d{1,3}\.\d{3,})/);
  if (pairMatch) return { latitude: parseFloat(pairMatch[1]), longitude: parseFloat(pairMatch[2]) };

  return null;
}

async function resolveShortUrl(url, maxRedirects = 5) {
  if (!url || maxRedirects <= 0) return null;
  return new Promise((resolve) => {
    try {
      const u = new URL(url);
      const client = url.startsWith('https') ? https : http;
      const options = {
        hostname: u.hostname,
        path: u.pathname + u.search,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
          'Accept-Encoding': 'identity',
        },
      };
      const req = client.get(options, (res) => {
        if (res.headers.location) {
          const coords = extractCoordsFromUrl(res.headers.location);
          if (coords) return resolve(coords);
          const nextUrl = res.headers.location.startsWith('http') ? res.headers.location : `${u.protocol}//${u.hostname}${res.headers.location}`;
          return resolve(resolveShortUrl(nextUrl, maxRedirects - 1));
        }

        let body = '';
        res.on('data', (chunk) => { body += chunk; });
        res.on('end', () => {
          const coords = extractCoordsFromUrl(body);
          resolve(coords);
        });
      });
      req.on('error', () => resolve(null));
      req.setTimeout(5000, () => {
        req.destroy();
        resolve(null);
      });
    } catch (e) {
      resolve(null);
    }
  });
}

async function getCoordsFromUrl(url) {
  if (!url || typeof url !== 'string') return null;
  const direct = extractCoordsFromUrl(url);
  if (direct) return direct;
  if (url.includes('goo.gl') || url.includes('maps.google') || url.includes('google.com/maps')) {
    return await resolveShortUrl(url);
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
