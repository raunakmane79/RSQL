# Local/Codespaces Run Guide

## 1) Install dependencies

```bash
npm install
```

## 2) Configure environment

```bash
cp .env.example .env
# Option A: set SQL_* variables and USE_MOCK_DATA=false (real DB)
# Option B: set USE_MOCK_DATA=true (local mock mode)
```

## 3) Start server

```bash
npm start
# or for local demo without DB:
npm run start:mock
```

## 4) Open app

- UI: `http://localhost:3000/index.html`
- API: `http://localhost:3000/api/getPublications.asp`
- Health: `http://localhost:3000/health`

## 5) Smoke check (optional)

```bash
npm run smoke
```

## Notes

- This Node endpoint is a Codespaces-compatible replacement for Classic ASP.
- Keep credentials in `.env`, never in source files.
- Mock data lives in `data/publications.mock.json` by default.
