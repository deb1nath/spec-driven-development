---
name: api-test-postman
description: >
  Protocol for API contract testing using Postman/Newman. Generates collections
  from API contracts in BA output and runs them against the deployed staging app.
---

## API Contract Testing Protocol

### Step 1: Read API Contract
Open `docs/reports/{feature-id}/ba-output.md`. Find the "API Contract" section.
Each endpoint entry becomes a set of Postman requests.

### Step 2: Generate Postman Collection
If `postman/collections/{feature-id}.json` does not exist, create it:
```json
{
  "info": { "name": "{feature-id} API Tests", "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json" },
  "item": [
    {
      "name": "POST /api/{resource} — happy path",
      "request": {
        "method": "POST",
        "url": "{{base_url}}/api/{resource}",
        "header": [{ "key": "Content-Type", "value": "application/json" }],
        "body": { "mode": "raw", "raw": "{\"field\": \"value\"}" }
      },
      "event": [{ "listen": "test", "script": { "exec": [
        "pm.test('status is 201', () => pm.response.to.have.status(201));",
        "pm.test('body has id', () => pm.expect(pm.response.json()).to.have.property('id'));"
      ]}}]
    },
    {
      "name": "POST /api/{resource} — validation error",
      "request": {
        "method": "POST",
        "url": "{{base_url}}/api/{resource}",
        "body": { "mode": "raw", "raw": "{}" }
      },
      "event": [{ "listen": "test", "script": { "exec": [
        "pm.test('status is 400', () => pm.response.to.have.status(400));"
      ]}}]
    }
  ]
}
```
Collection must cover: happy path, at least 2 error paths, at least 1 edge case.

### Step 3: Execute Tests
```bash
npx newman run postman/collections/{feature-id}.json \
  --environment postman/environments/staging.json \
  --reporters cli,json \
  --reporter-json-export /tmp/newman-results.json
```
If Newman is not installed: `npm install -g newman`

### Step 4: Parse Results
From `/tmp/newman-results.json`, for each request extract:
- Request name and endpoint
- HTTP method
- Expected status code (from test assertions)
- Actual status code received
- Assertion results (passed/failed count)
- Response time in milliseconds

### Fallback — Newman Not Available
Use curl for each endpoint defined in the API contract:
```bash
curl -s -o /tmp/response.json -w "%{http_code}" \
  -X POST {staging-url}/api/{resource} \
  -H "Content-Type: application/json" \
  -d '{"field": "value"}'
```
Document each curl result manually in e2e-results.md.
