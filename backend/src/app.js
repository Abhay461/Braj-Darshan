const express = require('express');
const helmet = require('helmet');
const compression = require('compression');
const cors = require('cors');
const morgan = require('morgan');
const swaggerUi = require('swagger-ui-express');
const mongoSanitize = require('express-mongo-sanitize');
const csurf = require('csurf');
const cookieParser = require('cookie-parser');

const requestId = require('./middleware/requestId');
const routes = require('./routes');
const { apiLimiter } = require('./middleware/rateLimiter');
const errorHandler = require('./middleware/errorHandler');
const swaggerSpec = require('./config/swagger');
const csrfRouter = require('./routes/csrf');
const adminLoginRouter = require('./routes/adminLogin');
const logger = require('./utils/logger');
const healthController = require('./controllers/healthController');

const app = express();

// ─── Request Correlation ID ────────────────────────────
app.use(requestId);
// Enforce HTTPS in production
app.use((req, res, next) => {
  if (process.env.NODE_ENV === 'production' && req.headers['x-forwarded-proto'] !== 'https') {
    return res.redirect(`https://${req.headers.host}${req.originalUrl}`);
  }
  next();
});

// ─── Strict CORS (whitelist) ────────────────────────
const allowedOrigins = process.env.CORS_ORIGIN?.split(',') || ['https://braj-darshan-wdw9.onrender.com'];
app.use(cors({
  origin: function (origin, callback) {
    // allow requests with no origin (mobile apps, curl)
    if (!origin) return callback(null, true);
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    return callback(new Error('Not allowed by CORS'));
  },
  methods: ['GET','POST','PUT','DELETE','PATCH','OPTIONS'],
  allowedHeaders: ['Content-Type','Authorization','x-request-id','X-API-Key','X-CSRF-Token'],
  credentials: true,
}));

// ─── Security ──────────────────────────────────────────
app.use(
  helmet({
    contentSecurityPolicy: {
      useDefaults: true,
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'"],
        styleSrc: ["'self'"],
        imgSrc: ["'self'", "data:", "https:"],
        connectSrc: ["'self'", "https:"],
        fontSrc: ["'self'", "https:", "data:"],
        objectSrc: ["'none'"],
        frameAncestors: ["'none'"]
      }
    },
    crossOriginResourcePolicy: { policy: 'cross-origin' },
    crossOriginOpenerPolicy: false,
    hsts: {
      maxAge: 31536000,
      includeSubDomains: true,
      preload: true
    }
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
// NoSQL injection protection: sanitize request data
app.use(mongoSanitize({
  replaceWith: '_',
}));

// ─── Cookie Parser & CSRF Protection ────────────────────────
app.use(cookieParser());
app.use(csurf({ cookie: true }));

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

// CSRF token endpoint (cookie‑based)
app.use('/api/v1', csrfRouter);

// Admin authentication endpoint – returns JWT in HttpOnly cookie
app.use('/api/v1/admin', adminLoginRouter);

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
