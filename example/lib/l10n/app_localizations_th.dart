// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'ตัวอย่าง Screen Security';

  @override
  String get statusOff => 'การป้องกันหน้าจอ: ปิดอยู่';

  @override
  String get statusOn => 'การป้องกันหน้าจอ: เปิดอยู่';

  @override
  String statusError(String error) {
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String get enableSecurity => 'เปิดการป้องกัน';

  @override
  String get disableSecurity => 'ปิดการป้องกัน';

  @override
  String get keyboardTestTitle => 'ทดสอบ Keyboard & SafeArea';

  @override
  String get typeHereLabel => 'พิมพ์ที่นี่เพื่อทดสอบ keyboard insets';

  @override
  String get typeHereHint => 'คีย์บอร์ดควรทำงานได้ตามปกติ...';

  @override
  String get anotherFieldLabel => 'ช่องข้อความอีกอัน';

  @override
  String get anotherFieldHint => 'ทดสอบการใส่ข้อมูลหลายช่อง...';

  @override
  String get screenshotHint =>
      'ลองถ่ายภาพหน้าจอหรือบันทึกหน้าจอ\nขณะที่การป้องกันเปิดอยู่';
}
