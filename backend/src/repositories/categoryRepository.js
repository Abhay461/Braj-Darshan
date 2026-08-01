const Category = require('../models/Category');
const ApiFeatures = require('../utils/ApiFeatures');

/**
 * CategoryRepository — Dedicated data-access repository for Categories.
 */
class CategoryRepository {
  async create(data) {
    return Category.create(data);
  }

  async findById(id) {
    return Category.findOne({ _id: id, isDeleted: false }).populate('templeCount').exec();
  }

  async findBySlug(slug) {
    return Category.findOne({ slug, isDeleted: false }).populate('templeCount').exec();
  }

  async findAll(queryString = {}) {
    const baseQuery = Category.find({ isDeleted: false });
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
    return Category.findOneAndUpdate({ _id: id, isDeleted: false }, updateData, {
      new: true,
      runValidators: true,
    });
  }

  async softDelete(id) {
    return Category.findOneAndUpdate(
      { _id: id, isDeleted: false },
      { isDeleted: true, deletedAt: new Date() },
      { new: true }
    );
  }

  async restore(id) {
    return Category.findOneAndUpdate(
      { _id: id, isDeleted: true },
      { isDeleted: false, deletedAt: null },
      { new: true }
    );
  }

  async hardDelete(id) {
    return Category.findByIdAndDelete(id);
  }

  async count(conditions = {}) {
    return Category.countDocuments({ isDeleted: false, ...conditions });
  }
}

module.exports = new CategoryRepository();
