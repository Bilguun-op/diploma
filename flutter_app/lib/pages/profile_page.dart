import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/i18n_provider.dart';
import '../app/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();
    final store = context.watch<StoreProvider>();

    final completedLevels = store.user.levelStatuses.where((s) => s == LevelStatus.completed).length;
    final currentLevel = (completedLevels + 1).clamp(1, 5);
    final unitsDone = store.user.unitsCompleted.expand((row) => row).where((n) => n >= 3).length;
    final totalUnits = 25;
    final progressPct = (unitsDone / totalUnits * 100).clamp(0, 100).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            i18n.t('personalAccount'),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          // Main grid
          Row(
            children: [
              // Profile card
              Expanded(
                flex: 2,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: AppTheme._border.withOpacity(0.6)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: AppTheme.heroGradient.copyWith(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  store.user.name.isNotEmpty ? store.user.name[0].toUpperCase() : '?',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        color: AppTheme._primaryForeground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i18n.t('name'),
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          letterSpacing: 1.5,
                                          color: AppTheme._mutedForeground,
                                        ),
                                  ),
                                  Text(
                                    store.user.name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    '${i18n.t('grade')}: ${store.user.grade}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme._mutedForeground,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Progress
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${i18n.t('progress')} · ${i18n.t('level')} $currentLevel',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme._mutedForeground,
                                  ),
                            ),
                            Text(
                              '$progressPct%',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progressPct / 100,
                            backgroundColor: AppTheme._muted,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme._primary),
                            minHeight: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$unitsDone/$totalUnits ${i18n.t('unit')}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme._mutedForeground,
                              ),
                        ),
                        const SizedBox(height: 24),
                        // Language selector
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              i18n.t('language'),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    letterSpacing: 1.5,
                                    color: AppTheme._mutedForeground,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme._input,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme._border.withOpacity(0.6)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: i18n.lang,
                                  isExpanded: true,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  dropdownColor: AppTheme._card,
                                  items: const [
                                    DropdownMenuItem(value: 'en', child: Text('English')),
                                    DropdownMenuItem(value: 'mn', child: Text('Монгол')),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      context.read<I18nProvider>().setLang(value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // EXP card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: AppTheme.amberGradient.copyWith(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme._amber.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.emoji_events, size: 32, color: AppTheme._amberForeground),
                      const SizedBox(height: 12),
                      Text(
                        i18n.t('expRoom'),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.5,
                              color: AppTheme._amberForeground.withOpacity(0.8),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${store.user.exp}',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppTheme._amberForeground,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        i18n.t('totalExp'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme._amberForeground.withOpacity(0.9),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Levels grid
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: AppTheme._border.withOpacity(0.6)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    i18n.t('levels'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(5, (index) {
                      final status = store.user.levelStatuses[index];
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 32 - 48) / 5,
                        child: Card(
                          color: status == LevelStatus.completed
                              ? AppTheme._emerald.withOpacity(0.1)
                              : status == LevelStatus.unlocked
                                  ? AppTheme._primary.withOpacity(0.1)
                                  : AppTheme._muted.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: status == LevelStatus.completed
                                  ? AppTheme._emerald.withOpacity(0.6)
                                  : status == LevelStatus.unlocked
                                      ? AppTheme._primary.withOpacity(0.6)
                                      : AppTheme._border.withOpacity(0.4),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Icon(Icons.auto_awesome, size: 20),
                                const SizedBox(height: 8),
                                Text(
                                  '${i18n.t('level')} ${index + 1}',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  status == LevelStatus.completed
                                      ? i18n.t('completed')
                                      : status == LevelStatus.unlocked
                                          ? i18n.t('unlocked')
                                          : i18n.t('locked'),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        letterSpacing: 1.5,
                                        color: AppTheme._mutedForeground,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
