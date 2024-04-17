import 'package:flutter/material.dart';
import 'package:orbital_spa/services/cloud/tasks/cloud_task.dart';

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  // static const List<MenuItem> firstItems = [home, share, settings];
  // static const List<MenuItem> secondItems = [logout];

  static const edit = MenuItem(text: 'Edit', icon: Icons.edit_outlined);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete_outline);

  static const List<MenuItem> items = [edit, delete];

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'GT Walsheim'
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged({
    required BuildContext context, 
    required MenuItem item, 
    required CloudTask task, 
    required Function onEdit,
    required Function onDelete
  }) {
    switch (item) {
      case MenuItems.edit:
        onEdit(task);
        break;
      case MenuItems.delete:
        onDelete(task);
        break;

    }
  }
}