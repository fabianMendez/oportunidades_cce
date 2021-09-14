import 'package:flutter/material.dart';

Future<void> showMessage(BuildContext context,
    {required String title, required String message}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
