const express = require('express');
const router = express.Router();

const festivalController = require('../controllers/festivalController');
const festivalValidator = require('../validators/festivalValidator');
const validateRequest = require('../middleware/validateRequest');

router.get('/upcoming', festivalController.getUpcomingFestivals);
router.get('/temple/:templeId', festivalController.getFestivalsByTemple);

router.get('/', festivalController.getFestivals);
router.get('/:idOrSlug', festivalController.getFestival);
router.post('/', festivalValidator.create, validateRequest, festivalController.createFestival);
router.put('/:id', festivalValidator.update, validateRequest, festivalController.updateFestival);
router.delete('/:id', festivalValidator.idParam, validateRequest, festivalController.deleteFestival);
router.patch('/:id/restore', festivalValidator.idParam, validateRequest, festivalController.restoreFestival);

module.exports = router;
