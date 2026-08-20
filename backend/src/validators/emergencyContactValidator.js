const { body, param, query } = require('express-validator');

const create = [
  body('name')
    .notEmpty()
    .withMessage('Name is required')
    .isString()
    .trim()
    .isLength({ max: 100 })
    .withMessage('Name cannot exceed 100 characters'),
  body('category')
    .notEmpty()
    .withMessage('Category is required')
    .isIn(['police', 'medical', 'fire', 'helpline', 'hospital', 'ambulance', 'tourist_police', 'other'])
    .withMessage('Invalid category'),
  body('phone')
    .notEmpty()
    .withMessage('Phone number is required')
    .matches(/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/)
    .withMessage('Invalid phone number format'),
  body('description').optional().isString().trim(),
  body('location.lat').optional().isFloat({ min: -90, max: 90 }).withMessage('Invalid latitude'),
  body('location.lng').optional().isFloat({ min: -180, max: 180 }).withMessage('Invalid longitude'),
  body('location.address').optional().isString().trim(),
  body('location.name').optional().isString().trim(),
  body('isActive').optional().isBoolean(),
  body('sortOrder').optional().isInt({ min: 0 }).withMessage('Sort order must be a positive integer'),
  body('area').optional().isString().trim(),
  body('isVerified').optional().isBoolean(),
];

const update = [
  param('id').isMongoId().withMessage('Invalid Emergency Contact ID'),
  body('name').optional().isString().trim().isLength({ max: 100 }),
  body('category')
    .optional()
    .isIn(['police', 'medical', 'fire', 'helpline', 'hospital', 'ambulance', 'tourist_police', 'other'])
    .withMessage('Invalid category'),
  body('phone').optional().matches(/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/).withMessage('Invalid phone number format'),
  body('description').optional().isString().trim(),
  body('location.lat').optional().isFloat({ min: -90, max: 90 }),
  body('location.lng').optional().isFloat({ min: -180, max: 180 }),
  body('location.address').optional().isString().trim(),
  body('location.name').optional().isString().trim(),
  body('isActive').optional().isBoolean(),
  body('sortOrder').optional().isInt({ min: 0 }),
  body('area').optional().isString().trim(),
  body('isVerified').optional().isBoolean(),
];

const idParam = [param('id').isMongoId().withMessage('Invalid Emergency Contact ID')];

const listQuery = [
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('category').optional().isIn(['police', 'medical', 'fire', 'helpline', 'hospital', 'ambulance', 'tourist_police', 'other']),
  query('area').optional().isString().trim(),
  query('isActive').optional().isBoolean(),
  query('sort').optional().isString(),
];

module.exports = {
  create,
  update,
  idParam,
  listQuery,
};