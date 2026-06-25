import 'package:flutter/material.dart';
import 'package:myarrowsapp/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_links.dart';
import '../services/locale_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/language_picker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.localeService});

  final LocaleService localeService;

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(AppLinks.privacyPolicyUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $uri');
    }
  }

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
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            subtitle: Text(l10n.privacyPolicySubtitle),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              try {
                await _openPrivacyPolicy();
              } catch (_) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.retry)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
