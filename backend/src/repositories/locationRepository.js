const Location = require('../models/Location');
const ApiFeatures = require('../utils/ApiFeatures');

/**
 * LocationRepository — Dedicated data-access repository for Locations.
 */
class LocationRepository {
  async create(data) {
    return Location.create(data);
  }

  async findById(id) {
    return Location.findOne({ _id: id, isDeleted: false }).populate('templeCount').exec();
  }

  async findBySlug(slug) {
    return Location.findOne({ slug, isDeleted: false }).populate('templeCount').exec();
  }

  async findAll(queryString = {}) {
    const baseQuery = Location.find({ isDeleted: false });
    const features = new ApiFeatures(baseQuery, queryString)
      .filter()
      .search()
      .sort()
      .selectFields()
      .paginate();

    await features.countDocuments();

    const data = await features.query.populate('templeCount').lean({ virtuals: true }).exec();

    return {
      data,
      meta: features.getPaginationMeta(),
    };
  }

  async updateById(id, updateData) {
    return Location.findOneAndUpdate({ _id: id, isDeleted: false }, updateData, {
      new: true,
      runValidators: true,
    });
  }

  async softDelete(id) {
    return Location.findOneAndUpdate(
      { _id: id, isDeleted: false },
      { isDeleted: true, deletedAt: new Date() },
      { new: true }
    );
  }

  async restore(id) {
    return Location.findOneAndUpdate(
      { _id: id, isDeleted: true },
      { isDeleted: false, deletedAt: null },
      { new: true }
    );
  }

  async hardDelete(id) {
    return Location.findByIdAndDelete(id);
  }

  async count(conditions = {}) {
    return Location.countDocuments({ isDeleted: false, ...conditions });
  }
}

module.exports = new LocationRepository();
