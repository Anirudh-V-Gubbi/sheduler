import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scheduler/screens/add_screen.dart';
import 'package:scheduler/sort_tasks.dart';
import 'package:scheduler/task.dart';
import 'package:scheduler/widgets/events_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  final String title = 'Schedule';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future? future;
  List<Task> tasks = [];

  void refreshlist(List<Task> newlist) {
    setState(() {
      tasks = newlist;
    });
  }

  Future? getTasks() async {
    try {
      var box = Hive.box('task');

      List<Task> tasklist = [];
      List<dynamic> tempList = box.get('tasks', defaultValue: []);
      for (var element in tempList) {tasklist.add(element as Task);}

      return sortTasks(tasklist);
    } catch (e) {
      print("ERROR: Failed to initialise the list");
    }
  }

  @override
  void initState() {
    super.initState();
    future = getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
          future: future,
          builder: (context, taskdata) {
            if (taskdata.connectionState == ConnectionState.done) {
              if (taskdata.hasError) {
                return const Text("Failed to recieve task data");
              } else if (taskdata.hasData) {
                tasks = taskdata.data as List<Task>;

                return EventList(listoftask: tasks);
              } else {
                return const Center(child: Text("NO TASKS"));
              }
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: DraggableFab(
        initPosition: Offset(0.0, MediaQuery.of(context).size.height * 0.9),
        child: OutlinedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.amber),
              shape: MaterialStateProperty.all(const CircleBorder()),
              fixedSize:
                  MaterialStateProperty.all(const Size.fromRadius(30.0))),
          child: const Icon(
            Icons.add,
            size: 35.0,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        addscreen(tasklist: tasks, refreshlist: refreshlist)));
          },
        ),
      ),
    );
  }
}
