bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((day) {
    return day.day == today.day &&
        day.month == today.month &&
        day.year == today.year;
  });
}
