const swaggerJsdoc = require('swagger-jsdoc');

const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Braj Darshan REST API',
      version: '1.0.0',
      description:
        'Production REST API for Braj Darshan — Temple Discovery Platform. ' +
        'Supports unlimited temples, Cloudinary image pipeline (WebP/AVIF/Thumbnails), ' +
        'MongoDB text search & Atlas Search toggle, pagination, filtering, and geolocation.',
      contact: {
        name: 'Braj Darshan Support',
        email: 'support@brajdarshan.com',
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT',
      },
    },
    servers: [
      {
        url: '/api/v1',
        description: 'API v1',
      },
    ],
    components: {
      schemas: {
        Error: {
          type: 'object',
          properties: {
            success: { type: 'boolean', example: false },
            message: { type: 'string' },
            errors: {
              type: 'array',
              items: { type: 'object' },
            },
          },
        },
        PaginationMeta: {
          type: 'object',
          properties: {
            currentPage: { type: 'integer', example: 1 },
            totalPages: { type: 'integer', example: 10 },
            totalCount: { type: 'integer', example: 100 },
            limit: { type: 'integer', example: 10 },
            hasNextPage: { type: 'boolean', example: true },
            hasPrevPage: { type: 'boolean', example: false },
          },
        },
      },
    },
    tags: [
      { name: 'Temples', description: 'Temple discovery and management' },
      { name: 'Categories', description: 'Temple category management' },
      { name: 'Locations', description: 'Location management' },
      { name: 'Facilities', description: 'Facility management' },
      { name: 'Festivals', description: 'Festival management' },
      { name: 'Upload', description: 'Cloudinary image upload/delete' },
      { name: 'Health', description: 'System status check' },
    ],
  },
  apis: ['./src/routes/*.js'],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);

module.exports = swaggerSpec;
