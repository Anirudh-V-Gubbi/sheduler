List sortTasks(List tasks)
{
  return tasks..sort(
    (a, b) {
      List a_dates = a['date'].toString().split("/");
      List a_times = a['time'].toString().split(":");
      List b_dates = b['date'].toString().split("/");
      List b_times = b['time'].toString().split(":");

      DateTime a_date = DateTime(int.parse(a_dates[2]), int.parse(a_dates[1]), int.parse(a_dates[0]),
          int.parse(a_times[0]), int.parse(a_times[1])
      );
      DateTime b_date = DateTime(int.parse(b_dates[2]), int.parse(b_dates[1]), int.parse(b_dates[0]),
          int.parse(b_times[0]), int.parse(b_times[1])
      );

      if(a['repeat'] == false && b['repeat'] == false) {
        return a_date.compareTo(b_date);
      }
      else if(a['repeat'] == true && b['repeat'] == false) {
        DateTime now = DateTime.now();
        if(now.isAfter(a_date)) {
          DateTime temp = DateTime(now.year, now.month, now.day + 1, a_date.hour, a_date.minute);

          return temp.compareTo(b_date);
        }
        else {
          return a_date.compareTo(b_date);
        }
        
      }
      else if(a['repeat'] == false && b['repeat'] == true) {
        DateTime now = DateTime.now();
        if(now.isAfter(b_date)) {
          DateTime temp = DateTime(now.year, now.month, now.day + 1, b_date.hour, b_date.minute);

          return a_date.compareTo(temp);
        }
        else {
          return a_date.compareTo(b_date);
        }
      }
      else {
        DateTime now = DateTime.now();
        if(now.isAfter(a_date) && !now.isAfter(b_date)) {
          DateTime temp = DateTime(now.year, now.month, now.day + 1, a_date.hour, a_date.minute);

          return temp.compareTo(b_date);
        }
        else if(!now.isAfter(a_date) && now.isAfter(b_date)) {
          DateTime temp = DateTime(now.year, now.month, now.day + 1, b_date.hour, b_date.minute);

          return a_date.compareTo(temp);
        }
        else if(now.isAfter(a_date) && now.isAfter(b_date)) {
          DateTime atemp = DateTime(now.year, now.month, now.day + 1, a_date.hour, a_date.minute);
          DateTime btemp = DateTime(now.year, now.month, now.day + 1, b_date.hour, b_date.minute);

          return atemp.compareTo(btemp);
        }
        else {
          return a_date.compareTo(b_date);
        }
      }
    }
  );
}