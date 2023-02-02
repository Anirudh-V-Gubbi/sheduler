import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scheduler/sort_tasks.dart';
import 'package:scheduler/task.dart';

class addscreen extends StatefulWidget {
  addscreen({Key? key, required this.tasklist, required this.refreshlist})
      : super(key: key);

  List<Task> tasklist;
  Function refreshlist;

  @override
  _addscreenState createState() => _addscreenState();
}

class _addscreenState extends State<addscreen> {
  final titleCtrl = TextEditingController();

  TimeOfDay? time = TimeOfDay.now();
  DateTime _dateTime = DateTime.now();
  ValueNotifier repeat = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "New Task",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            backgroundColor: Colors.amber),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Task name",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 350,
                        height: 100,
                        child: TextField(
                          controller: titleCtrl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Deadline",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: SizedBox(
                              width: 45,
                              height: 45,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  _dateTime.day < 10
                                      ? "0${_dateTime.day.toString()}"
                                      : _dateTime.day.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )),
                        ),
                        const Text(" / "),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: SizedBox(
                              width: 45,
                              height: 45,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  _dateTime.month < 10
                                      ? "0${_dateTime.month.toString()}"
                                      : _dateTime.month.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )),
                        ),
                        const Text(" / "),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: SizedBox(
                              width: 70,
                              height: 45,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  _dateTime.year.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: FloatingActionButton(
                              heroTag: 'button1',
                              mini: true,
                              child: const Icon(
                                Icons.date_range,
                              ),
                              onPressed: () async {
                                DateTime? _newDate = await showDatePicker(
                                    context: context,
                                    initialDate: _dateTime,
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime(3000));
                                if (_newDate != null) {
                                  setState(() {
                                    _dateTime = _newDate;
                                  });
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Time",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: SizedBox(
                                width: 45,
                                height: 45,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    time!.hour < 10
                                        ? "0${time!.hour.toString()}"
                                        : time!.hour.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        const Text(" : "),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: SizedBox(
                              width: 45,
                              height: 45,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  time!.minute < 10
                                      ? "0${time!.minute.toString()}"
                                      : time!.minute.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: FloatingActionButton(
                              heroTag: 'button2',
                              mini: true,
                              child: const Icon(
                                Icons.access_time_outlined,
                              ),
                              onPressed: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                    context: context, initialTime: time!);
                                if (newTime != null) {
                                  setState(() {
                                    time = newTime;
                                  });
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Repeat",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: ValueListenableBuilder(
                            valueListenable: repeat,
                            builder: (context, repeatValue, _) => Checkbox(
                                value: repeat.value,
                                onChanged: (value) {
                                  repeat.value = value;
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: OutlinedButton(
                      onPressed: () async {
                        widget.tasklist.add(Task(
                          title: titleCtrl.text,
                          date:
                              '${_dateTime.day}/${_dateTime.month}/${_dateTime.year}',
                          time: '${time?.hour}:${time?.minute}',
                          repeat: repeat.value
                        ));

                        widget.tasklist = sortTasks(widget.tasklist);

                        var box = Hive.box('task');
                        await box.put('tasks', widget.tasklist);

                        widget.refreshlist(widget.tasklist);

                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                      child: const Text(
                        "Add task to schedule",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            backgroundColor: Colors.green,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
