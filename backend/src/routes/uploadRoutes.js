const express = require('express');
const router = express.Router();

const uploadController = require('../controllers/uploadController');
const { uploadLimiter } = require('../middleware/rateLimiter');
const adminAuth = require('../middleware/adminAuth');

router.post('/cover', uploadLimiter, uploadController.upload.single('image'), adminAuth, uploadController.uploadCoverImage);
router.post('/gallery', uploadLimiter, uploadController.upload.single('image'), adminAuth, uploadController.uploadGalleryImage);
router.post('/gallery-multiple', uploadLimiter, uploadController.upload.array('images', 10), adminAuth, uploadController.uploadMultipleGalleryImages);
router.post('/image', uploadLimiter, uploadController.upload.single('image'), adminAuth, uploadController.uploadImage);
router.delete('/', uploadLimiter, adminAuth, uploadController.deleteImage);

module.exports = router;
