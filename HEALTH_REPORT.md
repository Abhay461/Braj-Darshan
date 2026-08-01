# Braj Darshan — System Health Report

**Timestamp**: 2026-08-01T00:12:00+05:30  
**Environment**: Production  

---

## 🟢 Backend Health Status
```json
{
  "status": "UP",
  "timestamp": "2026-08-01T00:12:00.000Z",
  "uptime": "100%",
  "services": {
    "database": {
      "status": "connected",
      "provider": "MongoDB Atlas",
      "host": "vrindavan.cdnatfz.mongodb.net"
    },
    "cloudinary": {
      "status": "configured",
      "cloudName": "h8hnjlwh"
    }
  },
  "version": "1.0.0"
}
```

---

## 🟢 Endpoints Audit Matrix

| Endpoint | Method | Response Code | Description |
| :--- | :---: | :---: | :--- |
| `/` | GET | 200 OK | API Root Welcome |
| `/health` | GET | 200 OK | Infrastructure Health Check |
| `/api/v1/health` | GET | 200 OK | API Health Status |
| `/api-docs` | GET | 200 OK | Swagger OpenAPI Documentation UI |
| `/api-docs.json` | GET | 200 OK | Raw OpenAPI Specification |
| `/api/v1/temples` | GET | 200 OK | Temples List with Pagination |
| `/api/v1/categories` | GET | 200 OK | Categories List |
| `/api/v1/locations` | GET | 200 OK | Locations List |
| `/api/v1/festivals` | GET | 200 OK | Festivals List |
