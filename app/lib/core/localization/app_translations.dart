class AppTranslations {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Braj Darshan',
      'app_subtitle': 'Spiritual Guide v2.0',
      'all_temples': 'All Temples',
      'featured_temples': 'Featured Temples',
      'interactive_map': 'Interactive Map',
      'nearby_hotels': 'Nearby Hotels',
      'saved_favorites': 'Saved Favorites',
      'festivals_utsavs': 'Festivals & Utsavs',
      'my_yatra_plan': 'My Yatra Plan',
      'language': 'Language',
      'about_app': 'About App',
      'search_shrines': 'Search Shrines',
      'darshan_timing': 'Darshan Timing',
      'history': 'History & Legend',
      'plan_yatra': '+ Plan Yatra',
      'directions': 'Directions',
      'view_details': 'View Details',
      'upcoming_yatra': 'Upcoming Yatra',
      'history_tab': 'History',
      'no_temples_found': 'No temples found',
      'select_language': 'Select Language',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
    },
    'hi': {
      'app_title': 'ब्रज दर्शन',
      'app_subtitle': 'आध्यात्मिक मार्गदर्शिका v2.0',
      'all_temples': 'सभी मंदिर',
      'featured_temples': 'प्रमुख मंदिर',
      'interactive_map': 'इंटेरेक्टिव मानचित्र',
      'nearby_hotels': 'पास के होटल',
      'saved_favorites': 'सहेजे गए मंदिर',
      'festivals_utsavs': 'त्यौहार एवं उत्सव',
      'my_yatra_plan': 'मेरी यात्रा योजना',
      'language': 'भाषा (Language)',
      'about_app': 'ऐप के बारे में',
      'search_shrines': 'मंदिर खोजें',
      'darshan_timing': 'दर्शन का समय',
      'history': 'इतिहास एवं कथा',
      'plan_yatra': '+ यात्रा जोड़ें',
      'directions': 'दिशा-निर्देश (Maps)',
      'view_details': 'विवरण देखें',
      'upcoming_yatra': 'आगामी यात्राएं',
      'history_tab': 'इतिहास (History)',
      'no_temples_found': 'कोई मंदिर नहीं मिला',
      'select_language': 'भाषा चुनें',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
    },
  };

  static String getText(String langCode, String key) {
    final map = _localizedValues[langCode] ?? _localizedValues['en']!;
    return map[key] ?? key;
  }
}
