const express = require('express');
const router = express.Router();

const uploadController = require('../controllers/uploadController');

router.post('/cover', uploadController.upload.single('image'), uploadController.uploadCoverImage);
router.post('/gallery', uploadController.upload.single('image'), uploadController.uploadGalleryImage);
router.post('/gallery-multiple', uploadController.upload.array('images', 10), uploadController.uploadMultipleGalleryImages);
router.post('/image', uploadController.upload.single('image'), uploadController.uploadImage);
router.delete('/', uploadController.deleteImage);

module.exports = router;
