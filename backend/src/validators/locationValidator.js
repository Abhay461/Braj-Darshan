const { body, param } = require('express-validator');

const create = [
  body('name')
    .notEmpty()
    .withMessage('Location name is required')
    .isString()
    .trim()
    .isLength({ max: 100 })
    .withMessage('Location name cannot exceed 100 characters'),
  body('latitude')
    .notEmpty()
    .withMessage('Latitude is required')
    .isFloat({ min: -90, max: 90 })
    .withMessage('Latitude must be between -90 and 90'),
  body('longitude')
    .notEmpty()
    .withMessage('Longitude is required')
    .isFloat({ min: -180, max: 180 })
    .withMessage('Longitude must be between -180 and 180'),
  body('description').optional().isString().trim(),
  body('coverImage').optional().isString().trim(),
  body('district').optional().isString().trim(),
  body('state').optional().isString().trim(),
  body('country').optional().isString().trim(),
  body('sortOrder').optional().isInt(),
  body('status').optional().isIn(['active', 'inactive']),
];

const update = [
  param('id').isMongoId().withMessage('Invalid Location ID'),
  body('name').optional().isString().trim().isLength({ max: 100 }),
  body('latitude').optional().isFloat({ min: -90, max: 90 }),
  body('longitude').optional().isFloat({ min: -180, max: 180 }),
  body('description').optional().isString().trim(),
  body('coverImage').optional().isString().trim(),
  body('district').optional().isString().trim(),
  body('state').optional().isString().trim(),
  body('country').optional().isString().trim(),
  body('sortOrder').optional().isInt(),
  body('status').optional().isIn(['active', 'inactive']),
];

const idParam = [param('id').isMongoId().withMessage('Invalid Location ID')];

module.exports = {
  create,
  update,
  idParam,
};
