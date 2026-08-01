const multer = require('multer');
const asyncHandler = require('../middleware/asyncHandler');
const cloudinaryService = require('../services/cloudinaryService');
const ApiResponse = require('../utils/ApiResponse');
const ApiError = require('../utils/ApiError');

// Memory storage — images stream directly to Cloudinary
const storage = multer.memoryStorage();

const fileFilter = (_req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/avif'];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new ApiError(400, 'Only JPEG, PNG, WebP, and AVIF images are allowed'), false);
  }
};

const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10 MB limit
  },
});

/**
 * @desc    Upload temple cover image (braj-darshan/temples/{slug}/cover)
 * @route   POST /api/v1/upload/cover
 */
const uploadCoverImage = asyncHandler(async (req, res) => {
  if (!req.file) throw ApiError.badRequest('No image file provided');

  const slug = req.body.slug || 'general';
  const result = await cloudinaryService.uploadCoverImage(req.file.buffer, slug);

  ApiResponse.created('Cover image uploaded successfully', result).send(res);
});

/**
 * @desc    Upload single temple gallery image (braj-darshan/temples/{slug}/gallery)
 * @route   POST /api/v1/upload/gallery
 */
const uploadGalleryImage = asyncHandler(async (req, res) => {
  if (!req.file) throw ApiError.badRequest('No image file provided');

  const slug = req.body.slug || 'general';
  const caption = req.body.caption || '';
  const order = parseInt(req.body.order, 10) || 0;

  const result = await cloudinaryService.uploadGalleryImage(req.file.buffer, slug, caption, order);

  ApiResponse.created('Gallery image uploaded successfully', result).send(res);
});

/**
 * @desc    Upload multiple gallery images
 * @route   POST /api/v1/upload/gallery-multiple
 */
const uploadMultipleGalleryImages = asyncHandler(async (req, res) => {
  if (!req.files || req.files.length === 0) {
    throw ApiError.badRequest('No image files provided');
  }

  const slug = req.body.slug || 'general';
  const results = await Promise.all(
    req.files.map((file, idx) =>
      cloudinaryService.uploadGalleryImage(file.buffer, slug, '', idx)
    )
  );

  ApiResponse.created('Gallery images uploaded successfully', results).send(res);
});

/**
 * @desc    Upload generic image (category, location, festival, banner)
 * @route   POST /api/v1/upload/image
 */
const uploadImage = asyncHandler(async (req, res) => {
  if (!req.file) throw ApiError.badRequest('No image file provided');

  const folder = req.body.folder || 'misc';
  const result = await cloudinaryService.uploadImage(req.file.buffer, folder);

  ApiResponse.created('Image uploaded successfully', result).send(res);
});

/**
 * @desc    Delete image from Cloudinary
 * @route   DELETE /api/v1/upload
 */
const deleteImage = asyncHandler(async (req, res) => {
  const { url, publicId } = req.body;
  if (!url && !publicId) {
    throw ApiError.badRequest('Image URL or publicId is required');
  }
  await cloudinaryService.deleteImage(url || publicId);
  ApiResponse.ok('Image deleted successfully').send(res);
});

module.exports = {
  upload,
  uploadCoverImage,
  uploadGalleryImage,
  uploadMultipleGalleryImages,
  uploadImage,
  deleteImage,
};
