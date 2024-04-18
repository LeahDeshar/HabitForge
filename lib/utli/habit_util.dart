import 'package:habittracker/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((day) {
    return day.day == today.day &&
        day.month == today.month &&
        day.year == today.year;
  });
}

Map<DateTime, int> prepareHeatMapData(List<Habit> habits) {
  Map<DateTime, int> datasets = {};
  for (var habit in habits) {
    //normalize date to avoid time zone issues
    for (var date in habit.completedDays) {
      final normalizeDate = DateTime(date.year, date.month, date.day);
      //if the date is already in the map, increment the value
      if (datasets.containsKey(normalizeDate)) {
        datasets[normalizeDate] = datasets[normalizeDate]! + 1;
      } else {
        //if the date is not in the map, add it with a value of 1
        datasets[normalizeDate] = 1;
      }
    }
  }
  return datasets;
}
