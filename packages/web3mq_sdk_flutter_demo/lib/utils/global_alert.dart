import 'package:flutter/material.dart';

///
class GlobalAlertDialog {
  static showAlertDialog(BuildContext context, String message) {
    AlertDialog alertDialog = AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('close'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}
