# Braj Darshan Home Screen Enhancements - Implementation Plan

## Overview
Implement 5 major Home Screen enhancements while preserving existing architecture, navigation, and functionality.

---

## 1. UPCOMING AARTI COUNTDOWN WIDGET

### Backend Changes
- **Add `aartiTimings` field to Temple model** (`backend/src/models/Temple.js`):
  ```javascript
  aartiTimings: [{
    name: { type: String, required: true }, // e.g., "Mangala Aarti", "Evening Aarti"
    time: { type: String, required: true }, // "HH:mm" 24-hour format, e.g., "05:30", "18:30"
    description: { type: String, default: '' }
  }]
  ```
- Update `templeValidator.js` for validation
- Update `templeController.js` to handle new field
- Run migration or seed with sample data for major temples

### Flutter Changes
- **Update `Temple` model** (`app/lib/shared/models/models.dart`):
  ```dart
  class AartiTiming {
    final String name;
    final String time; // "HH:mm"
    final String description;
  }
  final List<AartiTiming> aartiTimings;
  ```
- **Create `AartiCountdownProvider`** (`app/lib/shared/providers/providers.dart`):
  - Stream-based provider that calculates next upcoming aarti across all temples (or featured temples)
  - Updates every minute via `Stream.periodic`
  - Handles "tomorrow" case gracefully
  - Returns `AartiCountdownData?` (null if no valid data)
- **Create `AartiCountdownCard` widget** (`app/lib/features/home/widgets/aarti_countdown_card.dart`):
  - Compact card showing: Temple name, Aarti name, Countdown (HH:MM:SS or "Tomorrow at HH:MM")
  - Tap → navigate to temple detail
  - Auto-hide if no valid aarti timing data
  - Professional design with saffron accent
- **Integrate into HomeScreen** after Search section

---

## 2. BRAJ WEATHER & YATRA ALERT

### Backend Changes
- **Add weather proxy endpoint** (`backend/src/routes/weatherRoutes.js`):
  - `GET /api/weather?lat=X&lng=Y` - Proxies to weather API (OpenWeatherMap/WeatherAPI)
  - API key stored in backend `.env` only
  - Caches response for 10 minutes (Redis or in-memory)
  - Returns: temp, condition, humidity, wind, icon
- **Add to `backend/src/routes/index.js`**

### Flutter Changes
- **Create `WeatherService`** (`app/lib/core/services/weather_service.dart`):
  - Calls backend `/api/weather` with default Braj coordinates (27.5830, 77.7000)
  - Handles loading, error, offline states
- **Create `WeatherProvider`** (`app/lib/shared/providers/providers.dart`):
  - `FutureProvider<WeatherData>` with 10-min cache (Hive or in-memory)
  - Refresh on pull-to-refresh
- **Create `WeatherYatraCard` widget** (`app/lib/features/home/widgets/weather_yatra_card.dart`):
  - Shows: Location, Temperature, Condition icon, Yatra suggestion
  - Suggestions based on condition:
    - Rain → "Carry an umbrella"
    - Heat (>35°C) → "Prefer morning/evening darshan"
    - Pleasant (20-30°C) → "Perfect weather for darshan"
    - Fog/low visibility → "Travel carefully"
  - Graceful loading (skeleton), error (retry), offline (cached data)
- **Integrate into HomeScreen** below Aarti Countdown

---

## 3. FESTIVAL & SEASON SPECIAL THEMES

### Backend Changes
- **Festival model already has `startDate`/`endDate`** - use for auto-activation
- **Add optional `themeConfig` field** to Festival model (`backend/src/models/Festival.js`):
  ```javascript
  themeConfig: {
    bannerImage: String,
    accentColor: String, // hex
    showPetals: Boolean,
    petalType: String, // 'gulal', 'flower', 'diya'
  }
  ```
- Update validator, controller, Admin FestivalModal

### Flutter Changes
- **Create `FestivalThemeProvider`** (`app/lib/shared/providers/providers.dart`):
  - Watches `festivalsProvider`
  - Finds currently active festival (today within startDate-endDate)
  - Returns `FestivalThemeConfig?` with theme properties
