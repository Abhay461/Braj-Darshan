const express = require('express');
const router = express.Router();

const emergencyContactController = require('../controllers/emergencyContactController');
const emergencyContactValidator = require('../validators/emergencyContactValidator');
const validateRequest = require('../middleware/validateRequest');
const adminAuth = require('../middleware/adminAuth');

router.get('/category/:category', emergencyContactController.getEmergencyContactsByCategory);

router.get('/', emergencyContactValidator.listQuery, validateRequest, emergencyContactController.getEmergencyContacts);
router.get('/:id', emergencyContactController.getEmergencyContact);
router.post('/', emergencyContactValidator.create, validateRequest, adminAuth, emergencyContactController.createEmergencyContact);
router.put('/:id', emergencyContactValidator.update, validateRequest, adminAuth, emergencyContactController.updateEmergencyContact);
router.delete('/:id', emergencyContactValidator.idParam, validateRequest, adminAuth, emergencyContactController.deleteEmergencyContact);
router.patch('/:id/restore', emergencyContactValidator.idParam, validateRequest, adminAuth, emergencyContactController.restoreEmergencyContact);

module.exports = router;