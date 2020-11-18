import 'package:common_utils/common_utils.dart';

String timeUtils(DateTime date) {
  if (date.year != DateTime.now().year) {
    return DateUtil.formatDate(date, format: "yyyy/MM/dd");
  }
  Duration duration = DateTime.now().difference(date);
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
