import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/constants/theme.dart';
import 'package:orbital_spa/services/auth/data/repositories/auth_repository.dart';
import 'package:orbital_spa/utilities/widgets/features/input_field.dart';
import '../../../services/cloud/tasks/cloud_task.dart';
import '../../../services/cloud/tasks/firebase_cloud_task_storage.dart';
import '../../../utilities/widgets/features/button.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {

  CloudTask? _task; 
  late final FirebaseCloudTaskStorage _taskService;

  DateTime _selectedDeadline = DateTime.now();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // String _selectedRemind = 'None';
  // List<String> remindList = ['None', '5', '10', '15', '20', '25', '30'];
  // bool doRemind = false;

  // String _selectedRepeat = "None";
  // List<String> repeatList = [
  //   "None",
  //   "Daily",
  //   "Weekly"
  // ];
  // bool doRepeat = false;

  int difficulty = 5;

  int importance = 5;

  int timeRequired = 0;

  int _selectedColour = 0;


  @override
  void initState() {
    super.initState();
    _taskService = FirebaseCloudTaskStorage();
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios, size: 20)
      ),
      // backgroundColor: Color(0xFFf1fafe),
      title: Text(
        'New Task',
        style: titleStyle,
      ),
      centerTitle: true,
      // shadowColor: Colors.white,
    );
  }

  Widget _titleField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MyInputField(
        title: "Title", 
        hint: "Add Task Name", 
        controller: _titleController,
        height: 52
      ),
    );
  }

  Widget _noteField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MyInputField(
        title: "Note", 
        hint: "Add Task Note (optional)", 
        controller: _noteController,
        height: 52
      ),
    );
  }

  Widget _deadlineButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MyInputField(
        title: "Deadline", 
        hint: DateFormat.yMMMMd().format(_selectedDeadline), 
        widget: IconButton(
          onPressed: () {
            _getDateFromUser();
          },
          icon: const Icon(
            Icons.calendar_today_outlined,
            color: Colors.grey
          ),
        ),
        height: 52
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(1980), 
      lastDate: DateTime(2050)
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDeadline = pickerDate;
      });
    } 
    //deal with exception
  }

  Widget _difficultyBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Difficulty",
            style: titleStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Slider(
              value: difficulty / 1, 
              min: 0,
              max: 10,
              divisions: 10,
              label: difficulty.toString(),
              onChanged: (value) {
                setState(() {
                  difficulty = value.toInt();
                });
              }
            ),
          )
        ],
      ),
    );
  }

  Widget _importanceBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Importance",
            style: titleStyle,
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Slider(
              value: importance / 1, 
              min: 0,
              max: 10,
              divisions: 10,
              label: importance.toString(),
              onChanged: (value) {
                setState(() {
                  importance = value.toInt();
                });
              }
            ),
          )
        ],
      ),
    );
  }

  Widget _estimatedTimeRequired() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Time To Complete (Hours)',
          style: titleStyle,
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = timeRequired - 1;
                timeRequired = newValue.clamp(0, 30);
              }),
            ),
            NumberPicker(
              minValue: 0, 
              maxValue: 30, 
              step: 1,
              itemHeight: 70,
              itemWidth: 90,
              value: timeRequired, 
              onChanged: (value) {
                setState(() {
                  timeRequired = value;
                });
              },
              axis: Axis.horizontal,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = timeRequired + 1;
                timeRequired = newValue.clamp(0, 30);
              }),
            ),
          ],
        )
      ],
    );
  }

  // Widget _doRemindRepeat() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Switch(
  //             value: doRemind, 
  //             onChanged: (value) {
  //               setState(() {
  //                 doRemind = value;
  //               });
  //             }
  //           ),
  //           const SizedBox(width: 10,),
  //           const Text("Remind")
  //         ],
  //       ),

  //       Row(
  //         children: [
  //           Switch(
  //             value: doRepeat, 
  //             onChanged: (value) {
  //               setState(() {
  //                 doRepeat = value;
  //               });
  //             }
  //           ),
  //           const SizedBox(width: 10,),
  //           const Text("Repeat")
  //         ],
  //       )
  //     ],
  //   );
  // }

  // Widget _remindButton() {
  //   return MyInputField(
  //     title: "Remind", 
  //     hint: "$_selectedRemind minutes early",
  //     widget: DropdownButton(
  //       alignment: Alignment.topRight,
  //       icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
  //       iconSize: 32,
  //       elevation: 4,
  //       items: remindList.map<DropdownMenuItem<String>>((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(value)
  //         );
  //       }).toList(),
  //       underline: Container(height: 0),
  //       onChanged: (String? newValue) {
  //         setState(() {
  //            _selectedRemind = newValue!;
  //         });
  //       },
  //     ),
  //   );
  // }

  // Widget _repeatButton() {
  //   return MyInputField(
  //     title: "Repeat", 
  //     hint: _selectedRepeat,
  //     widget: DropdownButton(
  //       icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
  //       iconSize: 32,
  //       elevation: 4,
  //       items: repeatList.map<DropdownMenuItem<String>>((String value) {
  //         return DropdownMenuItem<String>(
  //           value: value,
  //           child: Text(value, style: const TextStyle(color: Colors.grey),)
  //         );
  //       }).toList(),
  //       underline: Container(height: 0),
  //       onChanged: (String? newValue) {
  //         setState(() {
  //           _selectedRepeat = newValue!;
  //         });
  //       },
  //     ),
  //   );
  // }

  Widget _colourButton() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text( 
              "Color",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            
            const SizedBox(height: 8.0,),
            
            Wrap(
              children: List<Widget>.generate(
                3, 
                (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColour = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: index == 0
                                         ? Colors.blue
                                         : index == 1
                                         ? Colors.red
                                         : Colors.yellow,
                        child: _selectedColour == index 
                               ? const Icon(Icons.done, color: Colors.white, size: 16,)
                               : Container(),
                      ),
                    ),
                  );
                }
              )
            )
          ],
        )
      ],
    );
  }

  Widget _saveButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: MyButton(
        label: "Create", 
        onTap: () {
        _validateDate();
        },
        innerColour: darkBlue,
        borderColor: darkBlue,
        fontColor: Colors.white,
      ),
    );
  }

  Widget _cancelButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: MyButton(
        label: "Cancel", 
        onTap: () {
          Get.back();
        },
        innerColour: Colors.white,
        borderColor: blue,
        fontColor: darkBlue,
      ),
    );
  }

  _validateDate() async {
    if(_titleController.text.isNotEmpty) {
      // Create new task.
      final currentUser = AuthRepository.firebase().currentUser!;
      final userId = currentUser.id;
      final newTask = await _taskService.createNewTask(ownerUserId: userId);
      _task = newTask;

      // Update fields.
      final task = _task;
      final title = _titleController.text.trim();
      final text = _noteController.text.trim();
      // final date = DateFormat.yMd().format(_selectedDate);
      final deadline = _selectedDeadline.toString();
      final difficulty = this.difficulty;
      final importance = this.importance;
      // final remind = remindList.indexOf(_selectedRemind);
      // final repeat = repeatList.indexOf(_selectedRepeat);
      // final color = _selectedColour;

      await _taskService.updateTask(
        documentId: task!.documentId, 
        title: title, 
        text: text, 
        deadline: deadline,
        difficulty: difficulty,
        importance: importance,
        timeRequired: timeRequired,
        // remind: remind,
        // repeat: repeat,
        // color: color
      );

      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar("Required", "Title is required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        // color: Color(0xFFf1fafe),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [

              _titleField(),

              _noteField(),

              _deadlineButton(),

              _difficultyBar(),

              _importanceBar(),

              _estimatedTimeRequired(),

              const SizedBox(height: 18,),

              // _colourButton(),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cancelButton(),
                  const SizedBox(width: 20,),
                  _saveButton(),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}