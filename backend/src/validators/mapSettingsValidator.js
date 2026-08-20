const { body, param } = require('express-validator');

const allowedPinIcons = [
  'location_on',
  'place',
  'temple_hindu',
  'location_pin',
  'my_location',
  'flag',
  'landscape',
  'terrain',
];

const allowedMapStyles = ['standard', 'satellite', 'terrain', 'hybrid', 'dark'];

const update = [
  param('id').optional().isMongoId().withMessage('Invalid Map Settings ID'),
  body('defaultZoom')
    .optional()
    .isFloat({ min: 1, max: 20 })
    .withMessage('Default zoom must be between 1 and 20'),
  body('minZoom')
    .optional()
    .isFloat({ min: 1, max: 20 })
    .withMessage('Min zoom must be between 1 and 20'),
  body('maxZoom')
    .optional()
    .isFloat({ min: 1, max: 20 })
    .withMessage('Max zoom must be between 1 and 20'),
  body('defaultCenterLat')
    .optional()
    .isFloat({ min: -90, max: 90 })
    .withMessage('Default center latitude must be between -90 and 90'),
  body('defaultCenterLng')
    .optional()
    .isFloat({ min: -180, max: 180 })
    .withMessage('Default center longitude must be between -180 and 180'),
  body('defaultPinIconStyle')
    .optional()
    .isIn(allowedPinIcons)
    .withMessage(`Invalid pin icon style. Allowed: ${allowedPinIcons.join(', ')}`),
  body('defaultPinColor')
    .optional()
    .matches(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/)
    .withMessage('Invalid hex color format (e.g., #C5221F or #FFF)'),
  body('defaultPinSize')
    .optional()
    .isInt({ min: 20, max: 80 })
    .withMessage('Pin size must be between 20 and 80'),
  body('mapStyle')
    .optional()
    .isIn(allowedMapStyles)
    .withMessage(`Invalid map style. Allowed: ${allowedMapStyles.join(', ')}`),
  body('availablePinIcons')
    .optional()
    .isArray()
    .withMessage('Available pin icons must be an array'),
  body('availablePinIcons.*.name')
    .optional()
    .isString()
    .trim()
    .notEmpty()
    .withMessage('Pin icon name is required'),
  body('availablePinIcons.*.iconClass')
    .optional()
    .isString()
    .trim()
    .notEmpty()
    .withMessage('Pin icon class is required'),
  body('availablePinIcons.*.isDefault')
    .optional()
    .isBoolean()
    .withMessage('isDefault must be a boolean'),
];

const idParam = [param('id').isMongoId().withMessage('Invalid Map Settings ID')];

module.exports = {
  update,
  idParam,
};
