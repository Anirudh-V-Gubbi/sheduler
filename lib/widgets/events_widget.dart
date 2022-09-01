import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scheduler/screens/edit_screen.dart';

List tasklist = [];

class EventList extends StatefulWidget {
  EventList({Key? key, required this.listoftask}) : super(key: key) {
    tasklist = listoftask;
  }
  final listoftask;

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  void refreshList({List? newlist}) async{
    var box = await Hive.openBox('task');
    await box.put('tasks', newlist ?? tasklist);

    setState(() {

    });
  }

  void editlist(int i)
  {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return editscreen(tasklist: tasklist, task: tasklist[i], i: i, refreshlist: refreshList);
        }

        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasklist.length,
        itemBuilder:  (context, i) => EventCard(
            title: tasklist[i]['title'],
            date: tasklist[i]['date'],
            time: tasklist[i]['time'],
          i: i,
          refreshlist: refreshList,
          editlist: editlist,
        )

    );;
  }
}


class EventCard extends StatefulWidget {
  EventCard({Key? key, required this.title, required this.date, required this.time, required this.i, required this.refreshlist, required this.editlist}) : super(key: key){
    calcTime();
  }

  final String title;
  String date;
  String time;
  final i;
  String timeRemainingMessage = "";
  Function refreshlist;
  Function editlist;

  void calcTime()
  {
    List<String> dates = date.split("/");
    List<String> times = time.split(":");

    DateTime datex = DateTime(
      int.parse(dates[2]),
      int.parse(dates[1]),
      int.parse(dates[0]),
      int.parse(times[0]),
      int.parse(times[1])
      );

    //formatting
    time = '';
    date = '';
    if(int.parse(times[0]) < 10){
      time = '0';
    }
    time += '${times[0]}:';

    if(int.parse(times[1]) < 10){
      time += '0';
    }
    time += times[1];

    if(int.parse(dates[0]) < 10){
      date = '0';
    }
    date += '${dates[0]}/';

    if(int.parse(dates[1]) < 10){
      date += '0';
    }
    date += '${dates[1]}/${dates[2]}';

    //time message
    Duration timeRemaining = datex.difference(DateTime.now());

    if(timeRemaining.isNegative) {
      timeRemainingMessage = "Expired!";
    }
    else {
      if(timeRemaining.inDays >= 365) {
        timeRemainingMessage = "${timeRemaining.inDays ~/ 365}Yrs ${(timeRemaining.inDays % 365) ~/ 30}mons";
      }
      else if(timeRemaining.inDays >= 30) {
        timeRemainingMessage = "${timeRemaining.inDays ~/ 30}Mons ${timeRemaining.inDays % 30}days";
      }
      else if(timeRemaining.inDays >= 1) {
        timeRemainingMessage = "${timeRemaining.inDays}Days ${timeRemaining.inHours % 24}hrs";
      }
      else {
        timeRemainingMessage = "${timeRemaining.inHours}Hrs ${timeRemaining.inMinutes % 60}mins";
      }
    }
  }

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                    widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
              ),
              Text(
                widget.timeRemainingMessage,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: (widget.timeRemainingMessage == "Expired!") ? Colors.red : Colors.green
                ),
              )
            ],
          ),
          subtitle: Row(
            children: [
              Text(
                widget.date
              ),
              const SizedBox(
                width: 100,
              ),
              Text(
                widget.time
              )
            ],
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text(
                    'Edit'
                  ),
                 onPressed: (){
                    widget.editlist(widget.i);
                 },
                ),
                TextButton(
                  child: const Text(
                    'Delete'
                  ),
                  onPressed: (){
                    tasklist.removeAt(widget.i);
                    widget.refreshlist();
                    }
                    )
            ]
            )
          ],
        ),
    )
    );
  }
}
