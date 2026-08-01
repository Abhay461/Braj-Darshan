/**
 * Custom API Error class for structured error responses.
 * Extends the native Error with HTTP status code and error details.
 */
class ApiError extends Error {
  /**
   * @param {number} statusCode - HTTP status code
   * @param {string} message - Human-readable error message
   * @param {Array} errors - Detailed validation/field errors
   * @param {boolean} isOperational - Trusted operational error vs programming error
   */
  constructor(statusCode, message, errors = [], isOperational = true) {
    super(message);
    this.statusCode = statusCode;
    this.success = false;
    this.errors = errors;
    this.isOperational = isOperational;

    Error.captureStackTrace(this, this.constructor);
  }

  static badRequest(message = 'Bad Request', errors = []) {
    return new ApiError(400, message, errors);
  }

  static notFound(message = 'Resource not found') {
    return new ApiError(404, message);
  }

  static conflict(message = 'Resource already exists') {
    return new ApiError(409, message);
  }

  static internal(message = 'Internal Server Error') {
    return new ApiError(500, message, [], false);
  }

  static forbidden(message = 'Forbidden') {
    return new ApiError(403, message);
  }

  static unauthorized(message = 'Unauthorized') {
    return new ApiError(401, message);
  }

  static tooManyRequests(message = 'Too many requests, please try again later') {
    return new ApiError(429, message);
  }

  static unprocessable(message = 'Unprocessable Entity', errors = []) {
    return new ApiError(422, message, errors);
  }
}

module.exports = ApiError;
