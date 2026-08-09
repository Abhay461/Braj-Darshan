const express = require('express');
const router = express.Router();

const templeController = require('../controllers/templeController');
const templeValidator = require('../validators/templeValidator');
const validateRequest = require('../middleware/validateRequest');
const adminAuth = require('../middleware/adminAuth');

/**
 * @swagger
 * components:
 *   schemas:
 *     GalleryImage:
 *       type: object
 *       properties:
 *         imageUrl:
 *           type: string
 *         thumbnailUrl:
 *           type: string
 *         publicId:
 *           type: string
 *         caption:
 *           type: string
 *         order:
 *           type: integer
 *     Temple:
 *       type: object
 *       required:
 *         - name
 *         - shortDescription
 *         - categoryId
 *         - locationId
 *         - coverImage
 *         - latitude
 *         - longitude
 *       properties:
 *         _id:
 *           type: string
 *         name:
 *           type: string
 *         slug:
 *           type: string
 *         shortDescription:
 *           type: string
 *         history:
 *           type: string
 *         importance:
 *           type: string
 *         categoryId:
 *           type: string
 *         locationId:
 *           type: string
 *         coverImage:
 *           type: string
 *         thumbnailImage:
 *           type: string
 *         galleryImages:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/GalleryImage'
 *         darshanTiming:
 *           type: string
 *         phone:
 *           type: string
 *         website:
 *           type: string
 *         visitDuration:
 *           type: string
 *         parkingAvailable:
 *           type: boolean
 *         wheelchairAccessible:
 *           type: boolean
 *         latitude:
 *           type: number
 *         longitude:
 *           type: number
 *         facilities:
 *           type: array
 *           items:
 *             type: string
 *         tags:
 *           type: array
 *           items:
 *             type: string
 *         keywords:
 *           type: array
 *           items:
 *             type: string
 *         isFeatured:
 *           type: boolean
 *         isPopular:
 *           type: boolean
 *         status:
 *           type: string
 *           enum: [active, inactive, draft]
 *         seoTitle:
 *           type: string
 *         seoDescription:
 *           type: string
 */

// Featured, popular, recent, nearby
router.get('/featured', templeController.getFeaturedTemples);
router.get('/popular', templeController.getPopularTemples);
router.get('/recent', templeController.getRecentTemples);
router.get('/nearby', templeController.getNearbyTemples);

// Category and Location filters
router.get('/category/:categoryId', templeController.getTemplesByCategory);
router.get('/location/:locationId', templeController.getTemplesByLocation);

// Restore soft-deleted temple
router.patch('/:id/restore', templeValidator.idParam, validateRequest, adminAuth, templeController.restoreTemple);

// CRUD
router.get('/', templeValidator.listQuery, validateRequest, templeController.getTemples);
router.get('/:idOrSlug', templeController.getTemple);
router.post('/', templeValidator.create, validateRequest, adminAuth, templeController.createTemple);
router.put('/:id', templeValidator.update, validateRequest, adminAuth, templeController.updateTemple);
router.delete('/:id', templeValidator.idParam, validateRequest, adminAuth, templeController.deleteTemple);

module.exports = router;
