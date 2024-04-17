import 'package:flutter/widgets.dart';
import 'package:orbital_spa/utilities/dialogs/generic_dialog.dart';

/// Logout Dialog to confirm with users whether to log out or not.
Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Log out', 
    content: 'Are you sure you want to log out?', 
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true
    }
  ).then((value) => value ?? false);
}