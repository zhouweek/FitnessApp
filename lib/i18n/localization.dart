import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization)!;
  }

  late Map<String, String> _localizedStrings;

  Future<void> load() async {
    String langCode = locale.languageCode;
    if (!['en', 'zh'].contains(langCode)) {
      langCode = 'zh'; // 默认使用中文
    }
    final jsonString = await rootBundle.loadString('assets/i18n/$langCode.json');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static const LocalizationsDelegate<Localization> delegate = _LocalizationDelegate();
}

class _LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const _LocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) async {
    final localization = Localization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_LocalizationDelegate old) => false;
}
