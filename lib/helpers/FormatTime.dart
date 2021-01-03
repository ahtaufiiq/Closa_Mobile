import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FormatTime {
  static String formatDate(selectedDate, {type = 'short'}) {
    String date = selectedDate.day.toString();
    int month = selectedDate.month;
    var listMonthShort = [
      '',
      'Jan',
      "Feb",
      'Mar',
      'Apr',
      "May",
      "Jun",
      "Jul",
      "Aug",
      'Sep',
      'Oct',
      "Nov",
      "Dec"
    ];
    var listMonthLong = [
      '',
      'January',
      "February",
      'March',
      'April',
      "May",
      "June",
      "July",
      "August",
      'September',
      'October',
      "November",
      "December"
    ];
    if (type == 'short') {
      return '$date ${listMonthShort[month]}';
    } else {
      return '$date ${listMonthLong[month]}';
    }
  }

  static int addTime(hour, minute) {
    return (hour * 60 * 60 * 1000) + (minute * 60 * 1000);
  }

  static String getToday() {
    DateTime date = DateTime.now();
    return "${FormatTime.formatDate(date, type: 'long')} ${date.year}";
  }

  static String formatTime(selectedTime) {
    int hour = selectedTime.hour;
    int minute = selectedTime.minute;

    if (hour < 12) {
      if (minute == 0) {
        return '$hour AM';
      } else if (minute < 10) {
        return '$hour.0$minute AM';
      } else {
        return '$hour.$minute AM';
      }
    } else {
      if (minute == 0) {
        return '${hour - 12} PM';
      } else if (minute < 10) {
        return '${hour - 12}.0$minute PM';
      } else {
        return '${hour - 12}.$minute PM';
      }
    }
  }

  static Time formatForTime(selectedTime) {
    int hour = selectedTime.hour;
    int minute = selectedTime.minute;

    return Time(hour, minute);
  }

  static int getTimestampToday() {
    DateTime date = DateTime.now();
    DateTime now = new DateTime(date.year, date.month, date.day);

    return now.millisecondsSinceEpoch;
  }

  static int getTimestampTomorrow() {
    DateTime date = DateTime.now();
    DateTime tomorrow =
        DateTime(date.year, date.month, date.day).add(Duration(days: 1));

    return tomorrow.millisecondsSinceEpoch;
  }

  static String getTime(timestamp) {
    var selectedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int hour = selectedTime.hour;
    int minute = selectedTime.minute;

    // print(minute);
    if (hour < 12) {
      if (minute == 0) {
        return '$hour AM';
      } else if (minute < 10) {
        return '$hour:0$minute AM';
      } else {
        return '$hour:$minute AM';
      }
    } else {
      if (minute == 0) {
        return '${hour - 12} PM';
      } else if (minute < 10) {
        return '${hour - 12}:0$minute PM';
      } else {
        return '${hour - 12}:$minute PM';
      }
    }
  }

  static String getDate(timestamp, {type = 'short'}) {
    var selectedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String date = selectedDate.day.toString();
    int month = selectedDate.month;
    var listMonthShort = [
      '',
      'Jan',
      "Feb",
      'Mar',
      'Apr',
      "May",
      "Jun",
      "Jul",
      "Aug",
      'Sep',
      'Oct',
      "Nov",
      "Dec"
    ];
    var listMonthLong = [
      '',
      'January',
      "February",
      'March',
      'April',
      "May",
      "June",
      "July",
      "August",
      'September',
      'October',
      "November",
      "December"
    ];
    if (type == 'short') {
      return '${listMonthShort[month]}\n$date';
    } else {
      return '${listMonthLong[month]}\n$date';
    }
  }
}
