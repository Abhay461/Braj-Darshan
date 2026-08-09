# Flutter/Dart ProGuard Rules for Braj Darshan

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Keep Hive
-keep class com.hivedb.** { *; }

# Keep Gson (used by various plugins)
-keepattributes Signature
-keepattributes *Annotation*

# Keep Notification classes
-keep class androidx.core.app.NotificationCompat { *; }

# General Android keep rules
-dontwarn kotlin.**
-dontwarn org.jetbrains.**
