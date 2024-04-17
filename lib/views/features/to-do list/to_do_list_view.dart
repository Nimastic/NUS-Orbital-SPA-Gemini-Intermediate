import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/services/cloud/tasks/cloud_task.dart';
import 'package:orbital_spa/services/model/ml_model.dart';
import 'package:orbital_spa/utilities/widgets/features/todo_tile.dart';
import 'package:orbital_spa/views/features/to-do%20list/edit_task.dart';

import '../../../services/auth/data/repositories/auth_repository.dart';
import '../../../services/cloud/tasks/firebase_cloud_task_storage.dart';
import '../../../utilities/widgets/features/button.dart';
import 'add_task_view.dart';

class ToDoListView extends StatefulWidget {
  const ToDoListView({super.key});

  @override
  State<ToDoListView> createState() => _ToDoListViewState();
}

class _ToDoListViewState extends State<ToDoListView> {

  late final FirebaseCloudTaskStorage _taskService;
  String get userId => AuthRepository.firebase().currentUser!.id;

  bool showAll = true;
  bool showCompleted = false;
  bool showInProgress = false;

  List<CloudTask> currTasks = [];


  @override
  void initState() {
    super.initState();
    _taskService = FirebaseCloudTaskStorage();
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: background,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios)
      ),

      title: const Text(
        'My Tasks',
        style: TextStyle(
          fontFamily: 'GT Walsheim',
          fontSize: 24,
          fontWeight: FontWeight.bold
        ),
      ),
      centerTitle: true,

      actions: [

        GestureDetector(
          onTap: () {
            showDialog(
              context: context, 
              builder: _suggestTask
            );
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: white,
                width: 2
              ),
            ),
            child: const Icon(
              Icons.recommend,
              color: black,
              size: 34,
            ),
          ),
        ),

        const SizedBox(width: 20,)
      ],
    );
  }

  Widget _suggestTask(BuildContext context) {
    return AlertDialog(
      backgroundColor: white,
      title: const Text(
        "Suggested Order of Completion",
        style: TextStyle(
          fontFamily: 'GT Walsheim'
        ),
      ),
      content: _taskOrder(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const Text('Got It!', style: TextStyle(fontFamily: 'GT Walsheim'),)
        )
      ],
    );
  }

  Widget _taskOrder() {

    if (currTasks.isEmpty) {
      return Container(
        alignment: Alignment.center,
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.2,
        // padding: const EdgeInsets.symmetric(vertical: ),
        child: const Text(
          'You have no pending tasks currently.',
          style: TextStyle(
            fontFamily: 'GT Walsheim',
            fontSize: 24
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    List<List<int>> input = currTasks.map((task) {
      return [
        DateTime.parse(task.deadline).isBefore(DateTime.now())  
            ? DateTime.parse(task.deadline).difference(DateTime.now()).inDays
            : DateTime.parse(task.deadline).difference(DateTime.now()).inDays * (-1), // time left
        task.timeRequired,
        task.difficulty,
        task.importance
      ];
    }).toList();

    Iterable output = MlModel().run(input, input.length);

    List taskOrder = _sortTasks(output);

    return SizedBox(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        itemCount: input.length,
        itemBuilder: (context, index) {
          final value = taskOrder[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 7),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5).copyWith(top: 7),
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: black//Colors.grey[600]!
              ),
              borderRadius: BorderRadius.circular(30),
              color: lightPurple
            ),
            child: Row(
              children: [
                Text(
                  "${(index + 1).toString()}.",
                  style: const TextStyle(
                    fontFamily: 'GT Walsheim',
                    fontSize: 16
                  )
                ),
                const SizedBox(width: 10,),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontFamily: 'GT Walsheim',
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  List _sortTasks(Iterable output) {

    List finalOutput = output.expand((element) => element).toList();

    List todoTasks = List.of(currTasks);

    List tasks = [];

    while(finalOutput.isNotEmpty) {
      double smallestValue = finalOutput.reduce((a, b) => a >= b ? a : b);
      int index = finalOutput.indexOf(smallestValue);
      CloudTask nextTask = todoTasks[index];
      tasks.add(nextTask.title);
      finalOutput.remove(smallestValue);
      todoTasks.remove(nextTask);
    }

    return tasks;
  }

  Widget _selectTask(bool isSelected, String title, Color bubbleColor, int numOfTasks) {
    return Container(
      height: 45,
      width: 150,
      decoration: BoxDecoration(
        color: isSelected ? black : taskTag,
        borderRadius: BorderRadius.circular(25),
        border: Border.all()
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'GT Walsheim',
              fontSize: 18,
              color: isSelected ? white : black
            )
          ),
          const SizedBox(width: 7,),
          Container(
            alignment: Alignment.center,
            height: 20,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: bubbleColor
            ),
            child: Text(numOfTasks.toString()),
          )
        ],
      ),
    );
  }

  Widget _showCertainTasks(int all, int todo, int completed) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(top: 17, bottom: 15, left: 15, right: 15),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = true;
                  showCompleted = false;
                  showInProgress = false;
                });
              },
              child: _selectTask(showAll, "All Tasks", blue, all)
            ),
      
            const SizedBox(width: 15,),
      
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = false;
                  showCompleted = false;
                  showInProgress = true;
                });
              },
              child: _selectTask(showInProgress, "To Do", green, todo)
            ),
      
            const SizedBox(width: 15,),
      
            GestureDetector(
              onTap: () {
                setState(() {
                  showAll = false;
                  showCompleted = true;
                  showInProgress = false;
                });
              },
              child: _selectTask(showCompleted, "Completed", blue, completed)
            ),
          ],
        ),
      ),
    );
  }

  Widget _showTasksTiles(Iterable<CloudTask> allTasks) {

    return Expanded(
      child: ListView.builder(
        itemCount: allTasks.length,
        itemBuilder: (context, index) {
          final task = allTasks.elementAt(index);
            return ToDoTile(
              task: task, 
              onToDoChanged: (task) {
                Get.to(() => EditTaskView(task: task,));
              }, 
              onDeleteItem: (task) {
                _taskService.deleteTask(documentId: task.documentId);
              }, 
              onComplete: (task) {
                setState(() {
                  _taskService.completeTask(
                    documentId: task.documentId, 
                    isCompleted: task.isCompleted == 0 ? 1 : 0
                  );
                });
              },
            );
          }
        ),
    );
                
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: background,
      body: StreamBuilder(
          stream: _taskService.allDocs(ownerUserId: userId),
          builder: (context, snapshot) {
      
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allTasks = snapshot.data as Iterable<CloudTask>;
                  final todoTasks = allTasks.where((task) => task.isCompleted == 0);
                  currTasks = todoTasks.toList();
                  final completedTasks = allTasks.where((task) => task.isCompleted == 1);

                  return Column(
                    children: [
                      _showCertainTasks(allTasks.length, todoTasks.length, completedTasks.length),

                      Visibility(
                        visible: showAll,
                        child: _showTasksTiles(allTasks)
                      ),
                      Visibility(
                        visible: showInProgress,
                        child: _showTasksTiles(todoTasks)
                      ),
                      Visibility(
                        visible: showCompleted,
                        child: _showTasksTiles(completedTasks)
                      ),

                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default: return const CircularProgressIndicator();
            }
          }
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
        child: MyButton(
          label: "+ Add Task", 
          onTap: () async {
            await Get.to(() => (const AddTaskView()));
            _taskService.getTasks(ownerUserId: "ownerUserId");
          },
          innerColour: lightPurple,
          borderColor: lightPurple,
          fontColor: black,
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_month_outlined),
      //       label: "Calendar"
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.assessment_outlined),
      //       label: "To Do"
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.alarm_outlined),
      //       label: "Reminders"
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped, 
      // ),
    );
  }
}