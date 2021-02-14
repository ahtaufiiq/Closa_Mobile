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
    return "${FormatTime.formatDate(date, type: 'long')}";
  }

  static String formatTime(selectedTime) {
    int hour = selectedTime.hour;
    int minute = selectedTime.minute;

    if (hour < 12) {
      var hourAM = hour == 0 ? 12 : hour;
      if (minute == 0) {
        return '$hourAM AM';
      } else if (minute < 10) {
        return '$hourAM.0$minute AM';
      } else {
        return '$hourAM.$minute AM';
      }
    } else {
      var hourPM = hour == 12 ? hour : hour - 12;
      if (minute == 0) {
        return '$hourPM PM';
      } else if (minute < 10) {
        return '$hourPM.0$minute PM';
      } else {
        return '$hourPM.$minute PM';
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

  static int setToday(timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();

    DateTime format =
        DateTime(now.year, now.month, now.day, date.hour, date.minute);
    return format.millisecondsSinceEpoch;
  }

  static int setTomorrow(timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return date.add(Duration(days: 1)).millisecondsSinceEpoch;
  }

  static int getTimestampYesterday() {
    DateTime date = DateTime.now();
    DateTime tomorrow =
        DateTime(date.year, date.month, date.day).subtract(Duration(days: 1));

    return tomorrow.millisecondsSinceEpoch;
  }

  static int getTimestampTomorrow() {
    DateTime date = DateTime.now();
    DateTime tomorrow =
        DateTime(date.year, date.month, date.day).add(Duration(days: 1));

    return tomorrow.millisecondsSinceEpoch;
  }

  static String getTime(timestamp, {history = false}) {
    var selectedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var dateNow = DateTime.now();
    int hour = selectedTime.hour;
    int minute = selectedTime.minute;
    if (selectedTime.day == dateNow.day && history) {
      if (selectedTime.hour == dateNow.hour) {
        if (dateNow.minute == minute) {
          return "just now";
        } else {
          return "${dateNow.minute - minute} min";
        }
      } else {
        return "${dateNow.hour - hour}h";
      }
    } else {
      return getInfoTime(hour, minute);
    }
  }

  static String getInfoTime(hour, minute) {
    // print(minute);

    if (hour < 12) {
      var hourAM = hour == 0 ? 12 : hour;
      if (minute == 0) {
        return '$hourAM AM';
      } else if (minute < 10) {
        return '$hourAM.0$minute AM';
      } else {
        return '$hourAM.$minute AM';
      }
    } else {
      var hourPM = hour == 12 ? hour : hour - 12;
      if (minute == 0) {
        return '$hourPM PM';
      } else if (minute < 10) {
        return '$hourPM.0$minute PM';
      } else {
        return '$hourPM.$minute PM';
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

  static List getDate2(timestamp, {type = 'short'}) {
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
      return [listMonthShort[month], date];
    } else {
      return [listMonthLong[month], date];
    }
  }
}
