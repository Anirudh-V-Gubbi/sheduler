import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scheduler/sort_tasks.dart';

class editscreen extends StatefulWidget {
  editscreen(
      {Key? key,
      required this.task,
      required this.i,
      required this.tasklist,
      required this.refreshlist})
      : date = task['date'].toString().split("/"),
        times = task['time'].toString().split(":"),
        titleCtrl = TextEditingController(text: task['title']),
        super(key: key) {
    time = TimeOfDay(
        hour: int.parse(times[0].toString()),
        minute: int.parse(times[1].toString()));
    _dateTime =
        DateTime(int.parse(date[2]), int.parse(date[1]), int.parse(date[0]));
  }

  final task;
  final List date;
  final List times;
  final i;
  List tasklist;
  Function refreshlist;

  TimeOfDay? time;
  DateTime? _dateTime;

  final titleCtrl;

  @override
  _editscreenState createState() => _editscreenState();
}

class _editscreenState extends State<editscreen> {
  ValueNotifier repeat = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    repeat.value = widget.task['repeat'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Edit Task",
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
                        child: TextFormField(
                          controller: widget.titleCtrl,
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
                                  (widget._dateTime?.day)! < 10
                                      ? "0${widget._dateTime?.day.toString()}"
                                      : (widget._dateTime?.day.toString())!,
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
                                  (widget._dateTime?.month)! < 10
                                      ? "0${widget._dateTime?.month.toString()}"
                                      : (widget._dateTime?.month.toString())!,
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
                                  (widget._dateTime?.year.toString())!,
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
                                    initialDate: (widget._dateTime)!,
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime(3000));
                                if (_newDate != null) {
                                  setState(() {
                                    widget._dateTime = _newDate;
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
                                    widget.time!.hour < 10
                                        ? "0${widget.time!.hour.toString()}"
                                        : widget.time!.hour.toString(),
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
                                  widget.time!.minute < 10
                                      ? "0${widget.time!.minute.toString()}"
                                      : widget.time!.minute.toString(),
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
                                    context: context,
                                    initialTime: widget.time!);
                                if (newTime != null) {
                                  setState(() {
                                    widget.time = newTime;
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
                        widget.tasklist[widget.i] = {
                          'title': widget.titleCtrl.text,
                          'date':
                              '${widget._dateTime?.day}/${widget._dateTime?.month}/${widget._dateTime?.year}',
                          'time': '${widget.time?.hour}:${widget.time?.minute}',
                          'repeat': repeat.value
                        };

                        widget.tasklist = sortTasks(widget.tasklist);

                        widget.refreshlist(newlist: widget.tasklist);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                      child: const Text(
                        "Save",
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
