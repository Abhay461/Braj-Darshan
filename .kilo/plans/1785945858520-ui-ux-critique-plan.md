# UI/UX Critique & Recommendations

## Context
- **Technology**: Flutter mobile app (Android/iOS) with Light and Dark themes defined in `app/lib/core/theme/app_theme.dart`.
- **Color Tokens**: `primaryCharcoal`, `secondaryIndigo`, `accentSkyBlue`, `canvasLight`, `canvasDark`, `cardLight`, `cardDark`, `borderLight`, `borderDark`, `mutedGray`.
- **Typography**: Font family **Inter**; inline `TextStyle` definitions across screens (Home, Search, Settings, etc.).
- **Key Screens**: `HomeScreen`, `SearchScreen`, `Categories`, `Map`, `Planner`, `Favorites`, `Settings`.
- **Widgets**: `TempleCard`, `LoadingSkeleton`, `ErrorView`, `AdBannerWidget`, `FilterChip` for categories, carousel (`FeaturedTemplesCarousel`).
- **Navigation**: Hamburger **Drawer** with navigation items; bottom ad banner via `bottomNavigationBar`.
- **Layout**: `SingleChildScrollView` with `Column` for temple lists; `FilterChip` bar; auto‑scrolling carousel with infinite‑like page offset.

## Critique
### Color Palette
- Mixed cool blues/indigos with a warm gold (`#C5A059`) creates visual tension; lacks a unified brand accent.
- Contrast issues: secondary text (`mutedGray` `#71717A`) on `canvasLight` may fail WCAG AA for small text; drawer subtitle at 12.5 pt is borderline.
- Dark theme contrast is generally high, but selected chip background (`#18181B`) on dark surfaces can feel heavy.
- No clear CTA accent color; `secondaryIndigo` is under‑used for interactive elements.

### Layout
- **Drawer navigation** adds extra taps; primary actions are hidden.
- Temple list built as a `Column` inside a scroll view—potential performance impact for long lists.
- Category `FilterChip` height and tap target are small; selected chip uses dark background that may reduce readability.
- Carousel uses a large initial page offset (`_currentPage = 1000`), causing possible jitter and hard‑to‑maintain logic.
- Bottom ad banner occupies the full width and can obscure content on small devices.
- Inconsistent use of theme colors (e.g., `SearchScreen` uses `Color(0xFFFAFAFA)` instead of `canvasLight`).

### Typography
- Font family **Inter** is good, but many texts are < 14 sp (e.g., drawer subtitle 12.5, chip labels 12, error messages). Small sizes hinder readability for older users.
- Negative letter‑spacing (`-0.4`, `-0.5`) on headings reduces legibility.
- Inline `TextStyle`s prevent a single source of truth; changes require editing many files.

### Overall Usability
- No onboarding/first‑time guide to explain categories, search, or favorites.
- Accessibility gaps: images lack `semanticLabel`, icons missing `Semantics`, and some tap targets are < 48 dp.
- Feedback for actions (e.g., favoriting) is visual only; consider haptic feedback.
- Ad placement may interrupt scroll flow.
- Repeated manual color literals increase risk of theme inconsistencies.

## Actionable Recommendations
### 1. Refine Color Palette
- Introduce a **brand accent** (e.g., saffron `#FFB300`) for primary actions, selected chips, page‑indicator dots, and CTA buttons.
- Replace `secondaryIndigo` with a hue that harmonises with the accent (e.g., warm teal `#00BFA5`) or keep but ensure contrast > 4.5:1.
- Use gold (`#C5A059`) consistently for header/banner areas or replace with the new accent.
- Define explicit color tokens (e.g., `primaryText`, `secondaryText`, `backgroundLight`, `backgroundDark`, `cardSurface`, `accent`, `error`). Update `app_theme.dart` to reference them via `ColorScheme`.

### 2. Strengthen Contrast & Accessibility
- Run a WCAG contrast audit (e.g., `flutter_a11y` or manual script). Adjust `mutedGray` to a darker gray for light mode and a lighter gray for dark mode.
- Ensure all body text meets AA (≥ 4.5:1) and large text meets AA (≥ 3:1).
- Increase contrast for selected chips and buttons.

### 3. Typography Improvements
- Define a **TextTheme** in `ThemeData`:
  - `headlineSmall` (18 sp, w800) for screen titles.
  - `titleMedium` (16 sp, w600) for section headers.
  - `bodyMedium` (14 sp) for regular content.
  - `labelSmall` (12 sp, w600) for chips and small labels.
