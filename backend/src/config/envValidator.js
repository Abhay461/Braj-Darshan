const Joi = require('joi');
const logger = require('../utils/logger');

// Define required environment variables and their validation rules
const envSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'production', 'test').required(),
  PORT: Joi.number().default(5000),
  MONGODB_URI: Joi.string().uri().required(),
  CLOUDINARY_URL: Joi.string().uri().optional(),
  CLOUDINARY_CLOUD_NAME: Joi.when('CLOUDINARY_URL', { is: Joi.exist(), then: Joi.optional(), otherwise: Joi.string().required() }),
  CLOUDINARY_API_KEY: Joi.when('CLOUDINARY_URL', { is: Joi.exist(), then: Joi.optional(), otherwise: Joi.string().required() }),
  CLOUDINARY_API_SECRET: Joi.when('CLOUDINARY_URL', { is: Joi.exist(), then: Joi.optional(), otherwise: Joi.string().required() }),
  ADMIN_API_KEY: Joi.string().required(),
  CORS_ORIGIN: Joi.string().optional(),
  RATE_LIMIT_WINDOW_MS: Joi.number().optional(),
  RATE_LIMIT_MAX_REQUESTS: Joi.number().optional(),
}).unknown(true);

const { error, value: envVars } = envSchema.validate(process.env, { abortEarly: false });

if (error) {
  logger.error(`Environment validation error: ${error.message}`);
  process.exit(1);
}

// Apply default values and validated env vars
Object.assign(process.env, envVars);
