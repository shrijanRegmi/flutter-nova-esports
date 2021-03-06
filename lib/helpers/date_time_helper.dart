import 'package:flutter/material.dart';

class DateTimeHelper {
  // format date
  String getFormattedDate(final DateTime dateTime) {
    final _result =
        '${_getMonth(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    return _result;
  }

  // format time
  String getFormattedTime(final TimeOfDay timeOfDay) {
    return '${timeOfDay.hour > 12 ? (timeOfDay.hour - 12).toString().length == 1 ? '0' + (timeOfDay.hour - 12).toString() : timeOfDay.hour - 12 : timeOfDay.hour} : ${timeOfDay.minute.toString().length == 1 ? '0' + timeOfDay.minute.toString() : timeOfDay.minute} ${timeOfDay.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
        break;
      case 2:
        return 'February';
        break;
      case 3:
        return 'March';
        break;
      case 4:
        return 'April';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'June';
        break;
      case 7:
        return 'July';
        break;
      case 8:
        return 'August';
        break;
      case 9:
        return 'September';
        break;
      case 10:
        return 'October';
        break;
      case 11:
        return 'November';
        break;
      case 12:
        return 'December';
        break;
      default:
        return 'January';
    }
  }
}