- **Update `AppTheme`** (`app/lib/core/theme/app_theme.dart`):
  - Add festival theme extension methods
  - Support subtle accent color override
- **Create `FestivalBanner` widget** (`app/lib/features/home/widgets/festival_banner.dart`):
  - Small banner at top of HomeScreen (below Aarti/Weather)
  - Shows festival name, date range, optional banner image
  - Subtle accent color variation on cards/buttons during festival
  - Optional lightweight particle effect (gulal/petals) - use `flutter_particles` or custom painter, max 20 particles, disabled in dark mode/low-end
- **Apply theme** in HomeScreen: wrap relevant sections with `FestivalThemeWrapper`

---

## 4. EMERGENCY & YATRI HELP

### Backend Changes
- **Create `EmergencyContact` model** (`backend/src/models/EmergencyContact.js`):
  ```javascript
  {
    name: String, // "Tourist Police", "Ambulance", "Nearby Hospital"
    category: String, // "police", "medical", "fire", "helpline"
    phone: String,
    description: String,
    location: { lat: Number, lng: Number, address: String }, // for hospitals
    isActive: Boolean,
    sortOrder: Number
  }
  ```
- Create CRUD routes, controller, validator
- Add to Admin Panel: new page `EmergencyContactsList.tsx` + `EmergencyModal.tsx`
- Seed with verified UP/Braj emergency numbers

### Flutter Changes
- **Create `EmergencyProvider`** (`app/lib/shared/providers/providers.dart`):
  - Fetches active emergency contacts from backend
- **Create `EmergencyQuickAction` widget** (`app/lib/features/home/widgets/emergency_quick_action.dart`):
  - Compact FAB or Quick Action item (configurable)
  - Shows 3 icons: Police, Hospital, Ambulance
  - Tap → bottom sheet with list, tap number → confirm → `url_launcher` tel:
  - For hospitals: use existing map/location to show nearby
- **Integrate into HomeScreen** Quick Actions section

---

## 5. SPIRITUAL DESIGN SYSTEM

### Theme Overhaul (`app/lib/core/theme/app_theme.dart`)
**New Color Palette:**
```dart
// Light Theme
static const Color primarySaffron = Color(0xFFE65100);
static const Color secondarySaffron = Color(0xFFFF9800);
static const Color templeGold = Color(0xFFD4AF37);
static const Color sandalwoodCream = Color(0xFFF9F0); // scaffoldBackgroundColor
static const Color deepBrown = Color(0xFF2C1A0E); // onSurface primary text

// Dark Theme
static const Color primarySaffronDark = Color(0xFFFFB74D);
static const Color secondarySaffronDark = Color(0xFFFF9800);
static const Color templeGoldDark = Color(0xFFD4AF37);
static const Color sandalwoodDark = Color(0xFF1A1508); // scaffoldBackgroundColor
static const Color deepBrownDark = Color(0xFFF5F5F5); // onSurface primary text
```

**ColorScheme Mapping:**
- Light: primary=primarySaffron, secondary=secondarySaffron, surface=sandalwoodCream, onSurface=deepBrown
- Dark: primary=primarySaffronDark, secondary=secondarySaffronDark, surface=sandalwoodDark, onSurface=deepBrownDark
- Gold reserved for: badges, premium highlights, festival accents only

**Typography:**
- Headings: `GoogleFonts.rozhaOne()` (with fallback to Noto Sans Devanagari for Hindi)
- Body/UI: `GoogleFonts.outfit()`
- Centralized in `TextTheme`

**Update all hardcoded colors** in:
- HomeScreen, TempleDetailScreen, SearchScreen, FestivalsScreen, Drawer, etc.
- Replace `Color(0xFFC5221F)` → `Theme.of(context).colorScheme.primary`
- Replace hardcoded gold → `AppTheme.templeGold` (only for highlights)

---

## 6. HOME SCREEN LAYOUT REORDER

