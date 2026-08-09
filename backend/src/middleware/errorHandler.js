const ApiError = require('../utils/ApiError');
const logger = require('../utils/logger');

/**
 * Global error-handling middleware.
 * Catches all errors thrown by controllers/services and returns a structured JSON response.
 */
const errorHandler = (err, req, res, _next) => {
  let error = { ...err, message: err.message };

  // Log the full stack for server-side debugging
  logger.error(`${err.message}`, { stack: err.stack, url: req.originalUrl, method: req.method });

  // Mongoose bad ObjectId
  if (err.name === 'CastError') {
    error = ApiError.badRequest(`Invalid ${err.path}: ${err.value}`);
  }

  // CSRF token error
  if (err.code === 'EBADCSRFTOKEN') {
    error = ApiError.forbidden('Invalid or missing CSRF token');
  }

  // Mongoose duplicate key
  if (err.code === 11000) {
    const field = Object.keys(err.keyValue).join(', ');
    error = ApiError.conflict(`Duplicate value for field: ${field}`);
  }

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    const errors = Object.values(err.errors).map((e) => ({
      field: e.path,
      message: e.message,
    }));
    error = ApiError.unprocessable('Validation failed', errors);
  }

  // Multer file size error
  if (err.code === 'LIMIT_FILE_SIZE') {
    error = ApiError.badRequest('File size exceeds the 5 MB limit');
  }

  // Multer unexpected field
  if (err.code === 'LIMIT_UNEXPECTED_FILE') {
    error = ApiError.badRequest('Unexpected file upload field');
  }

  // JSON parse error
  if (err.type === 'entity.parse.failed') {
    error = ApiError.badRequest('Malformed JSON in request body');
  }

  const statusCode = error.statusCode || 500;
  const response = {
    success: false,
    message: error.message || 'Internal Server Error',
  };

  if (error.errors && error.errors.length > 0) {
    response.errors = error.errors;
  }

  // Include stack trace only in development
  if (process.env.NODE_ENV === 'development') {
    response.stack = err.stack;
  }

  res.status(statusCode).json(response);
};

module.exports = errorHandler;
