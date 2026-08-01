const express = require('express');
const router = express.Router();

const facilityController = require('../controllers/facilityController');
const facilityValidator = require('../validators/facilityValidator');
const validateRequest = require('../middleware/validateRequest');

router.get('/', facilityController.getFacilities);
router.get('/:idOrSlug', facilityController.getFacility);
router.post('/', facilityValidator.create, validateRequest, facilityController.createFacility);
router.put('/:id', facilityValidator.update, validateRequest, facilityController.updateFacility);
router.delete('/:id', facilityValidator.idParam, validateRequest, facilityController.deleteFacility);
router.patch('/:id/restore', facilityValidator.idParam, validateRequest, facilityController.restoreFacility);

module.exports = router;
