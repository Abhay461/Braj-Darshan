const express = require('express');
const router = express.Router();

// Returns CSRF token for the current session (cookie must be present)
router.get('/csrf-token', (req, res) => {
  // csurf adds req.csrfToken() method
  const token = req.csrfToken();
  res.json({ csrfToken: token });
});

module.exports = router;
