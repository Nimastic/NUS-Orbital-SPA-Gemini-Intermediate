import 'package:flutter/material.dart';
import 'package:orbital_spa/utilities/dialogs/generic_dialog.dart';

/// Error dialog that tells users what type of error has occured.
Future<void> showErrorDialog(
  BuildContext context,
  String text
) {
  return showGenericDialog(
    context: context, 
    title: 'An error has occured', 
    content: text, 
    optionsBuilder: () => {
      'OK': null,
    },
  );
}