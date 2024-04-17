import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orbital_spa/constants/theme.dart';
import 'package:orbital_spa/services/cloud/events/cloud_event.dart';
import 'package:orbital_spa/services/cloud/date_formatter.dart';
import '../../../constants/colours.dart';
import '../../../services/auth/data/repositories/auth_repository.dart';
import '../../../services/cloud/events/firebase_cloud_event_storage.dart';
import '../../../services/notifications/notifications_service.dart';
import '../../../utilities/widgets/features/button.dart';
import '../../../utilities/widgets/features/input_field.dart';
 
class AddEventView extends StatefulWidget {
  final CloudEvent? event;
  const AddEventView({super.key, this.event});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {

  late final FirebaseCloudEventStorage _eventService;
  CloudEvent? _event;
  late NotifyHelper notifyHelper;

  late DateTime fromDate;
  late DateTime toDate;
  bool isAllDay = false;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool doRemind = false;
  late DateTime remindAt;

  @override
  void initState() {
    super.initState();
    _eventService = FirebaseCloudEventStorage();
    notifyHelper = NotifyHelper();

    if (widget.event == null) {
      DateTime current = DateTime.now();
      fromDate = DateTime(current.year, current.month, current.day, 8, 0);
      toDate = fromDate.add(const Duration(hours: 2));
      remindAt = fromDate.subtract(const Duration(hours: 1));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios, size: 20)
      ),
      title: Text(
        "New Event",
        style: titleStyle,
      ),
      centerTitle: true,
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
        title: "Title", 
        hint: "Add Event Title", 
        controller: _titleController,
        height: 52
      ),
    );
  }

  Widget _dateTimePickers() {
    return Column(
      children: [
        _timeFrom(),
        const SizedBox(height: 10,),
        Visibility(
          visible: !isAllDay,
          child: _timeTo()
        )
      ],
    );
  }

  Widget _timeFrom() {
    return _header(
      header: isAllDay ? "On" : "From",
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
                text: DateFormatter.toDate(fromDate),
                onClicked: () {
                  _pickFromDateTime(pickDate: true);
                }
              )
            ),
          
            Visibility(
              visible: !isAllDay,
              child: Expanded(
                child: _dropDownField(
                  text: DateFormatter.toTime(fromDate),
                  onClicked: () {
                    _pickFromDateTime(pickDate: false);
                  }
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _timeTo() {
    return _header(
      header: "To",
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
                text: DateFormatter.toDate(toDate),
                onClicked: () {
                  _pickToDateTime(pickDate: true);
                }
              )
            ),
          
            Visibility(
              visible: !isAllDay,
              child: Expanded(
                child: _dropDownField(
                  text: DateFormatter.toTime(toDate),
                  onClicked: () {
                    _pickToDateTime(pickDate: false);
                  }
                )
              ),
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
          style: titleStyle,
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

  Future _pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) {
      return;
    }

    if (date.isAfter(toDate)) {
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      fromDate = date;
    });
  }

  Future _pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate, 
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null
    );

    if (date == null) {
      return;
    }

    if (date.isAfter(toDate)) {
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() {
      toDate = date;
      if (remindAt.isAfter(toDate)) {
        remindAt = toDate;
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
      // Create new task.
      final currentUser = AuthRepository.firebase().currentUser!;
      final userId = currentUser.id;
      final newEvent = await _eventService.createNewEvent(ownerUserId: userId);
      _event = newEvent;

      // Update fields.
      final event = _event;
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      
      final from = fromDate.toString();
      final to = toDate.toString();
      final isAllDay = this.isAllDay ? 1 : 0;
      final doRemind = this.doRemind ? 1 : 0;
      final remindAt = this.remindAt.toString();
      final uniqueId = UniqueKey().hashCode;

      await _eventService.updateEvent(
        documentId: event!.documentId, 
        title: title, 
        description: description, 
        from: from, 
        to: to, 
        isAllDay: isAllDay,
        doRemind: doRemind,
        remindAt: remindAt,
        uniqueId: uniqueId
      );

      if (this.doRemind) {
        notifyHelper.scheduledEventNotification(this.remindAt, uniqueId, title);
      }



      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar("Required", "Title is required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded));
    }
  }
  
  Widget _descriptionBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: MyInputField(
        title: "Description", 
        hint: "Add Event Description (optional)", 
        controller: _descriptionController,
        height: 52
      ),
    );
  }

  Widget _allDayEvent() {
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            value: isAllDay, 
            onChanged: (value) {
              setState(() {
                isAllDay = value!;
              });
            },
            checkColor: Colors.white,
            shape: const CircleBorder(),
          ),
        ),
        const SizedBox(width: 8,),
        const Text(
          'All Day Event',
          style: TextStyle(
            fontFamily: 'GT Walsheim',
            fontSize: 20,
            fontWeight: FontWeight.w300
          ),
        )
      ],
    );
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

  Widget _saveButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: MyButton(
        label: "Save", 
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _titleField(),
              const SizedBox(height: 20),
              _allDayEvent(),
              const SizedBox(height: 10,),
              _dateTimePickers(),
              const SizedBox(height: 20,),
              _descriptionBox(),
              const SizedBox(height: 20,),
              _doRemind(),
              const SizedBox(height: 10,),
              Visibility(
                visible: doRemind,
                child: _remindTimePickers()
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
      )
    );
  }
}