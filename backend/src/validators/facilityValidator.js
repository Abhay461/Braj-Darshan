const { body, param } = require('express-validator');

const create = [
  body('name')
    .notEmpty()
    .withMessage('Facility name is required')
    .isString()
    .trim()
    .isLength({ max: 100 })
    .withMessage('Facility name cannot exceed 100 characters'),
  body('icon').optional().isString().trim(),
];

const update = [
  param('id').isMongoId().withMessage('Invalid Facility ID'),
  body('name').optional().isString().trim().isLength({ max: 100 }),
  body('icon').optional().isString().trim(),
];

const idParam = [param('id').isMongoId().withMessage('Invalid Facility ID')];

module.exports = {
  create,
  update,
  idParam,
};
