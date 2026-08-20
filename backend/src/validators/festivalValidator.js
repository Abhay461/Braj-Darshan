const { body, param } = require('express-validator');

const create = [
  body('name')
    .notEmpty()
    .withMessage('Festival name is required')
    .isString()
    .trim()
    .isLength({ max: 200 }),
  body('description').optional().isString().trim(),
  body('bannerImage').optional().isString().trim(),
  body('startDate').optional().isISO8601().toDate().withMessage('startDate must be a valid ISO 8601 date'),
  body('endDate').optional().isISO8601().toDate().withMessage('endDate must be a valid ISO 8601 date'),
  body('templeIds').optional().isArray(),
  body('templeIds.*').optional().isMongoId().withMessage('Invalid Temple ID in templeIds'),
  body('themeConfig').optional().isObject(),
  body('themeConfig.bannerImage').optional().isString().trim(),
  body('themeConfig.accentColor').optional().matches(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/).withMessage('Invalid hex color format'),
  body('themeConfig.showPetals').optional().isBoolean(),
  body('themeConfig.petalType').optional().isIn(['gulal', 'flower', 'diya', 'none']),
  body('status').optional().isIn(['active', 'inactive']),
];

const update = [
  param('id').isMongoId().withMessage('Invalid Festival ID'),
  body('name').optional().isString().trim().isLength({ max: 200 }),
  body('description').optional().isString().trim(),
  body('bannerImage').optional().isString().trim(),
  body('startDate').optional().isISO8601().toDate(),
  body('endDate').optional().isISO8601().toDate(),
  body('templeIds').optional().isArray(),
  body('templeIds.*').optional().isMongoId(),
  body('themeConfig').optional().isObject(),
  body('themeConfig.bannerImage').optional().isString().trim(),
  body('themeConfig.accentColor').optional().matches(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/).withMessage('Invalid hex color format'),
  body('themeConfig.showPetals').optional().isBoolean(),
  body('themeConfig.petalType').optional().isIn(['gulal', 'flower', 'diya', 'none']),
  body('status').optional().isIn(['active', 'inactive']),
];

const idParam = [param('id').isMongoId().withMessage('Invalid Festival ID')];

module.exports = {
  create,
  update,
  idParam,
};
