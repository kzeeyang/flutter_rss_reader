import 'package:common_utils/common_utils.dart';

String timeUtils(DateTime date) {
  DateTime utcDate = DateTime.now();
  if (!utcDate.isUtc) {
    utcDate = utcDate.subtract(utcDate.timeZoneOffset);
  }
  if (!date.isUtc) {
    if (date.timeZoneOffset.inHours > 0) {
      utcDate = utcDate.add(date.timeZoneOffset);
    } else {
      utcDate = utcDate.subtract(date.timeZoneOffset);
    }
  }

  if (date.year != utcDate.year) {
    return DateUtil.formatDate(date, format: "yyyy/MM/dd");
  }
  Duration duration = utcDate.difference(date);
  if (duration.inDays > 9) {
    return DateUtil.formatDate(date, format: "MM/dd");
  } else if (duration.inDays > 0) {
    return duration.inDays.toString() + "天前";
  } else if (duration.inHours > 0) {
    return duration.inHours.toString() + "小时前";
  } else if (duration.inMinutes > 0) {
    return duration.inMinutes.toString() + "分钟前";
  } else {
    return "刚刚";
  }
}
