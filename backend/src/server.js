require('dotenv').config();

const app = require('./app');
const connectDatabase = require('./config/database');
const { configureCloudinary } = require('./config/cloudinary');
const logger = require('./utils/logger');

const PORT = process.env.PORT || 5000;

const startServer = async () => {
  try {
    // Connect to MongoDB Atlas
    await connectDatabase();

    // Configure Cloudinary
    configureCloudinary();

    // Start Express server
    const server = app.listen(PORT, () => {
      logger.info(`╔════════════════════════════════════════════╗`);
      logger.info(`║  Braj Darshan API Server                   ║`);
      logger.info(`║  Environment: ${process.env.NODE_ENV || 'development'}`.padEnd(46) + '║');
      logger.info(`║  Port: ${PORT}`.padEnd(46) + '║');
      logger.info(`║  API: http://localhost:${PORT}/api/v1`.padEnd(46) + '║');
      logger.info(`║  Docs: http://localhost:${PORT}/api-docs`.padEnd(46) + '║');
      logger.info(`╚════════════════════════════════════════════╝`);

      // Keep-alive: Ping self every 14 minutes to prevent Render free tier sleep
      if (process.env.NODE_ENV === 'production') {
        const RENDER_URL = process.env.RENDER_EXTERNAL_URL || `https://braj-darshan-wdw9.onrender.com`;
        setInterval(async () => {
          try {
            const https = require('https');
            https.get(`${RENDER_URL}/health`, (res) => {
              logger.info(`Keep-alive ping: ${res.statusCode}`);
            });
          } catch (err) {
            logger.warn(`Keep-alive ping failed: ${err.message}`);
          }
        }, 14 * 60 * 1000); // Every 14 minutes
        logger.info('Keep-alive ping enabled (every 14 minutes)');
      }
    });

    // Graceful shutdown
    const shutdown = (signal) => {
      logger.info(`${signal} received. Shutting down gracefully...`);
      server.close(() => {
        logger.info('HTTP server closed');
        process.exit(0);
      });

      // Force shutdown after 10 seconds
      setTimeout(() => {
        logger.error('Forced shutdown after timeout');
        process.exit(1);
      }, 10000);
    };

    process.on('SIGTERM', () => shutdown('SIGTERM'));
    process.on('SIGINT', () => shutdown('SIGINT'));

    // Unhandled errors
    process.on('unhandledRejection', (reason) => {
      logger.error(`Unhandled Rejection: ${reason}`);
    });

    process.on('uncaughtException', (error) => {
      logger.error(`Uncaught Exception: ${error.message}`);
      process.exit(1);
    });
  } catch (error) {
    logger.error(`Failed to start server: ${error.message}`);
    process.exit(1);
  }
};

startServer();
