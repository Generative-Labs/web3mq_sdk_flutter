import 'package:flutter/material.dart';

class AlertUtils {
  static final _textController = TextEditingController();

  ///
  static Future<String?> showTextField(
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

  static showText(String message, BuildContext buildContext) {
    AlertDialog alertDialog = AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('close'),
          onPressed: () {
            Navigator.pop(buildContext);
          },
        ),
      ],
    );
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  static showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator()],
            ));
      },
    );
  }

  static hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
