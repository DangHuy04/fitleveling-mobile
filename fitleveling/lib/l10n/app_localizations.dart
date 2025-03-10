import 'dart:async';
import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<void> load() async {
    switch (locale.languageCode) {
      case 'vi':
        _localizedStrings = appLocalizationsVi;
        break;
      case 'en':
      default:
        _localizedStrings = appLocalizationsEn;
        break;
    }
  }

  String get login => _localizedStrings['login'] ?? 'Login';
  String get signUp => _localizedStrings['signUp'] ?? 'Sign Up';
  String get email => _localizedStrings['email'] ?? 'Email';
  String get password => _localizedStrings['password'] ?? 'Password';
  String get dontHaveAccount =>
      _localizedStrings['dontHaveAccount'] ?? "Don't have an account? Sign up";

  // Thêm các thông báo lỗi
  String get emptyFields => _localizedStrings['empty_fields'] ?? 'Fields cannot be empty';
  String get invalidEmail => _localizedStrings['invalid_email'] ?? 'Invalid email format';
  String get shortPassword => _localizedStrings['short_password'] ?? 'Password must be at least 8 characters';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
