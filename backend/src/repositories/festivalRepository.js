const Festival = require('../models/Festival');
const ApiFeatures = require('../utils/ApiFeatures');

/**
 * FestivalRepository — Dedicated data-access repository for Festivals.
 */
class FestivalRepository {
  async create(data) {
    return Festival.create(data);
  }

  async findById(id) {
    return Festival.findOne({ _id: id, isDeleted: false })
      .populate('templeIds', 'name slug coverImage thumbnailImage')
      .exec();
  }

  async findBySlug(slug) {
    return Festival.findOne({ slug, isDeleted: false })
      .populate('templeIds', 'name slug coverImage thumbnailImage')
      .exec();
  }

  async findAll(queryString = {}) {
    const baseQuery = Festival.find({ isDeleted: false });
    const features = new ApiFeatures(baseQuery, queryString)
      .filter()
      .search()
      .sort()
      .selectFields()
      .paginate();

    await features.countDocuments();

    const data = await features.query
      .populate('templeIds', 'name slug coverImage thumbnailImage')
      .lean()
      .exec();

    return {
      data,
      meta: features.getPaginationMeta(),
    };
  }

  async updateById(id, updateData) {
    return Festival.findOneAndUpdate({ _id: id, isDeleted: false }, updateData, {
      new: true,
      runValidators: true,
    }).populate('templeIds', 'name slug coverImage thumbnailImage');
  }

  async softDelete(id) {
    return Festival.findOneAndUpdate(
      { _id: id, isDeleted: false },
      { isDeleted: true, deletedAt: new Date() },
      { new: true }
    );
  }

  async restore(id) {
    return Festival.findOneAndUpdate(
      { _id: id, isDeleted: true },
      { isDeleted: false, deletedAt: null },
      { new: true }
    );
  }

  async hardDelete(id) {
    return Festival.findByIdAndDelete(id);
  }

  async findByTemple(templeId) {
    return Festival.find({ templeIds: templeId, isDeleted: false, status: 'active' })
      .sort('startDate')
      .lean()
      .exec();
  }

  async findUpcoming(limit = 10) {
    const now = new Date();
    return Festival.find({
      isDeleted: false,
      status: 'active',
      $or: [{ startDate: { $gte: now } }, { startDate: null }],
    })
      .populate('templeIds', 'name slug coverImage thumbnailImage')
      .sort('startDate')
      .limit(limit)
      .lean()
      .exec();
  }

  async count(conditions = {}) {
    return Festival.countDocuments({ isDeleted: false, ...conditions });
  }
}

module.exports = new FestivalRepository();
