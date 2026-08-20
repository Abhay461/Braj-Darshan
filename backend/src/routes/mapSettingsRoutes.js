const express = require('express');
const router = express.Router();

const mapSettingsController = require('../controllers/mapSettingsController');
const mapSettingsValidator = require('../validators/mapSettingsValidator');
const validateRequest = require('../middleware/validateRequest');
const adminAuth = require('../middleware/adminAuth');

/**
 * @swagger
 * /api/v1/map-settings:
 *   get:
 *     summary: Get global map settings
 *     tags: [Map Settings]
 *     responses:
 *       200:
 *         description: Map settings retrieved successfully
 *   put:
 *     summary: Update global map settings
 *     tags: [Map Settings]
 *     security:
 *       - adminApiKey: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               defaultZoom:
 *                 type: number
 *                 minimum: 1
 *                 maximum: 20
 *               minZoom:
 *                 type: number
 *                 minimum: 1
 *                 maximum: 20
 *               maxZoom:
 *                 type: number
 *                 minimum: 1
 *                 maximum: 20
 *               defaultCenterLat:
 *                 type: number
 *                 minimum: -90
 *                 maximum: 90
 *               defaultCenterLng:
 *                 type: number
 *                 minimum: -180
 *                 maximum: 180
 *               defaultPinIconStyle:
 *                 type: string
 *                 enum: [location_on, place, temple_hindu, location_pin, my_location, flag, landscape, terrain]
 *               defaultPinColor:
 *                 type: string
 *                 pattern: '^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$'
 *               defaultPinSize:
 *                 type: integer
 *                 minimum: 20
 *                 maximum: 80
 *               mapStyle:
 *                 type: string
 *                 enum: [standard, satellite, terrain, hybrid, dark]
 *               availablePinIcons:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     name:
 *                       type: string
 *                     iconClass:
 *                       type: string
 *                     isDefault:
 *                       type: boolean
 *     responses:
 *       200:
 *         description: Map settings updated successfully
 *   post:
 *     path: /api/v1/map-settings/reset
 *     summary: Reset global map settings to defaults
 *     tags: [Map Settings]
 *     security:
 *       - adminApiKey: []
 *     responses:
 *       200:
 *         description: Map settings reset to defaults successfully
 */

router.get('/', mapSettingsController.getMapSettings);
router.put('/', mapSettingsValidator.update, validateRequest, adminAuth, mapSettingsController.updateMapSettings);
router.post('/reset', mapSettingsValidator.idParam, validateRequest, adminAuth, mapSettingsController.resetMapSettings);

module.exports = router;
