import 'package:intl/intl.dart';

class DateFormatHelper {
  static final _dateYear = DateFormat.y();
  static final _dateFull = DateFormat.yMMMMd();
  static final _dateFullShort = DateFormat.yMMMd();

  static String yearOnly(String? date) {
    if (date == null || date.isEmpty) {
      return "No date";
    }

    try {
      return _dateYear.format(DateTime.parse(date));
    } catch (e) {
      return "No date";
    }
  }

  static String fullDate(String? date) {
    if (date == null || date.isEmpty) {
      return "No date";
    }

    try {
      return _dateFull.format(DateTime.parse(date));
    } catch (e) {
      return "No date";
    }
  }

  static String fullShortDate(String? date) {
    if (date == null || date.isEmpty) {
      return "No date";
    }

    try {
      return _dateFullShort.format(DateTime.parse(date));
    } catch (e) {
      return "No date";
    }
  }
}