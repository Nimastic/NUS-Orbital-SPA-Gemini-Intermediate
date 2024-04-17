import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orbital_spa/constants/theme.dart';
import 'package:orbital_spa/services/cloud/date_formatter.dart';
import '../../../constants/colours.dart';
import '../../../services/auth/data/repositories/auth_repository.dart';
import '../../../services/cloud/reminders/cloud_reminder.dart';
import '../../../services/cloud/reminders/firebase_cloud_reminders_storage.dart';
import '../../../services/notifications/notifications_service.dart';
import '../../../utilities/widgets/features/button.dart';
import '../../../utilities/widgets/features/input_field.dart';

class AddReminderView extends StatefulWidget {
  final CloudReminder? reminder;
  const AddReminderView({super.key, this.reminder});

  @override
  State<AddReminderView> createState() => _AddReminderViewState();
}

class _AddReminderViewState extends State<AddReminderView> {

  late final FirebaseCloudReminderStorage _reminderService;
  CloudReminder? _reminder;
  late NotifyHelper notifyHelper;

  late DateTime by;

  bool isCompleted = false;

  final _titleController = TextEditingController();

  bool doRemind = true;
  late DateTime remindAt;

  String _selectedRepeat = "Daily";
  List<String> repeatList = [
    "Daily",
    "Weekly",
    "Monthly"
  ];
  bool doRepeat = false;


