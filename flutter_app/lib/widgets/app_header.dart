import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/i18n_provider.dart';
import '../providers/store_provider.dart';
import '../app/theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();
    final store = context.watch<StoreProvider>();

    final navItems = [
      {'to': '/', 'label': i18n.t('home'), 'icon': Icons.home},
      {'to': '/grammar', 'label': i18n.t('grammar'), 'icon': Icons.menu_book},
      {'to': '/arcade', 'label': i18n.t('arcade'), 'icon': Icons.games},
      {'to': '/profile', 'label': i18n.t('account'), 'icon': Icons.person},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: AppTheme._border.withOpacity(0.6),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => store.setRoute('/'),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: AppTheme.heroGradient.copyWith(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: AppTheme.glowShadow,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppTheme._primaryForeground,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          i18n.t('appName'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (store.user.loggedIn)
                    Row(
                      children: [
                        _buildLangSwitch(context, i18n),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.logout, size: 20),
                          onPressed: () {
                            store.logout();
                            store.setRoute('/login');
                          },
                          tooltip: i18n.t('logout'),
                        ),
                      ],
                    ),
                ],
              ),
              if (store.user.loggedIn && MediaQuery.of(context).size.width < 768)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: navItems.map((item) {
                      final isActive = store.currentRoute == item['to'];
                      return Expanded(
                        child: InkWell(
                          onTap: () => store.setRoute(item['to'] as String),
                          child: Column(
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                size: 16,
                                color: isActive
                                    ? AppTheme._primary
                                    : AppTheme._mutedForeground,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['label'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isActive
                                      ? AppTheme._primary
                                      : AppTheme._mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangSwitch(BuildContext context, I18nProvider i18n) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme._muted.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme._border.withOpacity(0.6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.language, size: 12, color: AppTheme._mutedForeground),
          const SizedBox(width: 4),
          _buildLangButton(context, 'EN', i18n.lang == 'en', () => i18n.setLang('en')),
          _buildLangButton(context, 'МН', i18n.lang == 'mn', () => i18n.setLang('mn')),
        ],
      ),
    );
  }

  Widget _buildLangButton(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppTheme._primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? AppTheme._primaryForeground : AppTheme._mutedForeground,
          ),
        ),
      ),
    );
  }
}
