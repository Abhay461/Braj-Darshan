const cloudinaryHelper = require('../utils/cloudinaryHelper');
const ApiError = require('../utils/ApiError');

/**
 * Cloudinary Service — Service layer for image processing & Cloudinary CDN integration.
 */
class CloudinaryService {
  /**
   * Upload cover image for a temple (braj-darshan/temples/{slug}/cover)
   */
  async uploadCoverImage(fileBuffer, slug = 'general') {
    if (!fileBuffer) throw ApiError.badRequest('No image file provided');
    return cloudinaryHelper.uploadTempleCover(fileBuffer, slug);
  }

  /**
   * Upload single gallery image for a temple (braj-darshan/temples/{slug}/gallery)
   */
  async uploadGalleryImage(fileBuffer, slug = 'general', caption = '', order = 0) {
    if (!fileBuffer) throw ApiError.badRequest('No image file provided');
    return cloudinaryHelper.uploadTempleGalleryImage(fileBuffer, slug, caption, order);
  }

  /**
   * Upload generic image (categories, locations, festivals, banners)
   */
  async uploadImage(fileBuffer, folderType = 'misc') {
    if (!fileBuffer) throw ApiError.badRequest('No image file provided');
    
    switch (folderType) {
      case 'category':
      case 'categories':
        return cloudinaryHelper.uploadCategoryImage(fileBuffer);
      case 'location':
      case 'locations':
        return cloudinaryHelper.uploadLocationImage(fileBuffer);
      case 'festival':
      case 'festivals':
      case 'banner':
      case 'banners':
        return cloudinaryHelper.uploadFestivalBanner(fileBuffer);
      default:
        return cloudinaryHelper.uploadImage(fileBuffer, { folder: `braj-darshan/${folderType}` });
    }
  }

  /**
   * Delete an image by URL or public ID
   */
  async deleteImage(urlOrPublicId) {
    if (!urlOrPublicId) throw ApiError.badRequest('Image URL or public ID is required');
    return cloudinaryHelper.deleteImage(urlOrPublicId);
  }
}

module.exports = new CloudinaryService();
