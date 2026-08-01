const Temple = require('../models/Temple');
const ApiFeatures = require('../utils/ApiFeatures');

/**
 * TempleRepository — Dedicated data-access repository for Temples.
 * Encapsulates all database operations, indexing, soft deletion, and search queries.
 */
class TempleRepository {
  /**
   * Create a new temple document
   */
  async create(data) {
    return Temple.create(data);
  }

  /**
   * Find temple by ID (excluding soft-deleted)
   */
  async findById(id) {
    return Temple.findOne({ _id: id, isDeleted: false })
      .populate('categoryId locationId facilities')
      .exec();
  }

  /**
   * Find temple by slug (excluding soft-deleted)
   */
  async findBySlug(slug) {
    return Temple.findOne({ slug, isDeleted: false })
      .populate('categoryId locationId facilities')
      .exec();
  }

  /**
   * Find all temples with pagination, filtering, sorting, and search (excluding soft-deleted)
   */
  async findAll(queryString = {}) {
    const baseQuery = Temple.find({ isDeleted: false });

    // Handle Atlas Search vs MongoDB Text Search
    if (queryString.search && process.env.ENABLE_ATLAS_SEARCH === 'true') {
      const searchStage = {
        $search: {
          index: 'temple_atlas_search',
          text: {
            query: queryString.search,
            path: ['name', 'shortDescription', 'history', 'importance', 'tags', 'keywords'],
            fuzzy: { maxEdits: 1 },
          },
        },
      };
      // For Atlas Search pipeline integration fallback:
    }

    const features = new ApiFeatures(baseQuery, queryString)
      .filter()
      .search()
      .sort()
      .selectFields()
      .paginate();

    await features.countDocuments();

    const data = await features.query
      .populate('categoryId locationId facilities')
      .lean()
      .exec();

    return {
      data,
      meta: features.getPaginationMeta(),
    };
  }

  /**
   * Update temple by ID
   */
  async updateById(id, updateData) {
    return Temple.findOneAndUpdate({ _id: id, isDeleted: false }, updateData, {
      new: true,
      runValidators: true,
    }).populate('categoryId locationId facilities');
  }

  /**
   * Soft delete temple by ID
   */
  async softDelete(id) {
    return Temple.findOneAndUpdate(
      { _id: id, isDeleted: false },
      { isDeleted: true, deletedAt: new Date() },
      { new: true }
    );
  }

  /**
   * Restore soft-deleted temple by ID
   */
  async restore(id) {
    return Temple.findOneAndUpdate(
      { _id: id, isDeleted: true },
      { isDeleted: false, deletedAt: null },
      { new: true }
    );
  }

  /**
   * Hard delete temple by ID
   */
  async hardDelete(id) {
    return Temple.findByIdAndDelete(id);
  }

  /**
   * Find featured temples
   */
  async findFeatured(limit = 10) {
    return Temple.find({ isDeleted: false, status: 'active', isFeatured: true })
      .populate('categoryId locationId facilities')
      .sort('-createdAt')
      .limit(limit)
      .lean()
      .exec();
  }

  /**
   * Find popular temples
   */
  async findPopular(limit = 10) {
    return Temple.find({ isDeleted: false, status: 'active', isPopular: true })
      .populate('categoryId locationId facilities')
      .sort('-createdAt')
      .limit(limit)
      .lean()
      .exec();
  }

  /**
   * Find recent temples
   */
  async findRecent(limit = 10) {
    return Temple.find({ isDeleted: false, status: 'active' })
      .populate('categoryId locationId facilities')
      .sort('-createdAt')
      .limit(limit)
      .lean()
      .exec();
  }

  /**
   * Find nearby temples based on lat/lng within a radius (approx degrees)
   */
  async findNearby(lat, lng, radiusDeg = 0.05, excludeId = null, limit = 10) {
    const conditions = {
      isDeleted: false,
      status: 'active',
      latitude: { $gte: lat - radiusDeg, $lte: lat + radiusDeg },
      longitude: { $gte: lng - radiusDeg, $lte: lng + radiusDeg },
    };
    if (excludeId) {
      conditions._id = { $ne: excludeId };
    }

    return Temple.find(conditions)
      .populate('categoryId locationId facilities')
      .limit(limit)
      .lean()
      .exec();
  }

  /**
   * Find temples by category ID
   */
  async findByCategory(categoryId, queryString = {}) {
    return this.findAll({ ...queryString, categoryId, status: 'active' });
  }

  /**
   * Find temples by location ID
   */
  async findByLocation(locationId, queryString = {}) {
    return this.findAll({ ...queryString, locationId, status: 'active' });
  }

  /**
   * Count temples by condition
   */
  async count(conditions = {}) {
    return Temple.countDocuments({ isDeleted: false, ...conditions });
  }
}

module.exports = new TempleRepository();
