# Braj Darshan — Deployment & Operations Guide

Production-ready deployment guide for the **Braj Darshan** Temple Discovery Platform (Node.js REST API, React 19 Admin Panel, and Flutter Android/iOS Mobile Application).

---

## 📱 Phase 3 Flutter Application (Android / iOS)

### Prerequisites
- Flutter SDK `>=3.19.0`
- Dart SDK `>=3.0.0`

### Building Android Release APK / App Bundle

1. Navigate to the app directory:
   ```bash
   cd app
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run analysis check:
   ```bash
   flutter analyze
   ```
4. Build Release APK for Google Play Store / Sideloading:
   ```bash
   flutter build apk --release
   ```
5. Build Android App Bundle (.aab) for Google Play Console:
   ```bash
   flutter build appbundle --release
   ```

---

## 🖥️ Phase 2 Admin Panel Deployment (Vercel / Netlify)

1. Connect your repository to Vercel.
2. Set Root Directory to `admin`.
3. Configure Build Settings:
   - **Framework Preset**: `Vite`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
4. Set Environment Variables:
   ```env
   VITE_API_BASE_URL=https://api.brajdarshan.com/api/v1
   ```

---

## ☁️ Cloud Backend Deployment Options (Render)

1. Connect repository to Render Web Service.
2. Set Directory to `backend`.
3. Set Start Command: `npm start`.
4. Configure `.env` variables (`MONGODB_URI`, `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`).

---

## ✅ Full Platform Production Checklist

- [x] Phase 1 Node.js REST API with dedicated repositories & soft delete
- [x] Phase 2 Admin Panel built with React 19, Vite, TypeScript, MUI 7, and TanStack Query
- [x] Phase 3 Mobile App built with Flutter, Riverpod, GoRouter, Dio, Hive, flutter_map, and Google Mobile Ads
- [x] Apple / Notion / Linear inspired monochrome minimal design (18dp borderRadius, Inter font)
- [x] Cloudinary Drag & Drop Gallery Manager with captions and order reordering
- [x] Bulk CSV / JSON Import & Backup Export
- [x] Offline Hive Favorites & Recent Searches
