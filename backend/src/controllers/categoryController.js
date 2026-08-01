const asyncHandler = require('../middleware/asyncHandler');
const categoryService = require('../services/categoryService');
const ApiResponse = require('../utils/ApiResponse');

const getCategories = asyncHandler(async (req, res) => {
  const result = await categoryService.getCategories(req.query);
  ApiResponse.ok('Categories retrieved successfully', result.data, result.meta).send(res);
});

const getCategory = asyncHandler(async (req, res) => {
  const category = await categoryService.getCategoryByIdOrSlug(req.params.idOrSlug);
  ApiResponse.ok('Category retrieved successfully', category).send(res);
});

const createCategory = asyncHandler(async (req, res) => {
  const category = await categoryService.createCategory(req.body);
  ApiResponse.created('Category created successfully', category).send(res);
});

const updateCategory = asyncHandler(async (req, res) => {
  const category = await categoryService.updateCategory(req.params.id, req.body);
  ApiResponse.ok('Category updated successfully', category).send(res);
});

const deleteCategory = asyncHandler(async (req, res) => {
  await categoryService.deleteCategory(req.params.id);
  ApiResponse.ok('Category deleted successfully').send(res);
});

const restoreCategory = asyncHandler(async (req, res) => {
  const category = await categoryService.restoreCategory(req.params.id);
  ApiResponse.ok('Category restored successfully', category).send(res);
});

module.exports = {
  getCategories,
  getCategory,
  createCategory,
  updateCategory,
  deleteCategory,
  restoreCategory,
};
