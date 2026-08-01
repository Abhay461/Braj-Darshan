const express = require('express');
const router = express.Router();

const categoryController = require('../controllers/categoryController');
const categoryValidator = require('../validators/categoryValidator');
const validateRequest = require('../middleware/validateRequest');

router.get('/', categoryController.getCategories);
router.get('/:idOrSlug', categoryController.getCategory);
router.post('/', categoryValidator.create, validateRequest, categoryController.createCategory);
router.put('/:id', categoryValidator.update, validateRequest, categoryController.updateCategory);
router.delete('/:id', categoryValidator.idParam, validateRequest, categoryController.deleteCategory);
router.patch('/:id/restore', categoryValidator.idParam, validateRequest, categoryController.restoreCategory);

module.exports = router;
