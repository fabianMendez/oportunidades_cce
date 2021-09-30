import 'package:equatable/equatable.dart';
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

Future<String?> showPrompt(
  BuildContext context, {
  required String title,
}) {
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

class Range extends Equatable {
  const Range({
    this.min = 0,
    this.max = 0,
  });

  final double min;
  final double max;

  bool get isValid => min <= max;
  bool get isNotValid => !isValid;

  @override
  List<Object?> get props => [min, max];
}

Future<Range?> showValueRangePrompt(BuildContext context,
    {required String title}) {
  Range range = const Range();

  return showDialog<Range?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            XTextField(
              value: '',
              label: 'Mínimo',
              autofocus: true,
              prefixIcon: const Icon(Icons.attach_money),
              onChanged: (value) {
                final min = double.tryParse(value);
                if (min != null) {
                  range = Range(
                    max: range.max,
                    min: min,
                  );
                }
              },
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.number,
            ),
            const SizedBox(height: 4),
            XTextField(
              value: '',
              label: 'Máximo',
              autofocus: true,
              prefixIcon: const Icon(Icons.attach_money),
              onChanged: (value) {
                final max = double.tryParse(value);
                if (max != null) {
                  range = Range(
                    min: range.min,
                    max: max,
                  );
                }
              },
              textInputType: TextInputType.number,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.of(context).pop(range);
                }
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () => Navigator.of(context).pop(range),
          ),
        ],
      );
    },
  );
}
