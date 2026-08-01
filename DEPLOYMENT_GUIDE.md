# Braj Darshan — Production Deployment Guide

Complete step-by-step guide for deploying the **Braj Darshan** platform to production environments.

---

## 1. 🌐 Backend Deployment (Render)

### Automatic Deployment via Render Blueprint
1. Log into [Render Dashboard](https://dashboard.render.com/).
2. Click **New +** -> **Blueprint**.
3. Connect your GitHub repository.
4. Select `render.yaml` from the repository root.
5. Fill in the required secrets under Environment Variables:
   - `MONGODB_URI`: `mongodb+srv://abhaykumarkrishnablessing_db_user:Abhay8521@vrindavan.cdnatfz.mongodb.net/braj_darshan?retryWrites=true&w=majority&appName=Vrindavan`
   - `CLOUDINARY_CLOUD_NAME`: `h8hnjlwh`
   - `CLOUDINARY_API_KEY`: `524231274586545`
   - `CLOUDINARY_API_SECRET`: `En60NnsPfv_LDnOdr2iZKbUtBoM`
   - `ADMIN_API_KEY`: `<Your-Secret-Admin-Key>`
   - `CORS_ORIGIN`: `https://braj-darshan-admin.vercel.app`
6. Click **Apply**. Render will automatically build, test, and deploy the service with HTTPS.

### Backend Endpoints Once Live
- **Root**: `https://braj-darshan-api.onrender.com/`
- **Health Check**: `https://braj-darshan-api.onrender.com/health`
- **API Base**: `https://braj-darshan-api.onrender.com/api/v1`
- **Swagger Documentation**: `https://braj-darshan-api.onrender.com/api-docs`

---

## 2. 💻 Admin Panel Deployment (Vercel)

### Automatic Deployment via Vercel
1. Log into [Vercel Dashboard](https://vercel.com/dashboard).
2. Click **Add New** -> **Project**.
3. Import the GitHub repository.
4. Set **Root Directory** to `admin`.
5. Environment Variables:
   - `VITE_API_BASE_URL`: `https://braj-darshan-api.onrender.com/api/v1`
6. Click **Deploy**. Vercel will build Vite SPA assets with automatic fallback rewrites via `vercel.json`.

---

## 3. 📱 Flutter Mobile App Deployment (Android APK & AAB)

1. Navigate to the app directory:
   ```bash
   cd app
   flutter clean
   flutter pub get
   ```
2. Build Production Universal APK:
   ```bash
   flutter build apk --release
   ```
   *Generated Output:* `app/build/app/outputs/flutter-apk/app-release.apk`

3. Build Google Play Store Bundle (.aab):
   ```bash
   flutter build appbundle --release
   ```
   *Generated Output:* `app/build/app/outputs/bundle/release/app-release.aab`

---

## 4. 🗄️ Database & Cloud Services Verification

- **MongoDB Atlas**: Fully indexed on `temples`, `categories`, `locations`, `festivals`, `facilities`. Soft delete & text index enabled.
- **Cloudinary Storage**: Automated WebP/AVIF transformation, responsive image sizes, and automatic thumbnail generation.
