import 'package:flutter/material.dart';
import 'package:myarrowsapp/l10n/app_localizations.dart';

import '../services/locale_service.dart';

Future<void> showLanguagePicker(
  BuildContext context,
  LocaleService localeService,
) {
  final l10n = AppLocalizations.of(context);

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return ListenableBuilder(
        listenable: localeService,
        builder: (context, _) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                RadioListTile<Locale?>(
                  title: Text(l10n.languageSystem),
                  value: null,
                  groupValue: localeService.locale,
                  onChanged: (value) {
                    localeService.setLocale(value);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<Locale?>(
                  title: Text(l10n.languageSpanish),
                  value: AppLocales.spanish,
                  groupValue: localeService.locale,
                  onChanged: (value) {
                    localeService.setLocale(value);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<Locale?>(
                  title: Text(l10n.languageEnglish),
                  value: AppLocales.english,
                  groupValue: localeService.locale,
                  onChanged: (value) {
                    localeService.setLocale(value);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    },
  );
}
