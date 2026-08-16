const express = require('express');
const router = express.Router();
const { extractLatLngFromText, resolveRedirectsAndExtract } = require('../services/coordinateUtils');

/**
 * POST /api/utils/resolve-coordinates
 * Resolves a Google Maps short URL (goo.gl, maps.app.goo.gl, etc.)
 * and extracts real lat/lng coordinates.
 */
router.post('/resolve-coordinates', async (req, res) => {
  try {
    const { mapUrl } = req.body;
    if (!mapUrl || !mapUrl.trim()) {
      return res.status(400).json({ success: false, message: 'mapUrl is required' });
    }

    // First try extracting from the URL text directly
    const directCoords = extractLatLngFromText(mapUrl);
    if (directCoords) {
      return res.json({ success: true, data: directCoords });
    }

    // If no coords in URL text, resolve the redirect chain
    const resolvedCoords = await resolveRedirectsAndExtract(mapUrl.trim());
    if (resolvedCoords) {
      return res.json({ success: true, data: resolvedCoords });
    }

    return res.status(404).json({
      success: false,
      message: 'Could not extract coordinates from this URL. Please paste the full Google Maps URL or enter lat/lng manually.',
    });
  } catch (err) {
    console.error('Error resolving coordinates:', err.message);
    return res.status(500).json({ success: false, message: 'Failed to resolve coordinates' });
  }
});

/**
 * POST /api/utils/fix-all-coordinates
 * Batch-fix coordinates for all temples with default/zero coords.
 * Resolves directionsUrl server-side for each temple and updates DB.
 */
router.post('/fix-all-coordinates', async (req, res) => {
  try {
    const Temple = require('../models/Temple');
    
    // Find temples with default or zero coordinates that have a directionsUrl
    const temples = await Temple.find({
      isDeleted: { $ne: true },
      directionsUrl: { $exists: true, $ne: '', $ne: null },
      $or: [
        { latitude: 27.5830, longitude: 77.7000 },
        { latitude: 0, longitude: 0 },
        { latitude: { $exists: false } },
        { longitude: { $exists: false } },
      ],
    });

    const results = { total: temples.length, fixed: 0, failed: 0, details: [] };

    for (const temple of temples) {
      const url = temple.directionsUrl?.trim();
      if (!url) {
        results.failed++;
        results.details.push({ name: temple.name, status: 'no_url' });
        continue;
      }

      // Try direct extraction first
      let coords = extractLatLngFromText(url);
      
      // If direct fails, resolve redirects
      if (!coords) {
        coords = await resolveRedirectsAndExtract(url);
      }

      if (coords) {
        await Temple.findByIdAndUpdate(temple._id, {
          latitude: coords.latitude,
          longitude: coords.longitude,
        });
        results.fixed++;
        results.details.push({ name: temple.name, status: 'fixed', lat: coords.latitude, lng: coords.longitude });
      } else {
        results.failed++;
        results.details.push({ name: temple.name, status: 'failed', url });
      }
    }

    return res.json({ success: true, data: results });
  } catch (err) {
    console.error('Batch fix error:', err.message);
    return res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;

