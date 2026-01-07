import 'package:intl/intl.dart';

DateTime stringToDate(String date) {
  DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  DateTime dateTime = dateFormat.parse(date).toLocal();
  return dateTime;
}

String stringToDateFormat(String date, String? format) {
  DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  DateTime dateTime = dateFormat.parse(date).toLocal();
  if (format != null) {
    DateFormat outputFormat = DateFormat(format);
    return outputFormat.format(dateTime);
  } else {
    return dateTime.toString();
  }
}

String dateToString(DateTime date) {
  List<String> weeks = ["Mon", "Tue", "Wen", "Thu", "Fri", "Sat", "Sun"];
  DateFormat dateFormat = DateFormat("MM/dd/yyyy");
  String fdate = dateFormat.format(date);
  String apm = (date.hour > 12) ? "PM" : "AM";
  int hour = (date.hour > 12) ? (date.hour - 12) : date.hour;
  String sHour = hour < 10 ? "0${hour}" : "${hour}";
  String sMinute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
  fdate = '${weeks[date.weekday - 1]}, ${fdate}, ${sHour} :${sMinute} ${apm}';
  return fdate;
}

String getActionName(String actionCode) {
  switch (actionCode) {
    case "P":
      return "Pickup";
    case "W-P":
      return "Warehouse-Pickup";
    case "D":
      return "Delivery";
    case "W-D":
      return "Warehouse-Drop";
    default:
      return actionCode;
  }
}

String formatUtcTime(
    {required String dateUtc, required format, String? newPattern}) {
  try {
    var dateTime = DateFormat(
      newPattern ?? "yyyy-MM-dd'T'HH:mm:ssZ",
    ).parseUtc(dateUtc);
    var dateLocal = dateTime.toLocal();

    return DateFormat(format).format(dateLocal);
  } catch (e) {
    return '-:--';
  }
}

String formatTime({required DateTime dateTime, required String newPattern}) {
  try {
    var result = DateFormat(
      newPattern,
    ).format(dateTime);
    return result;
  } catch (e) {
    return '-:--';
  }
}