- Replace inline `TextStyle` instances with `Theme.of(context).textTheme.*` references.
- Remove negative letter‑spacing; use default or modest positive spacing.

### 4. Layout Adjustments
#### Navigation
- Switch from a **Drawer** to a **BottomNavigationBar** with primary destinations: Home, Map, Festivals, Planner, Favorites, Settings. Keep the drawer for secondary items (e.g., language selector, About).
- Provide adaptive layout: side navigation on tablets ≥ 600 dp.
#### Lists & Performance
- Convert temple lists in `HomeScreen` and `SearchScreen` to `ListView.builder` (or `SliverList` inside a `CustomScrollView`).
- Implement lazy loading/pagination for large datasets.
#### Category Chips
- Increase chip height to ≥ 48 dp; set `minimumSize` if needed.
- Use **accent** background for selected state and white text; otherwise use outlined style with `borderColor` from `colorScheme.outline`.
#### Carousel
- Set `PageController(initialPage: 0)`; remove large offset logic.
- Consider a dedicated carousel package (`carousel_slider`) for infinite looping.
- Add optional left/right navigation arrows for desktop.
#### Ad Banner
- Move `AdBannerWidget` into a **dismissible top banner** or a `BottomSheet` that can be swiped away.
- Add extra bottom padding to the scroll view when the ad is visible.
#### Spacing Consistency
- Adopt a spacing scale (8, 12, 16, 24) and apply via `EdgeInsets.symmetric(horizontal: 16, vertical: 12)` throughout.
- Increase vertical gaps between major sections (e.g., carousel → chips → list) to ≥ 24 dp.

### 5. Accessibility Enhancements
- Add `semanticLabel` to `CachedNetworkImage` (e.g., temple name).
- Wrap icons (`IconButton`, `FilterChip` leading icons) with `Semantics(label: 'Favorite', button: true)`.
- Ensure all tappable widgets meet the 48 dp hit‑box guideline.
- Provide haptic feedback on favorite toggles (`HapticFeedback.lightImpact()`).
- Optionally add a **high‑contrast mode** toggle.

### 6. Consistency & Theming
- Refactor all UI to use `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`.
- Centralise chip styling via `ChipThemeData` (already defined) and ensure selected colors use the new accent.
- Remove hard‑coded background colours in screens; rely on `scaffoldBackgroundColor`.

### 7. Validation & Testing
- Add widget tests for both light and dark themes (snapshot/golden tests).
- Run `flutter analyze` and fix any linter warnings.
- Conduct manual device testing on small (< 360 dp) and large (> 600 dp) screens.
- Perform an accessibility audit with TalkBack & VoiceOver; fix any issues.

## Implementation Path (for downstream agent)
1. **Update `app_theme.dart`** with new color tokens, `ColorScheme`, and `TextTheme`.
2. **Create a brand accent constant** and expose it through `colorScheme.secondary` or a custom field.
3. **Refactor UI files** (`home_screen.dart`, `search_screen.dart`, `temple_card.dart`, etc.) to use theme colors and text styles instead of hard‑coded values.
4. **Replace Drawer** with `BottomNavigationBar` in the root scaffold (e.g., in `main.dart` or a new `AppScaffold` widget).
5. **Convert temple lists** to `ListView.builder` with lazy loading.
6. **Adjust carousel logic** to start at page 0; optionally integrate a carousel package.
7. **Move ad banner** to a dismissible top banner or `BottomSheet` and adjust layout padding.
8. **Add accessibility attributes** (`semanticLabel`, `Semantics` widgets) to images and icons.
9. **Write widget and golden tests** for the new navigation and theme.
10. **Update documentation** (README or design guide) to reflect the new palette, typography, and navigation patterns.

## Risks & Mitigations
- **User familiarity**: Switching navigation may confuse existing users. Mitigate with a brief in‑app tour when the new navigation first appears.
- **Brand perception**: New accent color must align with cultural expectations; run a quick stakeholder review before finalizing.
- **Performance regression**: Verify list rendering times after moving to `ListView.builder`; keep profiling.
- **Ad revenue impact**: Ensure ad visibility remains comparable; track impressions after layout change.

## Open Questions
- **Accent color choice**: Should we adopt saffron (`#FFB300`) for cultural relevance, or a more neutral teal? (Recommendation: saffron.)
- **Navigation model on tablets**: Use bottom navigation on phones, side rail on tablets? (Recommendation: adaptive side navigation for devices ≥ 600 dp.)

---
*Prepared by Kilo – UI/UX analysis based on current Flutter codebase.*