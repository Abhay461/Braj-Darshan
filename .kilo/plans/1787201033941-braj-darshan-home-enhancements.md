# Braj Darshan Home Screen Enhancements - Implementation Plan (Updated)

## Current Status
- ✅ Backend: Temple aartiTimings, EmergencyContact model, Weather proxy, Festival themeConfig
- ✅ Admin: TempleForm aartiTimings, FestivalModal themeConfig, EmergencyContacts CRUD
- ✅ Flutter Theme: Complete `app_theme.dart` overhaul with spiritual design system
- ✅ Flutter Models/Providers: All models and providers in place
- ✅ Flutter Widgets: All 6 widgets created
- ✅ **String interpolation bugs FIXED in:** aarti_countdown_card.dart, weather_yatra_card.dart, festival_banner.dart
- ⏳ **String interpolation bugs PENDING in:** emergency_quick_action.dart (lines 90, 131, 208, 335, 492), daily_krishna_vani.dart (line 97)
- ❌ **HomeScreen**: Empty file - needs complete implementation
- ❌ **Other Screens**: Need theme migration (Search, TempleDetail, Festivals, Favorites, Categories, Locations, Map, YatraPlanner, Settings, About)

---

## Tasks to Complete

### 1. Fix Remaining String Interpolation Bugs in Widgets
- `emergency_quick_action.dart` - Lines 90 (Semantics label), 131 (View All Helplines), 208 (Semantics label), 335 (contacts count), 492 (Call confirmation)
- `daily_krishna_vani.dart` - Line 97 (quote text display)

### 2. Implement Complete HomeScreen
Create `home_screen.dart` with the new layout order:
1. Featured Carousel (existing)
2. Aarti Countdown (conditional)
3. Weather & Yatra Alert (conditional)
4. Festival Banner (conditional)
5. Quick Actions (with Emergency button)
6. Top Destinations (existing)
7. Explore by Area / Categories (new)
8. Nearby Temples (new)
9. Upcoming Festivals (new)
10. Suggested Yatra (new)
11. Daily Krishna Vani (new)
12. All Temples List (existing)
13. AdMob Banner (existing)

### 3. Apply New Theme to Other Screens
Update these screens to use new spiritual design system colors:
- `search_screen.dart`
- `temple_detail_screen.dart`
- `festivals_screen.dart`
- `favorites_screen.dart`
- `categories_screen.dart`
- `locations_screen.dart`
- `interactive_map_screen.dart`
- `yatra_planner_screen.dart`
- `settings_screen.dart`
- `about_screen.dart`

### 4. Run Verification
- `flutter analyze` - fix any errors
- `flutter run` - verify app launches and features work

### 2. Implement Complete HomeScreen
Create `home_screen.dart` with the new layout order:
1. Featured Carousel (existing)
2. Aarti Countdown (conditional)
3. Weather & Yatra Alert (conditional)
4. Festival Banner (conditional)
5. Quick Actions (with Emergency button)
6. Top Destinations (existing)
7. Explore by Area / Categories (new)
8. Nearby Temples (new)
9. Upcoming Festivals (new)
10. Suggested Yatra (new)
11. Daily Krishna Vani (new)
12. All Temples List (existing)
13. AdMob Banner (existing)

### 3. Apply New Theme to Other Screens
Update these screens to use new spiritual design system colors:
- `search_screen.dart`
- `temple_detail_screen.dart`
- `festivals_screen.dart`
- `favorites_screen.dart`
- `categories_screen.dart`
- `locations_screen.dart`
- `interactive_map_screen.dart`
- `yatra_planner_screen.dart`
- `settings_screen.dart`
- `about_screen.dart`

### 4. Run Verification
- `flutter analyze` - fix any errors
- `flutter run` - verify app launches and features work

---

## Files to Modify

| File | Action | Status |
|------|--------|--------|
| `app/lib/features/home/widgets/aarti_countdown_card.dart` | Fix string interpolation | ✅ Done |
| `app/lib/features/home/widgets/weather_yatra_card.dart` | Fix string interpolation | ✅ Done |
| `app/lib/features/home/widgets/festival_banner.dart` | Fix string interpolation | ✅ Done |
| `app/lib/features/home/widgets/emergency_quick_action.dart` | Fix string interpolation | ⏳ Pending |
| `app/lib/features/home/widgets/daily_krishna_vani.dart` | Fix string interpolation | ⏳ Pending |
| `app/lib/features/home/home_screen.dart` | **NEW** - Complete implementation | ❌ Not Started |
| `app/lib/features/search/search_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/temple/temple_detail_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/festivals/festivals_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/favorites/favorites_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/categories/categories_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/locations/locations_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/map/interactive_map_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/planner/yatra_planner_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/settings/settings_screen.dart` | Apply new theme colors | ❌ Not Started |
| `app/lib/features/about/about_screen.dart` | Apply new theme colors | ❌ Not Started |

---

## Validation Checklist
After implementation:
1. ⏳ `flutter analyze` - no errors
2. ⏳ `flutter run` - app launches
3. ⏳ Aarti countdown updates every minute, shows "Tomorrow" correctly, hides when no data
4. ⏳ Weather loads, shows suggestion, handles error/offline gracefully
5. ⏳ Festival theme activates only during configured dates, subtle effects only
6. ⏳ Emergency button works - shows contacts, confirms before calling
7. ⏳ Light/Dark mode - all new widgets work in both
8. ⏳ Hamburger Drawer, Search, Favorites, Notifications, Maps, Temple navigation, AdMob banner all work
9. ⏳ No unnecessary changes to unrelated files