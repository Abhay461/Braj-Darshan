const { cloudinary } = require('../config/cloudinary');
const ApiError = require('./ApiError');
const logger = require('./logger');

/**
 * Cloudinary Helper — Production image pipeline for Braj Darshan.
 * All images are stored on Cloudinary CDN — zero binary storage in MongoDB.
 */
const cloudinaryHelper = {
  /**
   * Upload a single image buffer to Cloudinary with automatic WebP/AVIF generation and compression.
   * @param {Buffer} fileBuffer - Image file buffer
   * @param {object} options
   * @returns {Promise<{ imageUrl: string, thumbnailUrl: string, publicId: string }>}
   */
  async uploadImage(fileBuffer, options = {}) {
    try {
      const {
        folder = 'braj-darshan/misc',
        publicId,
        width,
        height,
        crop = 'limit',
      } = options;

      const uploadOptions = {
        folder,
        resource_type: 'image',
        quality: 'auto:good',
        fetch_format: 'auto', // Automatically delivers WebP/AVIF based on client browser support
        transformation: [],
      };

      if (publicId) {
        uploadOptions.public_id = publicId;
      }

      if (width || height) {
        const transform = { crop };
        if (width) transform.width = width;
        if (height) transform.height = height;
        uploadOptions.transformation.push(transform);
      }

      return new Promise((resolve, reject) => {
        const stream = cloudinary.uploader.upload_stream(
          uploadOptions,
          (error, result) => {
            if (error) {
              logger.error(`Cloudinary upload failed: ${error.message}`);
              reject(ApiError.internal('Image upload failed'));
            } else {
              // Generate automatic thumbnail URL via Cloudinary URL transformation
              const thumbnailUrl = cloudinary.url(result.public_id, {
                width: 300,
                height: 225,
                crop: 'fill',
                gravity: 'auto',
                quality: 'auto',
                fetch_format: 'auto',
                secure: true,
              });

              resolve({
                imageUrl: result.secure_url,
                thumbnailUrl,
                publicId: result.public_id,
                width: result.width,
                height: result.height,
                format: result.format,
                bytes: result.bytes,
              });
            }
          }
        );
        stream.end(fileBuffer);
      });
    } catch (error) {
      logger.error(`Cloudinary upload error: ${error.message}`);
      throw ApiError.internal('Image upload failed');
    }
  },

  /**
   * Upload cover image for a temple (braj-darshan/temples/{templeSlug}/cover)
   */
  async uploadTempleCover(fileBuffer, templeSlug = 'general') {
    const folder = `braj-darshan/temples/${templeSlug}`;
    return this.uploadImage(fileBuffer, {
      folder,
      publicId: `cover_${Date.now()}`,
      width: 1920,
      height: 1080,
      crop: 'limit',
    });
  },

  /**
   * Upload gallery image for a temple (braj-darshan/temples/{templeSlug}/gallery)
   */
  async uploadTempleGalleryImage(fileBuffer, templeSlug = 'general', caption = '', order = 0) {
    const folder = `braj-darshan/temples/${templeSlug}/gallery`;
    const result = await this.uploadImage(fileBuffer, {
      folder,
      width: 1600,
      height: 1200,
      crop: 'limit',
    });

    return {
      imageUrl: result.imageUrl,
      thumbnailUrl: result.thumbnailUrl,
      publicId: result.publicId,
      caption,
      order,
    };
  },

  /**
   * Upload Category icon/image (braj-darshan/categories)
   */
  async uploadCategoryImage(fileBuffer) {
    return this.uploadImage(fileBuffer, {
      folder: 'braj-darshan/categories',
      width: 800,
      height: 600,
    });
  },

  /**
   * Upload Location cover image (braj-darshan/locations)
   */
  async uploadLocationImage(fileBuffer) {
    return this.uploadImage(fileBuffer, {
      folder: 'braj-darshan/locations',
      width: 1600,
      height: 900,
    });
  },

  /**
   * Upload Festival banner image (braj-darshan/festivals or braj-darshan/banners)
   */
  async uploadFestivalBanner(fileBuffer) {
    return this.uploadImage(fileBuffer, {
      folder: 'braj-darshan/banners',
      width: 1920,
      height: 800,
    });
  },

  /**
   * Delete an image from Cloudinary by public ID or URL
   */
  async deleteImage(publicIdOrUrl) {
    if (!publicIdOrUrl) return;

    let publicId = publicIdOrUrl;
    if (publicIdOrUrl.includes('cloudinary.com')) {
      publicId = this.extractPublicId(publicIdOrUrl);
    }

    if (!publicId) return;

    try {
      const result = await cloudinary.uploader.destroy(publicId);
      logger.info(`Cloudinary image deleted: ${publicId}`);
      return result;
    } catch (error) {
      logger.error(`Cloudinary delete failed for ${publicId}: ${error.message}`);
      throw ApiError.internal('Image deletion failed');
    }
  },

  /**
   * Generate a responsive image URL with Cloudinary transforms.
   */
  getResponsiveUrl(publicId, { width, height, crop = 'fill', gravity = 'auto', format = 'auto' } = {}) {
    return cloudinary.url(publicId, {
      width,
      height,
      crop,
      gravity,
      quality: 'auto',
      fetch_format: format,
      secure: true,
      flags: 'progressive',
    });
  },

  /**
   * Extract public ID from a Cloudinary URL
   */
  extractPublicId(url) {
    if (!url) return null;
    try {
      const parts = url.split('/upload/');
      if (parts.length < 2) return null;
      let publicId = parts[1];
      publicId = publicId.replace(/^v\d+\//, '');
      publicId = publicId.replace(/\.[^/.]+$/, '');
      return publicId;
    } catch {
      return null;
    }
  },
};

module.exports = cloudinaryHelper;
