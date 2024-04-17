import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/constants/theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../menu_items/todo_actions.dart';
import '../../../services/cloud/tasks/cloud_task.dart';

class ToDoTile extends StatefulWidget {
  final CloudTask task;
  final Function onToDoChanged;
  final Function onDeleteItem;
  final Function onComplete;

  const ToDoTile({
    Key? key,
    required this.task,
    required this.onToDoChanged,
    required this.onDeleteItem, 
    required this.onComplete,
  }) : super(key: key);

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {

  late CloudTask task;
  late String title;
  late String text;
  late String deadline;
  late int difficulty;
  late int importance;
  late int timeRequired;
  late bool isCompleted;
  final List<String> items = ['Edit', 'Delete'];

  @override
  void initState() {
    super.initState();
    task = widget.task;
    title = widget.task.title;
    text = widget.task.text;
    deadline = DateFormat('yMMMMd').format(DateTime.parse(widget.task.deadline));
    difficulty = widget.task.difficulty;
    importance = widget.task.importance;
    timeRequired = widget.task.timeRequired;
    isCompleted = widget.task.isCompleted == 1;
  }

  @override
  void didUpdateWidget(ToDoTile oldWidget) {
    if(task != widget.task) {
        setState((){
            task = widget.task;
            title = widget.task.title;
            text = widget.task.text;
            deadline = DateFormat('yMMMMd').format(DateTime.parse(widget.task.deadline));
            difficulty = widget.task.difficulty;
            importance = widget.task.importance;
            timeRequired = widget.task.timeRequired;
            isCompleted = widget.task.isCompleted == 1;
        });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 18, right: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(),
        gradient: LinearGradient(
          colors: isCompleted 
                  ? [lightBlue, background]
                  : [lightOrange, background]
        )
      ),
      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 8),
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 25,
                  child: Checkbox(
                    activeColor: pink,
                    value: isCompleted, 
                    onChanged: (value) {
                      widget.onComplete(task);
                    },
                    shape: const CircleBorder(),
                    side: const BorderSide(
                      width: 0.7
                    ),
                  ),
                ),
                const SizedBox(width: 7,),
                Text(
                  title,
                  style: taskTitleStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                DropdownButton2(
                  customButton: const Icon(Icons.more_horiz),
                  items: MenuItems.items.map((item) {
                    return DropdownMenuItem<MenuItem>(
                      value: item,
                      child: MenuItems.buildItem(item)
                    );
                  }).toList(),
                  onChanged: (value) {
                    MenuItems.onChanged(
                      context: context, 
                      item: value as MenuItem,
                      task: widget.task,
                      onEdit: widget.onToDoChanged,
                      onDelete: widget.onDeleteItem
                    );
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 140,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    offset: const Offset(0, 8),
                  ),
                )
              ],
            ),
          ),

          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 12, left: 15, right: 15),
            child: Text(
              text,
              style: taskTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 10),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                ),
                const SizedBox(width: 5,),
                Text(
                  deadline,
                  style: const TextStyle(
                    fontFamily: 'GT Walsheim'
                  ),
                ),
                const Spacer(),

                Row(
                  children: [
                    const Icon(Icons.settings),
                    Text(difficulty.toString())
                  ],
                ),
                const SizedBox(width: 7,),

                Row(
                  children: [
                    const Icon(Icons.notification_important_outlined),
                    Text(importance.toString())
                  ],
                ),

                const SizedBox(width: 7,),

                Row(
                  children: [
                    const Icon(Icons.access_time),
                    Text(timeRequired.toString())
                  ],
                )
              ],
            ),
          )
        ],
      )
    );
  }
}