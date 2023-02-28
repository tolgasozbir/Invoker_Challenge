String get getFormattedDate {
  DateTime now = DateTime.now();
  String convertedDateTime = 
  "${now.year}/"
  +"${now.month.toString().padLeft(2,'0')}/"
  +"${now.day.toString().padLeft(2,'0')} "
  +"${now.hour.toString().padLeft(2,'0')}:"
  +"${now.minute.toString().padLeft(2,'0')}";

  return convertedDateTime;
}