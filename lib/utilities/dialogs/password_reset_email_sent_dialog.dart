import 'package:flutter/material.dart';
import 'package:orbital_spa/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Password Reset', 
    content: 'An link to reset your password has been sent to your email. Please check your email', 
    optionsBuilder: () => {
      'OK': null
    }
  );
}