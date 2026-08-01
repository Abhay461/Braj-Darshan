const { body, param } = require('express-validator');

const create = [
  body('name')
    .notEmpty()
    .withMessage('Category name is required')
    .isString()
    .trim()
    .isLength({ max: 100 })
    .withMessage('Category name cannot exceed 100 characters'),
  body('description').optional().isString().trim(),
  body('icon').optional().isString().trim(),
  body('sortOrder').optional().isInt().withMessage('sortOrder must be an integer'),
  body('status').optional().isIn(['active', 'inactive']).withMessage('Status must be active or inactive'),
];

const update = [
  param('id').isMongoId().withMessage('Invalid Category ID'),
  body('name').optional().isString().trim().isLength({ max: 100 }),
  body('description').optional().isString().trim(),
  body('icon').optional().isString().trim(),
  body('sortOrder').optional().isInt(),
  body('status').optional().isIn(['active', 'inactive']),
];

const idParam = [param('id').isMongoId().withMessage('Invalid Category ID')];

module.exports = {
  create,
  update,
  idParam,
};
