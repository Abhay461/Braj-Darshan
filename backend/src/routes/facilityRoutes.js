const express = require('express');
const router = express.Router();

const facilityController = require('../controllers/facilityController');
const facilityValidator = require('../validators/facilityValidator');
const validateRequest = require('../middleware/validateRequest');
const adminAuth = require('../middleware/adminAuth');

router.get('/', facilityController.getFacilities);
router.get('/:idOrSlug', facilityController.getFacility);
router.post('/', facilityValidator.create, validateRequest, adminAuth, facilityController.createFacility);
router.put('/:id', facilityValidator.update, validateRequest, adminAuth, facilityController.updateFacility);
router.delete('/:id', facilityValidator.idParam, validateRequest, adminAuth, facilityController.deleteFacility);
router.patch('/:id/restore', facilityValidator.idParam, validateRequest, adminAuth, facilityController.restoreFacility);

module.exports = router;
