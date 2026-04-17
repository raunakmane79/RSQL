const express = require('express');
const { getPublications } = require('../services/publications.service');

const router = express.Router();

async function handler(req, res) {
  try {
    const publications = await getPublications();
    res.json(publications);
  } catch (error) {
    res.status(500).json({
      error: `Database/API error: ${error.message}`
    });
  }
}

router.get('/api/getPublications.asp', handler);
router.get('/API/getPublications.asp', handler);

module.exports = router;
