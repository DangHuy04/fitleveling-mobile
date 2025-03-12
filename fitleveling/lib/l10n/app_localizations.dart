import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

class AppLocalizations {
  final Locale locale;
  late final Map<String, String> _localizedStrings;

  AppLocalizations(this.locale) {
    _localizedStrings = _loadLocalizedStrings(locale.languageCode);
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _loadLocalizedStrings(String languageCode) {
    switch (languageCode) {
      case 'vi':
        return appLocalizationsVi;
      case 'en':
      default:
        return appLocalizationsEn;
    }
  }

  String get login => _localizedStrings['login'] ?? 'Login';
  String get signUp => _localizedStrings['signUp'] ?? 'Sign Up';
  String get email => _localizedStrings['email'] ?? 'Email';
  String get password => _localizedStrings['password'] ?? 'Password';
  String get dontHaveAccount =>
      _localizedStrings['dontHaveAccount'] ?? "Don't have an account? ";

  // Thêm các thông báo lỗi
  String get emptyFields => _localizedStrings['emptyFields'] ?? 'Fields cannot be empty';
  String get invalidEmail => _localizedStrings['invalidEmail'] ?? 'Invalid email format';
  String get shortPassword => _localizedStrings['shortPassword'] ?? 'Password must be at least 8 characters';

  // Các thông báo bổ sung
  String get forgotPassword =>
      _localizedStrings['forgotPassword'] ?? 'Forgot password?';
  String get orLoginWith => _localizedStrings['orLoginWith'] ?? 'Or login with';
  String get signUpNow => _localizedStrings['signUpNow'] ?? 'Sign up now';
  String get passwordMismatch =>
      _localizedStrings['passwordMismatch'] ?? 'Passwords do not match';
  String get termsRequired =>
      _localizedStrings['termsRequired'] ??
      'Please agree to the Terms of Service';
  String get registerSuccess =>
      _localizedStrings['registerSuccess'] ??
      'Registration successful! Please login.';
  String get registerFailed =>
      _localizedStrings['registerFailed'] ?? 'Registration failed';
  String get createNewAccount =>
      _localizedStrings['createNewAccount'] ?? 'Create a new account';
  String get fullName => _localizedStrings['fullName'] ?? 'Full name';
  String get confirmPassword =>
      _localizedStrings['confirmPassword'] ?? 'Confirm password';
  String get termsAgree => _localizedStrings['termsAgree'] ?? 'I agree to the ';
  String get termsOfService =>
      _localizedStrings['termsOfService'] ?? 'Terms of Service';
  String get register => _localizedStrings['register'] ?? 'Register';
  String get alreadyHaveAccount =>
      _localizedStrings['alreadyHaveAccount'] ?? 'Already have an account? ';
  String get loginNow => _localizedStrings['loginNow'] ?? 'Login now';
  String get error => _localizedStrings['error'] ?? 'Error !';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
