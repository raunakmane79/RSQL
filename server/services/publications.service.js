const fs = require('fs/promises');
const path = require('path');
const { getPool } = require('../config/db');

const queryPath = path.join(__dirname, '..', 'queries', 'publications.sql');
const defaultMockPath = path.join(__dirname, '..', '..', 'data', 'publications.mock.json');

async function loadQuery() {
  return fs.readFile(queryPath, 'utf8');
}

function normalizeRecord(record) {
  return {
    lastName: record.lastName ?? '',
    firstName: record.firstName ?? '',
    articleTitle: record.articleTitle ?? '',
    journalName: record.journalName ?? '',
    keywords: record.keywords ?? '',
    methodKeywords: record.methodKeywords ?? '',
    ranking: record.ranking ?? '',
    utdJournal: record.utdJournal ?? '',
    ftJournal: record.ftJournal ?? '',
    accdate: record.accdate ?? '',
    area: record.area ?? '',
    position: record.position ?? '',
    pubdate: record.pubdate ?? '',
    authorRank: record.authorRank ?? '',
    numAuthors: record.numAuthors ?? '',
    articleLink: record.articleLink ?? '',
    year: record.year ?? '',
    endDateAtRawls: record.endDateAtRawls ?? '',
    startDateAtRawls: record.startDateAtRawls ?? ''
  };
}

function shouldUseMockData() {
  return String(process.env.USE_MOCK_DATA || '').toLowerCase() === 'true';
}

async function loadMockData() {
  const mockPath = process.env.MOCK_DATA_PATH
    ? path.resolve(process.cwd(), process.env.MOCK_DATA_PATH)
    : defaultMockPath;

  const json = await fs.readFile(mockPath, 'utf8');
  const parsed = JSON.parse(json);

  if (!Array.isArray(parsed)) {
    throw new Error(`Mock data file must contain a JSON array: ${mockPath}`);
  }

  return parsed.map(normalizeRecord);
}

async function getPublications() {
  if (shouldUseMockData()) {
    return loadMockData();
  }

  const query = await loadQuery();
  const pool = await getPool();
  const result = await pool.request().query(query);
  return (result.recordset || []).map(normalizeRecord);
}

module.exports = {
  getPublications,
  shouldUseMockData
};
