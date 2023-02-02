import 'package:scheduler/task.dart';

List<Task> sortTasks(List<Task> tasks) {
  return tasks..sort((a, b) => calcTime(a).compareTo(calcTime(b)));
}

Duration calcTime(Task task) {
  List<String> dates = task.date.split("/");
  List<String> times = task.time.split(":");

  DateTime datex = DateTime(int.parse(dates[2]), int.parse(dates[1]),
      int.parse(dates[0]), int.parse(times[0]), int.parse(times[1]));

  DateTime now = DateTime.now();
  Duration timeRemaining = datex.difference(now);

  if (timeRemaining.isNegative) {
    if (task.repeat) {
      DateTime temp =
          DateTime(now.year, now.month, now.day, datex.hour, datex.minute);
      timeRemaining = temp.difference(now);

      if (timeRemaining.isNegative) {
        timeRemaining = (temp.add(const Duration(days: 1))).difference(now);
      } else {
        timeRemaining = temp.difference(now);
      }
    } else {
      timeRemaining = Duration.zero;
    }
  }

  return timeRemaining;
}
