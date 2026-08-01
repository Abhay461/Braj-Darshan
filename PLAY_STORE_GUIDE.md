# Google Play Console Submission & Maintenance Guide

Complete step-by-step deployment guide for signing, building, and submitting **Braj Darshan** to the Google Play Store.

---

## 🔑 1. Android App Signing & Keystore Generation

### Step 1: Generate Release Keystore File
Run the following keytool command in terminal to create a production upload key:

```bash
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Step 2: Create `key.properties` File
Create `android/key.properties` in `app/android/`:

```properties
storePassword=<your-keystore-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=upload-keystore.jks
```

---

## 📦 2. Building Release Artifacts

### Generate Android App Bundle (.aab)
From the `app/` directory, run:

```bash
flutter build appbundle --release
```

The output file will be generated at:
`app/build/app/outputs/bundle/release/app-release.aab`

---

## 📋 3. Play Console Submission Steps

1. Log into [Google Play Console](https://play.google.com/console).
2. Click **Create app**:
   - App Name: `Braj Darshan — Temple Discovery`
   - Default Language: `English (US)`
   - App or Game: `App`
   - Free or Paid: `Free`
3. Complete **App Content & Compliance**:
   - **Privacy Policy**: Link to your hosted privacy policy URL.
   - **Ads**: Select "Yes, my app contains ads".
   - **App Access**: Select "All functionality is available without restrictions".
   - **Content Ratings**: Complete questionnaire (Expected rating: `3+` / `Everyone`).
   - **Target Audience**: Select `13+` and `Everyone`.
   - **Data Safety**: Declare no personal data collected; location used locally.
4. Set up **Store Listing**:
   - Copy metadata from [`PLAY_STORE_LISTING.md`](file:///d:/Braj%20mandel/PLAY_STORE_LISTING.md).
   - Upload App Icon (`512x512 PNG`).
   - Upload Feature Graphic (`1024x500 PNG`).
   - Upload Phone & Tablet Screenshots (at least 4 screenshots).
5. Create **Production Release**:
   - Upload `app-release.aab`.
   - Enter Release Notes for v1.0.0.
   - Review and roll out to Production.

---

## 🔄 4. Disaster Recovery & Backup Strategy

### MongoDB Database Backups
- Automated daily snapshots configured via MongoDB Atlas Cloud Backup.
- Manual JSON backup export via Admin Panel (`Backup & Import` page).

### Cloudinary CDN Image Backups
- Cloudinary auto-backup bucket synchronization to AWS S3.
