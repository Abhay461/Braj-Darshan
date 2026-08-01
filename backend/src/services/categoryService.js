const categoryRepository = require('../repositories/categoryRepository');
const ApiError = require('../utils/ApiError');

class CategoryService {
  async getCategories(queryString) {
    return categoryRepository.findAll(queryString);
  }

  async getCategoryByIdOrSlug(idOrSlug) {
    let category;
    if (/^[0-9a-fA-F]{24}$/.test(idOrSlug)) {
      category = await categoryRepository.findById(idOrSlug);
    } else {
      category = await categoryRepository.findBySlug(idOrSlug);
    }

    if (!category) {
      throw ApiError.notFound('Category not found');
    }

    return category;
  }

  async createCategory(data) {
    return categoryRepository.create(data);
  }

  async updateCategory(id, data) {
    const updated = await categoryRepository.updateById(id, data);
    if (!updated) throw ApiError.notFound('Category not found');
    return updated;
  }

  async deleteCategory(id) {
    const deleted = await categoryRepository.softDelete(id);
    if (!deleted) throw ApiError.notFound('Category not found');
    return deleted;
  }

  async restoreCategory(id) {
    const restored = await categoryRepository.restore(id);
    if (!restored) throw ApiError.notFound('Category not found or not deleted');
    return restored;
  }
}

module.exports = new CategoryService();
