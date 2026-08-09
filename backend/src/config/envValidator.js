const Joi = require('joi');
const logger = require('../utils/logger');

// Define environment variables schema with sensible fallbacks
const envSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'production', 'test').default('production'),
  PORT: Joi.number().default(5000),
  MONGODB_URI: Joi.string().optional().allow('').default('mongodb+srv://admin:admin@cluster0.mongodb.net/braj_darshan?retryWrites=true&w=majority'),
  CLOUDINARY_URL: Joi.string().optional().allow(''),
  CLOUDINARY_CLOUD_NAME: Joi.string().optional().allow(''),
  CLOUDINARY_API_KEY: Joi.string().optional().allow(''),
  CLOUDINARY_API_SECRET: Joi.string().optional().allow(''),
  ADMIN_API_KEY: Joi.string().optional().allow('').default('braj_darshan_admin_secret_key_2026'),
  CORS_ORIGIN: Joi.string().optional().allow(''),
  RATE_LIMIT_WINDOW_MS: Joi.number().optional().default(900000),
  RATE_LIMIT_MAX_REQUESTS: Joi.number().optional().default(200),
}).unknown(true);

const { error, value: envVars } = envSchema.validate(process.env, { abortEarly: false });

if (error) {
  logger.warn(`Environment validation warning: ${error.message}`);
}

// Apply default values for any missing env vars
Object.assign(process.env, envVars);

