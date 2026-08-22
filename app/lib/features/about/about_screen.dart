import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/localization/app_translations.dart';
import '../../shared/providers/providers.dart';
import '../../../../core/theme/app_theme.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(appLanguageProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = AppTheme.primarySaffron;
    final goldColor = AppTheme.templeGold;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentLang == 'hi' ? 'ऐप के बारे में' : 'About Braj Darshan',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // Branding Header Banner
            // -----------------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF2C2411), const Color(0xFF1E180A)]
                      : [const Color(0xFFFFF7E6), const Color(0xFFFDE8B5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: goldColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? const Color(0x30000000) : const Color(0x0A000000),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: goldColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.temple_hindu_outlined,
                      size: 40,
                      color: goldColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Braj Darshan',
                    style: GoogleFonts.rozhaOne(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentLang == 'hi'
                        ? 'श्री ब्रज धाम आध्यात्मिक मार्गदर्शिका'
                        : 'Spiritual Guide for Vrindavan & Sacred Braj Dham',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'Version 2.0.0',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // Section 1: About Braj Darshan
            // -----------------------------------------------------------------
            _buildSectionCard(
              context: context,
              icon: Icons.auto_awesome_outlined,
              title: currentLang == 'hi' ? '1. ब्रज दर्शन के बारे में' : '1. About Braj Darshan',
              content: currentLang == 'hi'
                  ? 'ब्रज दर्शन एक समर्पित डिजिटल मार्गदर्शिका है जो भक्तों और तीर्थयात्रियों को पवित्र ब्रज धाम — वृंदावन, मथुरा, गोवर्धन, गोकुल, बरसाना और नंदगांव के पूज्य मंदिरों और धार्मिक स्थलों के दर्शन कराने में मदद करती है।'
                  : 'Braj Darshan is a dedicated digital companion crafted for devotees and travelers exploring the sacred land of Braj Dham — including Vrindavan, Mathura, Govardhan, Gokul, Barsana, and Nandgaon. It provides authentic insights into revered temples, holy ghats, and spiritual heritage sites.',
            ),

            const SizedBox(height: 16),

            // -----------------------------------------------------------------
            // Section 2: Our Purpose
            // -----------------------------------------------------------------
            _buildSectionCard(
              context: context,
              icon: Icons.center_focus_strong_outlined,
              title: currentLang == 'hi' ? '2. हमारा उद्देश्य' : '2. Our Purpose',
              content: currentLang == 'hi'
                  ? 'हमारा उद्देश्य पवित्र मंदिरों की सही जानकारी, दर्शन का समय और सांस्कृतिक महत्व को सरल रूप में प्रस्तुत करना है, ताकि प्रत्येक भक्त अपनी यात्रा को सुगम और भक्तिमय बना सके।'
                  : 'Our purpose is to share accurate temple information, Darshan schedules, and spiritual heritage with clarity and reverence. We aim to help pilgrims plan meaningful Yatras with ease and devotion.',
            ),

            const SizedBox(height: 16),

            // -----------------------------------------------------------------
            // Section 3: What You Can Explore
            // -----------------------------------------------------------------
            _buildFeatureSection(
              context: context,
              title: currentLang == 'hi' ? '3. आप क्या देख सकते हैं' : '3. What You Can Explore',
              features: [
                _FeatureItem(
                  icon: Icons.temple_hindu_outlined,
                  title: currentLang == 'hi' ? 'मंदिर विवरण एवं इतिहास' : 'Temple Info & Heritage',
                  desc: currentLang == 'hi'
                      ? 'प्रत्येक मंदिर की वास्तुकला, इतिहास और धार्मिक कथाएँ।'
                      : 'Detailed sacred history, architecture, and significance.',
                ),
                _FeatureItem(
                  icon: Icons.access_time_outlined,
                  title: currentLang == 'hi' ? 'दर्शन एवं आरती समय' : 'Darshan & Aarti Timings',
                  desc: currentLang == 'hi'
                      ? 'सुबह, दोपहर और संध्या दर्शन एवं आरती का सटीक समय।'
                      : 'Timely morning, afternoon, and evening Darshan hours.',
                ),
                _FeatureItem(
                  icon: Icons.map_outlined,
                  title: currentLang == 'hi' ? 'मानचित्र एवं दूरी' : 'Interactive Map & Location',
                  desc: currentLang == 'hi'
                      ? 'मानचित्र पर मंदिर स्थिति और सीधे भौगोलिक दूरी का सटीक अनुमान।'
                      : 'Pinpoint temple coordinates and straight-line distances.',
                ),
                _FeatureItem(
                  icon: Icons.event_outlined,
                  title: currentLang == 'hi' ? 'ब्रज त्यौहार एवं उत्सव' : 'Festivals & Utsavs',
                  desc: currentLang == 'hi'
                      ? 'जन्माष्टमी, राधाष्टमी और होली जैसे प्रमुख ब्रज उत्सवों की सूची।'
                      : 'Stay informed about Janmashtami, Radhashtami, and Holi Utsavs.',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // -----------------------------------------------------------------
            // Section 4: Yatra & Darshan
            // -----------------------------------------------------------------
            _buildFeatureSection(
              context: context,
              title: currentLang == 'hi' ? '4. यात्रा एवं दर्शन सुविधाएँ' : '4. Yatra & Darshan Features',
              features: [
                _FeatureItem(
                  icon: Icons.event_note_outlined,
                  title: currentLang == 'hi' ? 'मेरी यात्रा योजनाकार (Planner)' : 'My Yatra Planner',
                  desc: currentLang == 'hi'
                      ? 'अपनी व्यक्तिगत तीर्थयात्रा की योजना बनाएं और पूर्णता ट्रैक करें।'
                      : 'Organize custom pilgrimage itineraries with task completion tracking.',
                ),
                _FeatureItem(
                  icon: Icons.favorite_border,
                  title: currentLang == 'hi' ? 'सहेजे गए पसंदीदा मंदिर' : 'Saved Favorites',
                  desc: currentLang == 'hi'
                      ? 'अपने प्रिय मंदिरों को आसानी से सहेजें और तुरंत पहुंचें।'
                      : 'Bookmark your favorite mandirs for instant access anytime.',
                ),
                _FeatureItem(
                  icon: Icons.search_outlined,
                  title: currentLang == 'hi' ? 'त्वरित खोज एवं फ़िल्टर' : 'Search & Filter',
                  desc: currentLang == 'hi'
                      ? 'क्षेत्र, नाम या श्रेणी के आधार पर मंदिर तुरंत खोजें।'
                      : 'Effortlessly find temples by location, category, or name.',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // -----------------------------------------------------------------
            // Section 5: Version & App Info
            // -----------------------------------------------------------------
            _buildSectionCard(
              context: context,
              icon: Icons.info_outline,
              title: currentLang == 'hi' ? '5. संस्करण जानकारी' : '5. Version Info',
              content: currentLang == 'hi'
                  ? 'Braj Darshan v2.0.0\nयह ऐप ब्रज यात्रियों और सनातन धर्म के प्रेमियों के लिए एक नि:शुल्क आध्यात्मिक संदर्भ मार्गदर्शिका है।'
                  : 'Braj Darshan v2.0.0\nThis app is a non-commercial spiritual reference guide designed for pilgrims and lovers of Braj Dham.',
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x20000000) : const Color(0x05000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: AppTheme.primarySaffron),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.45,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection({
    required BuildContext context,
    required String title,
    required List<_FeatureItem> features,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x20000000) : const Color(0x05000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...features.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primarySaffron.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 18, color: AppTheme.primarySaffron),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.desc,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String desc;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.desc,
  });
}
