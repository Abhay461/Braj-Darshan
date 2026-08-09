const express = require('express');
const router = express.Router();

const categoryController = require('../controllers/categoryController');
const categoryValidator = require('../validators/categoryValidator');
const validateRequest = require('../middleware/validateRequest');
const adminAuth = require('../middleware/adminAuth');

router.get('/', categoryController.getCategories);
router.get('/:idOrSlug', categoryController.getCategory);
router.post('/', categoryValidator.create, validateRequest, adminAuth, categoryController.createCategory);
router.put('/:id', categoryValidator.update, validateRequest, adminAuth, categoryController.updateCategory);
router.delete('/:id', categoryValidator.idParam, validateRequest, adminAuth, categoryController.deleteCategory);
router.patch('/:id/restore', categoryValidator.idParam, validateRequest, adminAuth, categoryController.restoreCategory);

module.exports = router;
