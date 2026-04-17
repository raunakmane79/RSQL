require('dotenv').config();
const path = require('path');
const express = require('express');
const publicationsRouter = require('./routes/publications');
const { shouldUseMockData } = require('./services/publications.service');

const app = express();
const port = Number(process.env.PORT || 3000);
const rootDir = path.join(__dirname, '..');

app.use(express.json());
app.use(publicationsRouter);

// Serve existing static frontend from repository root.
app.use(express.static(rootDir));

app.get('/health', (_req, res) => {
  res.json({
    ok: true,
    mode: shouldUseMockData() ? 'mock' : 'sql',
    timestamp: new Date().toISOString()
  });
});

app.listen(port, () => {
  console.log(`Server listening on http://localhost:${port}`);
  console.log('API endpoint: /api/getPublications.asp');
  console.log(`Data mode: ${shouldUseMockData() ? 'mock' : 'sql'}`);
});
