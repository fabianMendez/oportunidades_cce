import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/widgets/xtext_field.dart';

class MultiTextField extends StatelessWidget {
  const MultiTextField({
    Key? key,
    required this.values,
    required this.onChanged,
  }) : super(key: key);

  final List<String> values;
  final ValueChanged<List<String>> onChanged;

  List<T> replaceAt<T>(List<T> list, int index, T newValue) {
    final copy = List<T>.from(list);
    copy[index] = newValue;
    return copy;
  }

  List<T> removeAt<T>(List<T> list, int index) {
    final copy = List<T>.from(list);
    copy.removeAt(index);
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < values.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: XTextField(
                    value: values[i],
                    onSubmitted: (value) {
                      final newValues = replaceAt(values, i, value);
                      onChanged(newValues);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    final newValues = removeAt(values, i);
                    onChanged(newValues);
                  },
                ),
              ],
            ),
          ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            final newValues = values.followedBy(['']).toList();
            onChanged(newValues);
          },
        ),
      ],
    );
  }
}
