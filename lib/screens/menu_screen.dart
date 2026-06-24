import 'package:flutter/material.dart';
import 'package:myarrowsapp/l10n/app_localizations.dart';

import '../models/menu_item.dart';
import '../services/locale_service.dart';
import '../services/menu_service.dart';
import '../utils/l10n_helpers.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/language_picker.dart';
import 'arrow_calculator_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    super.key,
    required this.localeService,
    this.menuService,
  });

  final LocaleService localeService;
  final MenuService? menuService;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final MenuService _menuService;
  late Future<List<MenuItem>> _menuFuture;

  @override
  void initState() {
    super.initState();
    _menuService = widget.menuService ?? MenuService();
    _menuFuture = _menuService.fetchMenuItems();
  }

  Future<void> _reloadMenu() async {
    setState(() {
      _menuFuture = _menuService.fetchMenuItems();
    });
    await _menuFuture;
  }

  void _onMenuItemTap(MenuItem item) {
    switch (item.route) {
      case 'home':
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => HomeScreen(localeService: widget.localeService),
          ),
        );
      case 'settings':
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SettingsScreen(localeService: widget.localeService),
          ),
        );
      case 'arrows':
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const ArrowCalculatorScreen(),
          ),
        );
      case 'profile':
        break;
      default:
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.routeNotConfigured(item.route))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ScaffoldWithBannerAd(
      appBar: AppBar(
        title: Text(l10n.menu),
        actions: [
          IconButton(
            onPressed: () => showLanguagePicker(context, widget.localeService),
            tooltip: l10n.language,
            icon: const Icon(Icons.language),
          ),
          IconButton(
            onPressed: _reloadMenu,
            tooltip: l10n.reloadMenu,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.menuLoadError,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _reloadMenu,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = (snapshot.data ?? [])
              .where((item) => item.route != 'profile')
              .toList();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: items
                .map(
                  (item) => ListTile(
                    leading: Icon(_iconFromName(item.iconName)),
                    title: Text(l10n.menuTitle(item)),
                    subtitle: () {
                      final subtitle = l10n.menuSubtitle(item);
                      return subtitle != null ? Text(subtitle) : null;
                    }(),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _onMenuItemTap(item),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'home':
        return Icons.home_outlined;
      case 'person':
        return Icons.person_outline;
      case 'settings':
        return Icons.settings_outlined;
      case 'info':
        return Icons.info_outline;
      case 'straighten':
        return Icons.straighten;
      default:
        return Icons.menu;
    }
  }
}
