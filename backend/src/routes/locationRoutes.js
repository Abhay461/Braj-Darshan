const express = require('express');
const router = express.Router();

const locationController = require('../controllers/locationController');
const locationValidator = require('../validators/locationValidator');
const validateRequest = require('../middleware/validateRequest');
const adminAuth = require('../middleware/adminAuth');

router.get('/', locationController.getLocations);
router.get('/:idOrSlug', locationController.getLocation);
router.post('/', locationValidator.create, validateRequest, adminAuth, locationController.createLocation);
router.put('/:id', locationValidator.update, validateRequest, adminAuth, locationController.updateLocation);
router.delete('/:id', locationValidator.idParam, validateRequest, adminAuth, locationController.deleteLocation);
router.patch('/:id/restore', locationValidator.idParam, validateRequest, adminAuth, locationController.restoreLocation);

module.exports = router;
