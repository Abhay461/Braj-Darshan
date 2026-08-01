const express = require('express');
const router = express.Router();

const locationController = require('../controllers/locationController');
const locationValidator = require('../validators/locationValidator');
const validateRequest = require('../middleware/validateRequest');

router.get('/', locationController.getLocations);
router.get('/:idOrSlug', locationController.getLocation);
router.post('/', locationValidator.create, validateRequest, locationController.createLocation);
router.put('/:id', locationValidator.update, validateRequest, locationController.updateLocation);
router.delete('/:id', locationValidator.idParam, validateRequest, locationController.deleteLocation);
router.patch('/:id/restore', locationValidator.idParam, validateRequest, locationController.restoreLocation);

module.exports = router;