### New Order in `HomeScreen.build()`:
1. Existing Header (AppBar + Drawer)
2. Search (AppBar action)
3. **Upcoming Aarti Countdown** (conditional)
4. **Weather & Yatra Alert** (conditional)
5. **Festival Banner** (conditional - only during active festival)
6. Quick Actions (add Emergency button)
7. Top Destinations (existing)
8. Explore by Area / Categories (existing - currently missing, add if needed)
9. Nearby Temples (existing - currently missing, add if needed)
10. Upcoming Festivals (existing - from festivalsProvider)
11. Suggested Yatra (existing - currently missing, add if needed)
12. Daily Krishna Vani (new - simple quote card)
13. Existing temple content/list

### Implementation:
- Refactor `HomeScreen.build()` to use modular section widgets
- Each section is a separate widget with conditional rendering
- Use `SliverList`/`CustomScrollView` for better performance (optional, current `SingleChildScrollView` works)

---

## 7. PERFORMANCE & ACCESSIBILITY

- **Aarti Countdown**: Use `Stream.periodic(Duration(minutes: 1))` + `Timer` disposed in `dispose()`
- **Weather**: Cache in Hive with timestamp, 10-min TTL
- **Festival Theme**: Computed from existing festival data, no extra API calls
- **Lazy rendering**: Wrap sections in `VisibilityDetector` or use `ListView.builder` where possible
- **Touch targets**: Minimum 48dp (already enforced by `IconButtonTheme`)
- **Semantics**: Add `Semantics` labels to all interactive widgets
- **Dark mode**: Test all new widgets in both themes

---

## 8. ADMIN CONTROL

| Feature | Admin Control |
|---------|---------------|
| Aarti Timings | Temple form - add/edit aartiTimings array |
| Festival Theme | Festival form - dates auto-activate, optional themeConfig |
| Emergency Contacts | New Emergency Contacts page - full CRUD |
| Weather | Backend env only (API key) |

---

## FILES TO MODIFY/CREATE

### Backend (Node.js/Express/MongoDB)
| File | Action |
|------|--------|
| `backend/src/models/Temple.js` | Add `aartiTimings` field |
| `backend/src/validators/templeValidator.js` | Validate aartiTimings |
| `backend/src/controllers/templeController.js` | Handle aartiTimings CRUD |
| `backend/src/models/Festival.js` | Add optional `themeConfig` |
| `backend/src/validators/festivalValidator.js` | Validate themeConfig |
| `backend/src/controllers/festivalController.js` | Handle themeConfig |
| `backend/src/models/EmergencyContact.js` | **NEW** |
| `backend/src/controllers/emergencyContactController.js` | **NEW** |
| `backend/src/validators/emergencyContactValidator.js` | **NEW** |
| `backend/src/routes/emergencyContactRoutes.js` | **NEW** |
| `backend/src/routes/weatherRoutes.js` | **NEW** - weather proxy |
| `backend/src/routes/index.js` | Register new routes |
| `backend/src/seed/seedData.js` | Seed aarti timings, emergency contacts |

### Admin Panel (React/TypeScript)
| File | Action |
|------|--------|
| `admin/src/pages/temples/TempleForm.tsx` | Add aartiTimings field |
| `admin/src/pages/festivals/FestivalModal.tsx` | Add themeConfig fields |
| `admin/src/pages/emergency/EmergencyContactsList.tsx` | **NEW** |
| `admin/src/pages/emergency/EmergencyModal.tsx` | **NEW** |
| `admin/src/hooks/useEmergencyContacts.ts` | **NEW** |
| `admin/src/routes/AppRoutes.tsx` | Add emergency routes |
| `admin/src/layouts/DashboardLayout.tsx` | Add Emergency menu item |

