// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Screen Security Example';

  @override
  String get statusOff => 'Screen security is OFF';

  @override
  String get statusOn => 'Screen security is ON';

  @override
  String statusError(String error) {
    return 'Error: $error';
  }

  @override
  String get enableSecurity => 'Enable Security';

  @override
  String get disableSecurity => 'Disable Security';

  @override
  String get keyboardTestTitle => 'Keyboard & SafeArea Test';

  @override
  String get typeHereLabel => 'Type here to test keyboard insets';

  @override
  String get typeHereHint => 'Keyboard should work normally...';

  @override
  String get anotherFieldLabel => 'Another text field';

  @override
  String get anotherFieldHint => 'Test multiple inputs...';

  @override
  String get screenshotHint =>
      'Try taking a screenshot or screen recording\nwhile security is enabled.';
}
