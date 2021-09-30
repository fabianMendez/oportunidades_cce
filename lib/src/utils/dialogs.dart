import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/widgets/xtext_field.dart';

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

Future<String?> showPrompt(BuildContext context,
    {required String title, required String message}) {
  String value = '';
  return showDialog<String?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: XTextField(
          value: value,
          autofocus: true,
          onChanged: (newValue) {
            value = newValue;
          },
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () => Navigator.of(context).pop(value),
          ),
        ],
      );
    },
  );
}
