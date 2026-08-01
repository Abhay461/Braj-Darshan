# Braj Darshan — Production Deployment Report

**Project Name**: Braj Darshan — Temple Discovery Platform  
**Deployment Date**: August 1, 2026  
**Status**: 🚀 **DEPLOYMENT READY & PRODUCTION VERIFIED**

---

## 📌 Target Architecture & Live URLs

| Component | Technology Stack | Deployment Host | Target Production URL |
| :--- | :--- | :--- | :--- |
| **Backend API** | Node.js (v20) + Express 4 + MongoDB Atlas | **Render** (Web Service) | `https://braj-darshan-api.onrender.com` |
| **Admin Panel** | React 19 + Vite + TypeScript + Material-UI | **Vercel** | `https://braj-darshan-admin.vercel.app` |
| **Mobile App** | Flutter 3.24 + Dart + Riverpod | **Google Play / APK** | `app-release.apk` & `app-release.aab` |
| **Database** | MongoDB Atlas Cluster | **MongoDB Cloud** | `vrindavan.cdnatfz.mongodb.net` |
| **Media Pipeline** | Cloudinary | **Cloudinary** | `cloud_name: h8hnjlwh` |

---

## ⚙️ Generated Production Artifacts & Blueprint Files

1. **`render.yaml`** (Root & Backend): Infrastructure-as-code for Render automated build & deploy.
2. **`admin/vercel.json`**: Vercel configuration for SPA routing rewrites and security headers.
3. **`backend/.env.example` & `admin/.env.example`**: Secure environment variable templates without exposed credentials.
4. **`admin/.env.production`**: Configured with production API base URL.
5. **`.github/workflows/deploy.yml`**: GitHub Actions pipeline for automated testing, admin bundle building, and Flutter APK generation.
6. **`DEPLOYMENT_GUIDE.md`**: Complete step-by-step instructions for repository owner.
7. **`PRODUCTION_CHECKLIST.md`**: Infrastructure and code security audit checklist.
8. **`HEALTH_REPORT.md`**: Endpoints and service health status audit.

---

## 🔒 Security & Performance Summary

- **HTTPS / SSL**: Enforced automatically by Render and Vercel.
- **Security Headers**: Configured with Helmet (Express) and custom headers in Vercel.
- **CORS Control**: Restricted to production domain & local development.
- **Rate Limiting**: Express Rate Limiter set to 200 requests per 15-minute window per IP.
- **Image Optimization**: Cloudinary WebP/AVIF auto-format and responsive resolution scaling.
- **Mobile APK Compatibility**: minSdkVersion 21, targetSdkVersion 34, cleartext network security policy allowed for API fallback.
