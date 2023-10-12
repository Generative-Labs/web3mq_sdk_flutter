import 'package:flutter/material.dart';

class AlertUtils {
  static final _textController = TextEditingController();

  static Future<String?> showAlert(
      String title, String placeholder, BuildContext context) async {
    // tap button and return the result
    return await showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          key: UniqueKey(),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: placeholder),
                  controller: _textController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
                _textController.clear();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                final text = _textController.text;
                // return the text
                Navigator.of(context).pop(text);
                _textController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
