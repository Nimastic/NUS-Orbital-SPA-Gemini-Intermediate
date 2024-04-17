import 'package:flutter/material.dart';

/// Map containing a string text and a value of textbuttons in the dialog.
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

/// A generic dialog that can be used to create any type of dialog.
Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content, 
  required DialogOptionBuilder optionsBuilder
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),

        // Uses the map function on the Map<String, T?> to 
        // return a list of textbutton widgets to be shown on the dialog.
        actions: options.keys.map((optionsTitle) {
          final value = options[optionsTitle];
          return TextButton(
            
            onPressed: () {
              // Pop the dialog based on the value.
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            }, 
            child: Text(optionsTitle)
          );
        }).toList(),
      );
    }
  );
}