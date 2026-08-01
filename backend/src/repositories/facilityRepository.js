const Facility = require('../models/Facility');
const ApiFeatures = require('../utils/ApiFeatures');

/**
 * FacilityRepository — Dedicated data-access repository for Facilities.
 */
class FacilityRepository {
  async create(data) {
    return Facility.create(data);
  }

  async findById(id) {
    return Facility.findOne({ _id: id, isDeleted: false }).exec();
  }

  async findBySlug(slug) {
    return Facility.findOne({ slug, isDeleted: false }).exec();
  }

  async findAll(queryString = {}) {
    const baseQuery = Facility.find({ isDeleted: false });
    const features = new ApiFeatures(baseQuery, queryString)
      .filter()
      .search()
      .sort()
      .selectFields()
      .paginate();

    await features.countDocuments();

    const data = await features.query.lean().exec();

    return {
      data,
      meta: features.getPaginationMeta(),
    };
  }

  async updateById(id, updateData) {
    return Facility.findOneAndUpdate({ _id: id, isDeleted: false }, updateData, {
      new: true,
      runValidators: true,
    });
  }

  async softDelete(id) {
    return Facility.findOneAndUpdate(
      { _id: id, isDeleted: false },
      { isDeleted: true, deletedAt: new Date() },
      { new: true }
    );
  }

  async restore(id) {
    return Facility.findOneAndUpdate(
      { _id: id, isDeleted: true },
      { isDeleted: false, deletedAt: null },
      { new: true }
    );
  }

  async hardDelete(id) {
    return Facility.findByIdAndDelete(id);
  }

  async count(conditions = {}) {
    return Facility.countDocuments({ isDeleted: false, ...conditions });
  }
}

module.exports = new FacilityRepository();
