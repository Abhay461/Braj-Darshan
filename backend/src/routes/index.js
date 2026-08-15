const express = require('express');
const router = express.Router();

const templeRoutes = require('./templeRoutes');
const categoryRoutes = require('./categoryRoutes');
const locationRoutes = require('./locationRoutes');
const facilityRoutes = require('./facilityRoutes');
const festivalRoutes = require('./festivalRoutes');
const uploadRoutes = require('./uploadRoutes');
const utilRoutes = require('./utilRoutes');
const healthController = require('../controllers/healthController');

router.get('/health', healthController.getHealth);

router.use('/temples', templeRoutes);
router.use('/categories', categoryRoutes);
router.use('/locations', locationRoutes);
router.use('/facilities', facilityRoutes);
router.use('/festivals', festivalRoutes);
router.use('/upload', uploadRoutes);
router.use('/utils', utilRoutes);

module.exports = router;
