const cloudinary = require('cloudinary').v2;
const logger = require('../utils/logger');

const configureCloudinary = () => {
  if (process.env.CLOUDINARY_URL) {
    cloudinary.config({
      cloudinary_url: process.env.CLOUDINARY_URL,
      secure: true,
    });
  } else {
    cloudinary.config({
      cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
      api_key: process.env.CLOUDINARY_API_KEY,
      api_secret: process.env.CLOUDINARY_API_SECRET,
      secure: true,
    });
  }

  logger.info('Cloudinary configured successfully');
  return cloudinary;
};

module.exports = { configureCloudinary, cloudinary };
