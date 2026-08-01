const express = require('express');
const helmet = require('helmet');
const compression = require('compression');
const cors = require('cors');
const morgan = require('morgan');
const swaggerUi = require('swagger-ui-express');

const requestId = require('./middleware/requestId');
const routes = require('./routes');
const { apiLimiter } = require('./middleware/rateLimiter');
const errorHandler = require('./middleware/errorHandler');
const swaggerSpec = require('./config/swagger');
const logger = require('./utils/logger');
const healthController = require('./controllers/healthController');

const app = express();

// ─── Request Correlation ID ────────────────────────────
app.use(requestId);

// ─── Security ──────────────────────────────────────────
app.use(
  helmet({
    crossOriginResourcePolicy: { policy: 'cross-origin' },
  })
);

// ─── CORS ──────────────────────────────────────────────
const corsOrigins = process.env.CORS_ORIGIN
  ? process.env.CORS_ORIGIN.split(',').map((s) => s.trim())
  : ['*'];

app.use(
  cors({
    origin: corsOrigins.includes('*') ? '*' : corsOrigins,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization', 'x-request-id'],
    credentials: false,
  })
);

// ─── Compression ───────────────────────────────────────
app.use(
  compression({
    filter: (req, res) => {
      if (req.headers['x-no-compression']) return false;
      return compression.filter(req, res);
    },
    level: 6,
    threshold: 1024,
  })
);

// ─── Body Parsing ──────────────────────────────────────
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// ─── Logging (Morgan + Winston + Request ID) ───────────
morgan.token('req-id', (req) => req.id || '-');
morgan.token('duration', (req) => (req.startTime ? `${Date.now() - req.startTime}ms` : '-'));

const morganFormat = ':remote-addr - :method :url :status :res[content-length] - :response-time ms [ReqID: :req-id]';

const morganStream = {
  write: (message) => logger.info(message.trim()),
};

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan(morganFormat, { stream: morganStream }));
}

// ─── Rate Limiter ──────────────────────────────────────
app.use('/api/', apiLimiter);

// ─── Health Check Endpoints ─────────────────────────────
app.get('/health', healthController.getHealth);
app.get('/api/v1/health', healthController.getHealth);

// ─── Swagger UI ────────────────────────────────────────
app.use(
  '/api-docs',
  swaggerUi.serve,
  swaggerUi.setup(swaggerSpec, {
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'Braj Darshan API Documentation',
  })
);

app.get('/api-docs.json', (_req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.send(swaggerSpec);
});

// ─── API Routes ────────────────────────────────────────
app.use('/api/v1', routes);

// ─── Root ──────────────────────────────────────────────
app.get('/', (_req, res) => {
  res.status(200).json({
    success: true,
    message: 'Welcome to Braj Darshan API — Temple Discovery Platform',
    version: '1.0.0',
    docs: '/api-docs',
    health: '/api/v1/health',
  });
});

// ─── 404 Handler ───────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route not found - ${req.originalUrl}`,
  });
});

// ─── Global Error Handler ──────────────────────────────
app.use(errorHandler);

module.exports = app;
