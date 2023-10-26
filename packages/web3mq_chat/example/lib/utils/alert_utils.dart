import 'package:flutter/material.dart';

class AlertUtils {
  static final _textController = TextEditingController();

  ///
  static Future<String?> showTextField(
      String? title, String? body, String placeholder, BuildContext context,
      {bool security = false}) async {
    // tap button and return the result
    return await showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          key: UniqueKey(),
          title: title != null ? Text(title) : null,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                body != null ? Text(body) : Container(),
                TextField(
                  obscureText: security,
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

  static showText(String? message, BuildContext buildContext) {
    AlertDialog alertDialog = AlertDialog(
      content: message != null ? Text(message) : null,
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

  static showLoading(BuildContext context, {String? text}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.grey[100],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 8,
                ),
                text != null ? Text(text) : Container()
              ],
            ));
      },
    );
  }

  static hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
