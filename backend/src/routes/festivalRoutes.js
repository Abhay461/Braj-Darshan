const express = require('express');
const router = express.Router();

const festivalController = require('../controllers/festivalController');
const festivalValidator = require('../validators/festivalValidator');
const validateRequest = require('../middleware/validateRequest');
const adminAuth = require('../middleware/adminAuth');

router.get('/upcoming', festivalController.getUpcomingFestivals);
router.get('/temple/:templeId', festivalController.getFestivalsByTemple);

router.get('/', festivalController.getFestivals);
router.get('/:idOrSlug', festivalController.getFestival);
router.post('/', festivalValidator.create, validateRequest, adminAuth, festivalController.createFestival);
router.put('/:id', festivalValidator.update, validateRequest, adminAuth, festivalController.updateFestival);
router.delete('/:id', festivalValidator.idParam, validateRequest, adminAuth, festivalController.deleteFestival);
router.patch('/:id/restore', festivalValidator.idParam, validateRequest, adminAuth, festivalController.restoreFestival);

module.exports = router;
