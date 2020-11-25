import 'package:common_utils/common_utils.dart';

const String JUST_NOW = "刚刚";
const String MINITE_AGO = "分钟前";
const String HOUR_AGO = "小时前";
const String DAY_AGO = "天前";
const String THIS_YEAR_FORMAT = "MM/dd";
const String OVER_YEAR_FORMAT = "yyyy/MM/dd";

String timeUtils(DateTime date) {
  DateTime utcDate = DateTime.now();
  if (date.year != utcDate.year) {
    return DateUtil.formatDate(date, format: OVER_YEAR_FORMAT);
  }
  Duration duration = utcDate.difference(date);
  if (duration.inDays > 9) {
    return DateUtil.formatDate(date, format: THIS_YEAR_FORMAT);
  } else if (duration.inDays > 0) {
    return duration.inDays.toString() + DAY_AGO;
  } else if (duration.inHours > 0) {
    return duration.inHours.toString() + HOUR_AGO;
  } else if (duration.inMinutes > 0) {
    return duration.inMinutes.toString() + MINITE_AGO;
  } else {
    return JUST_NOW;
  }
}