### Flutter App
| File | Action |
|------|--------|
| `app/lib/core/theme/app_theme.dart` | **MAJOR** - New color palette, typography |
| `app/lib/shared/models/models.dart` | Add `AartiTiming`, `WeatherData`, `EmergencyContact`, `FestivalThemeConfig` |
| `app/lib/shared/providers/providers.dart` | Add providers for aarti, weather, emergency, festival theme |
| `app/lib/core/services/weather_service.dart` | **NEW** |
| `app/lib/features/home/home_screen.dart` | **MAJOR** - Restructure layout, add new sections |
| `app/lib/features/home/widgets/aarti_countdown_card.dart` | **NEW** |
| `app/lib/features/home/widgets/weather_yatra_card.dart` | **NEW** |
| `app/lib/features/home/widgets/festival_banner.dart` | **NEW** |
| `app/lib/features/home/widgets/emergency_quick_action.dart` | **NEW** |
| `app/lib/features/home/widgets/daily_krishna_vani.dart` | **NEW** |
| `app/lib/features/home/widgets/quick_actions_section.dart` | **NEW** (extract existing) |
| `app/lib/features/temple/temple_detail_screen.dart` | Update colors to use new theme |
| `app/lib/features/search/search_screen.dart` | Update colors |
| `app/lib/features/festivals/festivals_screen.dart` | Update colors |
| `app/lib/features/favorites/favorites_screen.dart` | Update colors |
| `app/lib/features/categories/categories_screen.dart` | Update colors |
| `app/lib/features/locations/locations_screen.dart` | Update colors |
| `app/lib/features/map/interactive_map_screen.dart` | Update colors |
| `app/lib/features/planner/yatra_planner_screen.dart` | Update colors |
| `app/lib/features/settings/settings_screen.dart` | Update colors |
| `app/lib/features/about/about_screen.dart` | Update colors |
| `app/pubspec.yaml` | Add `flutter_particles` (optional), `intl` for date formatting |

---

## VALIDATION CHECKLIST

After implementation, verify:

1. ✅ `flutter analyze` - no errors
2. ✅ `flutter run` - app launches
3. ✅ Aarti countdown updates every minute, shows "Tomorrow" correctly, hides when no data
4. ✅ Weather loads, shows suggestion, handles error/offline gracefully
5. ✅ Festival theme activates only during configured dates, subtle effects only
6. ✅ Emergency button works - shows contacts, confirms before calling
7. ✅ Light/Dark mode - all new widgets work in both
8. ✅ Hamburger Drawer, Search, Favorites, Notifications, Maps, Temple navigation, AdMob banner all work
9. ✅ No unnecessary changes to unrelated files
10. ✅ Accessibility: semantic labels, touch targets ≥48dp, contrast ratios

---

## RISKS & MITIGATIONS

| Risk | Mitigation |
|------|------------|
| Aarti timing data not available for all temples | Widget hides gracefully; only shows for temples with data |
| Weather API fails/rate limited | Backend caches 10min; Flutter shows cached data + offline indicator |
| Festival particle effect impacts performance | Max 20 particles; disable on low-end devices; optional |
| RozhaOne Hindi rendering issues | Fallback to `NotoSansDevanagari` via `fontFallback` in TextStyle |
| Theme migration breaks existing screens | Update all screens systematically; test both themes |
| Emergency numbers outdated | Admin-controlled; seed with verified UP government numbers |

---

## IMPLEMENTATION ORDER

1. **Backend**: Temple aartiTimings, EmergencyContact model, Weather proxy, Festival themeConfig
2. **Admin**: TempleForm aartiTimings, FestivalModal themeConfig, EmergencyContacts CRUD
3. **Flutter Theme**: Complete `app_theme.dart` overhaul
4. **Flutter Models/Providers**: New models, providers for aarti, weather, emergency, festival theme
5. **Flutter Widgets**: Aarti card, Weather card, Festival banner, Emergency action, Krishna Vani
6. **HomeScreen**: Restructure layout with new sections
6. **Other Screens**: Apply new theme colors
7. **Testing**: Run analyzer, test on device, verify all checklists

---

## OUT OF SCOPE

- Bottom Navigation Bar (explicitly forbidden)
- Removing/changing Hamburger Drawer
- Removing/moving Bottom AdMob Banner
- Changing Riverpod architecture
- Modifying unrelated backend functionality
- Inventing aarti timings/weather/emergency numbers/festival dates
- Exposing API keys in Flutter
- Full-screen festival animations
- Major temple list/navigation changes