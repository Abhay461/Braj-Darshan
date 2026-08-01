# Braj Darshan — Production Backend API (Phase 1 Final)

Production-grade REST API for the **Braj Darshan** Temple Discovery Platform.

Built with Node.js LTS, Express.js, MongoDB Atlas, and Cloudinary. Designed to support 100,000+ temples and serve Flutter mobile apps, Admin Panels, and web applications seamlessly.

---

## 🌟 Key Architecture & Features

- **Clean Architecture & SOLID**: Service layer for business logic, dedicated repositories for data access, thin controllers for HTTP requests.
- **Dedicated Repositories**: Self-contained `TempleRepository`, `CategoryRepository`, `LocationRepository`, `FacilityRepository`, `FestivalRepository`.
- **Soft Delete Pattern**: Integrated `isDeleted` and `deletedAt` fields across all 5 models with restore endpoints.
- **Cloudinary Image Pipeline**: Automatic WebP, AVIF, thumbnail generation, and responsive URLs. Images are stored exclusively on Cloudinary (`braj-darshan/temples/{slug}/gallery`). Zero binary files in MongoDB.
- **Atlas Search Compatibility**: Full-text search with regex/text indexing default and configuration toggle (`ENABLE_ATLAS_SEARCH=true`) to enable MongoDB Atlas Search without API changes.
- **Request Correlation ID**: Express middleware generating `X-Request-ID` attached to Winston and Morgan loggers.
- **Health Check Metrics**: Detailed system state endpoint (`GET /api/v1/health`) returning database connection, Cloudinary status, version, and server uptime.
- **Swagger Documentation**: Interactive OpenAPI 3.0 documentation at `/api-docs`.

---

## 📁 Project Structure

```
backend/
├── src/
│   ├── config/           # Database, Cloudinary, Swagger configuration
│   ├── controllers/      # Thin HTTP request handlers (temple, category, location, etc.)
│   ├── middleware/       # Async handler, request ID, error handler, rate limiter, request validator
│   ├── models/           # Mongoose schemas (Temple, Category, Location, Facility, Festival)
│   ├── repositories/     # Dedicated repositories (TempleRepository, CategoryRepository, etc.)
│   ├── routes/           # Express routes with Swagger annotations
│   ├── seed/             # Database seeding script (8 real Braj temples)
│   ├── services/         # Business logic layer
│   ├── utils/            # ApiError, ApiResponse, ApiFeatures, Cloudinary helper, Logger
│   └── validators/       # Express-validator validation chains
├── .env.example
├── package.json
└── README.md
```

---

## 🚀 Environment Setup & Installation

### 1. Prerequisites
- Node.js 18+ LTS
- MongoDB Atlas Cluster
- Cloudinary Account

### 2. Environment Variables Configuration
Copy `.env.example` to `.env`:

```bash
cp .env.example .env
```

Configure your `.env` parameters:
```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb+srv://<username>:<password>@cluster0.mongodb.net/braj_darshan?retryWrites=true&w=majority
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CORS_ORIGIN=*
ENABLE_ATLAS_SEARCH=false
LOG_LEVEL=info
```

### 3. Install Dependencies
```bash
npm install
```

### 4. Seed Database
Populate database with 5 Categories, 6 Locations, 5 Facilities, 8 Temples, and Festivals:

```bash
npm run seed
```

To wipe database:
```bash
npm run seed:destroy
```

### 5. Start Server
```bash
npm run dev
```

The API will be available at `http://localhost:5000`.  
Swagger Docs available at `http://localhost:5000/api-docs`.

---

## 📡 API Endpoints

### Health & Specs
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/health` | System health, database, Cloudinary & uptime status |
| GET | `/api-docs` | Interactive Swagger UI |
| GET | `/api-docs.json` | OpenAPI 3.0 JSON spec |

### Temples (`/api/v1/temples`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/temples` | List temples (pagination, search, filtering, sorting) |
| GET | `/api/v1/temples/featured` | List featured temples |
| GET | `/api/v1/temples/popular` | List popular temples |
| GET | `/api/v1/temples/recent` | List recently added temples |
| GET | `/api/v1/temples/nearby?lat=&lng=` | Nearby temples by geolocation |
| GET | `/api/v1/temples/category/:categoryId` | Temples by category |
| GET | `/api/v1/temples/location/:locationId` | Temples by location |
| GET | `/api/v1/temples/:idOrSlug` | Single temple details |
| POST | `/api/v1/temples` | Create temple |
| PUT | `/api/v1/temples/:id` | Update temple |
| DELETE | `/api/v1/temples/:id` | Soft delete temple |
| PATCH | `/api/v1/temples/:id/restore` | Restore soft-deleted temple |

### Categories (`/api/v1/categories`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/categories` | List categories |
| GET | `/api/v1/categories/:idOrSlug` | Get single category |
| POST | `/api/v1/categories` | Create category |
| PUT | `/api/v1/categories/:id` | Update category |
| DELETE | `/api/v1/categories/:id` | Soft delete category |
| PATCH | `/api/v1/categories/:id/restore` | Restore category |

### Locations (`/api/v1/locations`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/locations` | List locations |
| GET | `/api/v1/locations/:idOrSlug` | Get single location |
| POST | `/api/v1/locations` | Create location |
| PUT | `/api/v1/locations/:id` | Update location |
| DELETE | `/api/v1/locations/:id` | Soft delete location |
| PATCH | `/api/v1/locations/:id/restore` | Restore location |

### Facilities (`/api/v1/facilities`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/facilities` | List facilities |
| GET | `/api/v1/facilities/:idOrSlug` | Get single facility |
| POST | `/api/v1/facilities` | Create facility |
| PUT | `/api/v1/facilities/:id` | Update facility |
| DELETE | `/api/v1/facilities/:id` | Soft delete facility |
| PATCH | `/api/v1/facilities/:id/restore` | Restore facility |

### Festivals (`/api/v1/festivals`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/festivals` | List festivals |
| GET | `/api/v1/festivals/upcoming` | Upcoming festivals |
| GET | `/api/v1/festivals/temple/:templeId` | Festivals for a temple |
| GET | `/api/v1/festivals/:idOrSlug` | Get single festival |
| POST | `/api/v1/festivals` | Create festival |
| PUT | `/api/v1/festivals/:id` | Update festival |
| DELETE | `/api/v1/festivals/:id` | Soft delete festival |
| PATCH | `/api/v1/festivals/:id/restore` | Restore festival |

### Upload (`/api/v1/upload`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/upload/cover` | Upload cover image (auto thumbnail) |
| POST | `/api/v1/upload/gallery` | Upload single gallery image |
| POST | `/api/v1/upload/gallery-multiple` | Upload multiple gallery images |
| POST | `/api/v1/upload/image` | Upload generic image (category/location/festival) |
| DELETE | `/api/v1/upload` | Delete image by publicId or URL |

---

## 🛠️ Verification & Quality

Run code syntax verification:
```bash
node -c src/server.js
```

Seed database:
```bash
npm run seed
```
