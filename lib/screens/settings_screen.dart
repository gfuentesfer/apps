import 'package:flutter/material.dart';
import 'package:myarrowsapp/l10n/app_localizations.dart';

import '../services/locale_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/language_picker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.localeService});

  final LocaleService localeService;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ScaffoldWithBannerAd(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(l10n.settingsLanguageSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLanguagePicker(context, localeService),
          ),
        ],
      ),
    );
  }
}
