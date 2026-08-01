/**
 * Standardised API response wrapper.
 * Ensures every successful response has a consistent shape.
 */
class ApiResponse {
  /**
   * @param {number} statusCode - HTTP status code
   * @param {string} message - Human-readable success message
   * @param {*} data - Response payload
   * @param {object} meta - Optional metadata (pagination, etc.)
   */
  constructor(statusCode, message, data = null, meta = null) {
    this.success = true;
    this.statusCode = statusCode;
    this.message = message;
    this.data = data;
    if (meta) this.meta = meta;
  }

  static ok(message, data, meta) {
    return new ApiResponse(200, message, data, meta);
  }

  static created(message, data) {
    return new ApiResponse(201, message, data);
  }

  static noContent() {
    return new ApiResponse(204, 'Deleted successfully');
  }

  /**
   * Send the response via Express res object.
   * @param {import('express').Response} res
   */
  send(res) {
    const body = {
      success: this.success,
      message: this.message,
    };
    if (this.data !== null && this.data !== undefined) body.data = this.data;
    if (this.meta) body.meta = this.meta;

    return res.status(this.statusCode).json(body);
  }
}

module.exports = ApiResponse;
