const { body, param, query } = require('express-validator');

const create = [
  body('name')
    .notEmpty()
    .withMessage('Temple name is required')
    .isString()
    .trim()
    .isLength({ max: 200 })
    .withMessage('Name cannot exceed 200 characters'),
  body('shortDescription')
    .notEmpty()
    .withMessage('Short description is required')
    .isString()
    .trim()
    .isLength({ max: 500 })
    .withMessage('Short description cannot exceed 500 characters'),
  body('categoryId')
    .notEmpty()
    .withMessage('Category ID is required')
    .isMongoId()
    .withMessage('Invalid Category ID'),
  body('locationId')
    .notEmpty()
    .withMessage('Location ID is required')
    .isMongoId()
    .withMessage('Invalid Location ID'),
  body('coverImage')
    .notEmpty()
    .withMessage('Cover image URL is required')
    .isString(),
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
  body('history').optional().isString().trim(),
  body('importance').optional().isString().trim(),
  body('darshanTiming').optional().isString().trim(),
  body('phone').optional().isString().trim(),
  body('website').optional().isString().trim(),
  body('donationUrl').optional().isString().trim(),
  body('guestHouseBookingUrl').optional().isString().trim(),
  body('liveDarshanUrl').optional().isString().trim(),
  body('visitDuration').optional().isString().trim(),
  body('parkingAvailable').optional().isBoolean(),
  body('wheelchairAccessible').optional().isBoolean(),
  body('facilities').optional().isArray(),
  body('facilities.*').optional().isMongoId().withMessage('Invalid facility ID'),
  body('tags').optional().isArray(),
  body('keywords').optional().isArray(),
  body('isFeatured').optional().isBoolean(),
  body('isPopular').optional().isBoolean(),
  body('status')
    .optional()
    .isIn(['active', 'inactive', 'draft'])
    .withMessage('Status must be active, inactive, or draft'),
  body('seoTitle').optional().isString().trim(),
  body('seoDescription').optional().isString().trim(),
  body('galleryImages').optional().isArray(),
];

const update = [
  param('id').isMongoId().withMessage('Invalid Temple ID'),
  body('name').optional().isString().trim().isLength({ max: 200 }),
  body('shortDescription').optional().isString().trim().isLength({ max: 500 }),
  body('categoryId').optional().isMongoId().withMessage('Invalid Category ID'),
  body('locationId').optional().isMongoId().withMessage('Invalid Location ID'),
  body('coverImage').optional().isString(),
  body('latitude').optional().isFloat({ min: -90, max: 90 }),
  body('longitude').optional().isFloat({ min: -180, max: 180 }),
  body('history').optional().isString().trim(),
  body('importance').optional().isString().trim(),
  body('darshanTiming').optional().isString().trim(),
  body('phone').optional().isString().trim(),
  body('website').optional().isString().trim(),
  body('donationUrl').optional().isString().trim(),
  body('guestHouseBookingUrl').optional().isString().trim(),
  body('liveDarshanUrl').optional().isString().trim(),
  body('visitDuration').optional().isString().trim(),
  body('parkingAvailable').optional().isBoolean(),
  body('wheelchairAccessible').optional().isBoolean(),
  body('facilities').optional().isArray(),
  body('tags').optional().isArray(),
  body('keywords').optional().isArray(),
  body('isFeatured').optional().isBoolean(),
  body('isPopular').optional().isBoolean(),
  body('status').optional().isIn(['active', 'inactive', 'draft']),
  body('seoTitle').optional().isString().trim(),
  body('seoDescription').optional().isString().trim(),
  body('galleryImages').optional().isArray(),
];

const idParam = [param('id').isMongoId().withMessage('Invalid Temple ID')];

const listQuery = [
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('sort').optional().isString(),
  query('search').optional().isString(),
  query('status').optional().isIn(['active', 'inactive', 'draft']),
];

module.exports = {
  create,
  update,
  idParam,
  listQuery,
};
