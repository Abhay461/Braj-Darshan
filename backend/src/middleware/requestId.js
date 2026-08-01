const { v4: uuidv4 } = require('crypto');
const crypto = require('crypto');

/**
 * Request ID Middleware — Attaches unique request correlation ID
 * to every incoming request and sets 'X-Request-ID' header.
 */
const requestId = (req, res, next) => {
  const existingId = req.headers['x-request-id'];
  const reqId = existingId || (crypto.randomUUID ? crypto.randomUUID() : `req_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`);
  
  req.id = reqId;
  req.startTime = Date.now();
  res.setHeader('X-Request-ID', reqId);
  next();
};

module.exports = requestId;
