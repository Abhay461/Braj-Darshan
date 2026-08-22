import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';

/// Daily Krishna Vani - Spiritual quote card
class DailyKrishnaVani extends ConsumerWidget {
  const DailyKrishnaVani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use day of year to pick a quote (deterministic, no API needed)
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final quote = _quotes[dayOfYear % _quotes.length];
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
child: Semantics(
        label: 'Daily Krishna Vani: ${quote.text}',
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      AppTheme.templeGoldDark.withValues(alpha: 0.15),
                      AppTheme.secondarySaffronDark.withValues(alpha: 0.08),
                    ]
                  : [
                      AppTheme.templeGold.withValues(alpha: 0.12),
                      AppTheme.secondarySaffron.withValues(alpha: 0.06),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            border: Border.all(
              color: isDark
                  ? AppTheme.templeGoldDark.withValues(alpha: 0.3)
                  : AppTheme.templeGold.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppTheme.templeGoldDark.withValues(alpha: 0.1)
                    : AppTheme.templeGold.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flute/Quote Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.templeGoldDark.withValues(alpha: 0.2)
                      : AppTheme.templeGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.format_quote_outlined,
                  color: isDark ? AppTheme.templeGoldDark : AppTheme.templeGold,
                  size: 22,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Quote Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Label
                    Text(
                      'Daily Krishna Vani',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppTheme.templeGoldDark : AppTheme.templeGold,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
// Quote Text
                    Text(
                      '"${quote.text}"',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Reference
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 12,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          quote.reference,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Peacock Feather Decoration
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.templeGoldDark.withValues(alpha: 0.1)
                      : AppTheme.templeGold.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.light_mode_outlined,
                  color: isDark ? AppTheme.templeGoldDark.withValues(alpha: 0.7) : AppTheme.templeGold.withValues(alpha: 0.7),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KrishnaQuote {
  final String text;
  final String reference;
  
  _KrishnaQuote({required this.text, required this.reference});
}

final List<_KrishnaQuote> _quotes = [
  _KrishnaQuote(
    text: 'Whatever you do, make it an offering to me — the food you eat, the sacrifices you make, the help you give, even your sufferings.',
    reference: 'Bhagavad Gita 9.27',
  ),
  _KrishnaQuote(
    text: 'The mind is restless and difficult to restrain, but it is subdued by practice and detachment.',
    reference: 'Bhagavad Gita 6.35',
  ),
  _KrishnaQuote(
    text: 'When a person responds to the joys and sorrows of others as if they were his own, he has attained the highest state of spiritual union.',
    reference: 'Bhagavad Gita 6.32',
  ),
  _KrishnaQuote(
    text: 'You have the right to work, but never to the fruit of work. You should never engage in action for the sake of reward, nor should you long for inaction.',
    reference: 'Bhagavad Gita 2.47',
  ),
  _KrishnaQuote(
    text: 'One who sees inaction in action, and action in inaction, is intelligent among men.',
    reference: 'Bhagavad Gita 4.18',
  ),
  _KrishnaQuote(
    text: 'The wise see with equal vision a learned and humble brahmana, a cow, an elephant, a dog, and a dog-eater.',
    reference: 'Bhagavad Gita 5.18',
  ),
  _KrishnaQuote(
    text: 'For one who has conquered the mind, the mind is the best of friends; but for one who has failed to do so, the mind remains the greatest enemy.',
    reference: 'Bhagavad Gita 6.6',
  ),
  _KrishnaQuote(
    text: 'A person who is not disturbed by the incessant flow of desires — that enter like rivers into the ocean, which is ever being filled but is always still — can alone achieve peace.',
    reference: 'Bhagavad Gita 2.70',
  ),
  _KrishnaQuote(
    text: 'The yogi is superior to the ascetic, superior to the empiricist, and superior to the fruitive worker. Therefore, O Arjuna, be a yogi.',
    reference: 'Bhagavad Gita 6.46',
  ),
  _KrishnaQuote(
    text: 'Surrender unto Me alone. I shall liberate you from all sins. Do not fear.',
    reference: 'Bhagavad Gita 18.66',
  ),
  _KrishnaQuote(
    text: 'There is neither this world, nor the world beyond, nor happiness for the one who doubts.',
    reference: 'Bhagavad Gita 4.40',
  ),
  _KrishnaQuote(
    text: 'One who performs duty without attachment, surrendering the results unto the Supreme Lord, is unaffected by sinful action, as the lotus leaf is untouched by water.',
    reference: 'Bhagavad Gita 5.10',
  ),
  _KrishnaQuote(
    text: 'Fix your mind on Me, be devoted to Me, worship Me, and bow down to Me. You will surely come to Me.',
    reference: 'Bhagavad Gita 9.34',
  ),
  _KrishnaQuote(
    text: 'The Supreme Lord is situated in everyone\'s heart, O Arjuna, and is directing the wanderings of all living entities.',
    reference: 'Bhagavad Gita 18.61',
  ),
  _KrishnaQuote(
    text: 'One who is equal to friends and enemies, who is equipoised in honor and dishonor, heat and cold, happiness and distress, is dear to Me.',
    reference: 'Bhagavad Gita 12.18-19',
  ),
  _KrishnaQuote(
    text: 'By devotion he knows Me in truth, what I am. Then having known Me in truth, he forthwith enters into the Supreme.',
    reference: 'Bhagavad Gita 18.55',
  ),
  _KrishnaQuote(
    text: 'The happiness which appears like poison at first, but tastes like nectar in the end — that happiness is said to be in the mode of goodness.',
    reference: 'Bhagavad Gita 18.37',
  ),
  _KrishnaQuote(
    text: 'He who sees Me everywhere, and sees everything in Me, is never lost to Me, nor am I ever lost to him.',
    reference: 'Bhagavad Gita 6.30',
  ),
  _KrishnaQuote(
    text: 'A gift is pure when it is given from the heart to the right person at the right time and place, and when we expect nothing in return.',
    reference: 'Bhagavad Gita 17.20',
  ),
  _KrishnaQuote(
    text: 'One who is not envious but is a kind friend to all living entities, who does not think himself a proprietor and is free from false ego, is dear to Me.',
    reference: 'Bhagavad Gita 12.13-14',
  ),
];
