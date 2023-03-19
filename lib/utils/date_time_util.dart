extension AdaptiveDuration on Duration {
  String get adaptiveString {
    if (inDays >= 1) {
      return "$inDays days";
    }
    if (inHours >= 1) {
      return "$inHours hours";
    }
    return "$inMinutes minutes";
  }
}

extension TimeUtil on DateTime {
  String get toDueTimeString {
    final diff = difference(DateTime.now());
    if (diff.isNegative) {
      return "Passed ${(-diff).adaptiveString}";
    }
    return "Remaining ${diff.adaptiveString}";
  }

  String get humanizedPromisingDate {
    final now = DateTime.now();
    final diff = difference(DateTime(now.year, now.month, now.day));
    if (diff.inDays == 0) {
      return "Today";
    }
    if (diff.inDays == 1) {
      return "Tomorrow";
    }

    weekdayToText(int weekday) {
      switch (weekday) {
        case DateTime.monday:
          return "Monday";
        case DateTime.tuesday:
          return "Tuesday";
        case DateTime.wednesday:
          return "Wednesday";
        case DateTime.thursday:
          return "Thursday";
        case DateTime.friday:
          return "Friday";
        case DateTime.saturday:
          return "Saturday";
        case DateTime.sunday:
          return "Sunday";
      }
    }

    if (diff.inDays < 7) {
      return "${weekdayToText(weekday)}";
    }
    if (diff.inDays < 14) {
      return "Next ${weekdayToText(weekday)}";
    }
    return "$month.$day";
  }
}