  @override
  void initState() {
    super.initState();
    _reminderService = FirebaseCloudReminderStorage();
    notifyHelper = NotifyHelper();

    if (widget.reminder == null) {
      int year = DateTime.now().year;
      int month = DateTime.now().month;
      int day = DateTime.now().day;
      by = DateTime(year, month, day).add(const Duration(days: 1));
      remindAt = by;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      // backgroundColor: Colors.purple,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios, size: 20)
      ),
      title: Text(
        "New Reminder",
        style: titleStyle,
      ),
      centerTitle: true,
      // actions: buildEditingActions(),
    );
  }

  List<Widget> buildEditingActions() => [
    ElevatedButton.icon(
      onPressed: _saveForm, 
      icon: const Icon(Icons.done), 
      label: const Text("SAVE"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent
      ),
    )
  ];

  Widget _titleField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MyInputField(
        title: "Memo", 
        hint: "Add Reminder", 
        controller: _titleController,
        height: 100,
      ),
    );
  }

  Widget _byDateTimePickers() {
    return Column(
      children: [
        _timeBy(),
      ],
    );
  }

  Widget _timeBy() {
    return _header(
      header: "By",
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.0
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200]
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _dropDownField(
                text: DateFormatter.toDate(by),
                onClicked: () {
                  _pickByDateTime(pickDate: true);
                }
              )
            ),
          
            Expanded(
              child: _dropDownField(
                text: DateFormatter.toTime(by),
                onClicked: () {
                  _pickByDateTime(pickDate: false);
                }
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _header({
    required String header, 
    required Widget child
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: titleStyle
        ),
        child
      ],
    );
  }

  Widget _dropDownField({
    required String text,
    required VoidCallback onClicked
  }) {
    return ListTile(
      title: Text(
        text,
        style: hintStyle,
      ),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }

  Future _pickByDateTime({required bool pickDate}) async {
    final date = await pickDateTime(by, pickDate: pickDate);

    if (date == null) {
      return;
    }

    setState(() {
      by = date;
      if (remindAt.isAfter(by)) {
        remindAt = by;
      }
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
      required bool pickDate,
      DateTime? firstDate
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context, 
        initialDate: initialDate, 
        firstDate: firstDate ?? DateTime(2015, 8), 
        lastDate: DateTime(2101)
      );

      if (date == null) {
        return null;
      }

      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.fromDateTime(initialDate)
      );

      if (timeOfDay == null) {
        return null;
      }

      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      final dateTime = date.add(time);

      return dateTime;
    }
  }

  Future _saveForm() async {

    if (_titleController.text.isNotEmpty) {
      // Create new reminder.
      final currentUser = AuthRepository.firebase().currentUser!;
      final userId = currentUser.id;
      final newReminder = await _reminderService.createNewReminder(ownerUserId: userId);
      _reminder = newReminder;

      // Update fields.
      final reminder = _reminder;
      final title = _titleController.text.trim();

      final by = this.by.toString();
      final isCompleted = this.isCompleted ? 1 : 0;
      final uniqueId = UniqueKey().hashCode;

      await _reminderService.updateReminder(
        documentId: reminder!.documentId, 
        title: title, 
        by: by,
        doRemind: doRemind ? 1 : 0,
        remindAt: remindAt.toString(), 
        doRepeat: doRepeat ? 1 : 0,
        repeat: _selectedRepeat,
        isCompleted: isCompleted,
        uniqueId: uniqueId
      );
      
      if (doRemind) {
        if (doRepeat) {
          if (_selectedRepeat == "Daily") {
            notifyHelper.scheduledDailyReminderNotification(remindAt, uniqueId, title);
          } else if (_selectedRepeat == 'Weekly') {
            notifyHelper.scheduledWeeklyReminderNotification(remindAt, uniqueId, title);
          } else {
            notifyHelper.scheduledMonthlyReminderNotification(remindAt, uniqueId, title);
          }
        } else {
          notifyHelper.scheduledReminderNotification(remindAt, uniqueId, title);
        }
      }
      

      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar("Required", "Memo is required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded));
    }
  }
  
  Widget _doRemind() {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Switch(
            value: doRemind, 
            onChanged: (value) {
              setState(() {
                doRemind = value;
              });
            }
          ),
        ),
        const SizedBox(width: 10,),
        const Text(
          "Remind",
          style: TextStyle(
            fontFamily: 'GT Walsheim',
            fontSize: 20,
            fontWeight: FontWeight.w300
          ),
        )
      ],
    );
  }

  Widget _remindTimePickers() {
    return Column(
      children: [
        _timeToRemind(),
      ],
    );
  }

  Widget _timeToRemind() {
    return _header(
      header: "Remind At",
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.0
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200]
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _dropDownField(
                text: DateFormatter.toDate(remindAt),
                onClicked: () {
                  _pickRemindDateTime(pickDate: true);
                }
              )
            ),
          
            Expanded(
              child: _dropDownField(
                text: DateFormatter.toTime(remindAt),
                onClicked: () {
                  _pickRemindDateTime(pickDate: false);
                }
              )
            )
          ],
        ),
      ),
    );
  }

  Future _pickRemindDateTime({required bool pickDate}) async {
    final date = await pickDateTime(remindAt, pickDate: pickDate);

    if (date == null) {
      return;
    }

    setState(() {
      remindAt = date;
    });
  }

  Widget _doRepeat() {
    return Row(
      children: [
        Transform.scale(
          scale: 0.9,
          child: Switch(
            value: doRepeat, 
            onChanged: (value) {
              setState(() {
                doRepeat = value;
              });
            }
          ),
        ),
        const SizedBox(width: 10,),
        const Text(
          "Repeat",
          style: TextStyle(
            fontFamily: 'GT Walsheim',
            fontSize: 20,
            fontWeight: FontWeight.w300
          ),
        )
      ],
    );
  }

  Widget _repeatButton() {
    return MyInputField(
      title: "Repeat", 
      hint: _selectedRepeat,
      widget: DropdownButton(
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
        iconSize: 32,
        elevation: 4,
        items: repeatList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.black),)
          );
        }).toList(),
        underline: Container(height: 0),
        onChanged: (String? newValue) {
          setState(() {
            _selectedRepeat = newValue!;
          });
        },
      ),
      height: 52
    );
  }

  Widget _saveButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: MyButton(
        label: "Create", 
        onTap: () {
        _saveForm();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _titleField(),
                const SizedBox(height: 20 ),
                _byDateTimePickers(),
                const SizedBox(height: 20 ),
                _doRemind(),
                const SizedBox(height: 10 ),
                Visibility(
                  visible: doRemind,
                  child: _remindTimePickers()
                ),
                const SizedBox(height: 20 ),
                Visibility(
                  visible: doRemind,
                  child: _doRepeat()
                ),
                Visibility(
                  visible: doRemind && doRepeat,
                  child: _repeatButton()
                ),
                const SizedBox(height: 20,),
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
        ),
      )
    );
  }
}