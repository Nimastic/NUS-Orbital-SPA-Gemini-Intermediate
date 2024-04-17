import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/utilities/widgets/features/input_field.dart';
import '../../../constants/theme.dart';
import '../../../services/cloud/tasks/cloud_task.dart';
import '../../../services/cloud/tasks/firebase_cloud_task_storage.dart';
import '../../../utilities/widgets/features/button.dart';


class EditTaskView extends StatefulWidget {
  final CloudTask task;
  const EditTaskView({super.key, required this.task});

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {

  late final FirebaseCloudTaskStorage _taskService;
  late CloudTask _task;

  late DateTime _selectedDeadline;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  late int _difficulty;
  late int _importance;
  late int _selectedColour;
  late int _timeRequired;


  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _taskService = FirebaseCloudTaskStorage();
    _selectedDeadline = DateTime.parse(_task.deadline);
    _titleController.text = _task.title;
    _noteController.text = _task.text;
    _difficulty = _task.difficulty;
    _importance = _task.importance;
    // _selectedColour = _task.color;
    _timeRequired = _task.timeRequired;
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          //pop up to save ?
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios, size: 20)
      ),
      title: Text(
        'Edit Task',
        style: titleStyle,
      ),
      centerTitle: true,
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
    return MyInputField(
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
              value: _difficulty / 1, 
              min: 0,
              max: 10,
              divisions: 10,
              label: _difficulty.toString(),
              onChanged: (value) {
                setState(() {
                  _difficulty = value.toInt();
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
              value: _importance / 1, 
              min: 0,
              max: 10,
              divisions: 10,
              label: _importance.toString(),
              onChanged: (value) {
                setState(() {
                  _importance = value.toInt();
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
                final newValue = _timeRequired - 1;
                _timeRequired = newValue.clamp(0, 30);
              }),
            ),
            NumberPicker(
              minValue: 0, 
              maxValue: 30, 
              step: 1,
              itemHeight: 70,
              itemWidth: 90,
              value: _timeRequired, 
              onChanged: (value) {
                setState(() {
                  _timeRequired = value;
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
                final newValue = _timeRequired + 1;
                _timeRequired = newValue.clamp(0, 30);
              }),
            ),
          ],
        )
      ],
    );
  }

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
        label: "Save", 
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

      // Update fields.
      final task = _task;
      final title = _titleController.text.trim();
      final text = _noteController.text.trim();
      final deadline = _selectedDeadline.toString();
      final difficulty = _difficulty;
      final importance = _importance;
      // final color = _selectedColour;

      await _taskService.updateTask(
        documentId: task.documentId, 
        title: title, 
        text: text, 
        deadline: deadline,
        difficulty: difficulty,
        importance: importance,
        timeRequired: _timeRequired,
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
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const Text(
              //   "Edit Task", 
              //   style: TextStyle(
              //     fontSize: 24, 
              //     fontWeight: FontWeight.bold
              //   ),
              // ),

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