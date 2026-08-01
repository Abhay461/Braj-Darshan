const { validationResult } = require('express-validator');
const ApiError = require('../utils/ApiError');

/**
 * Middleware that checks express-validator results and throws a structured error.
 * Place after validation chain arrays in route definitions.
 */
const validateRequest = (req, _res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const formattedErrors = errors.array().map((err) => ({
      field: err.path || err.param,
      message: err.msg,
      value: err.value,
    }));
    throw ApiError.unprocessable('Validation failed', formattedErrors);
  }
  next();
};

module.exports = validateRequest;
