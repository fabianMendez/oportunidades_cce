import 'package:flutter/material.dart';

class DropdownField<T> extends StatelessWidget {
  const DropdownField({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.error,
    required this.hintText,
    this.touched = false,
    this.enabled = true,
    this.required = false,
    this.isDense = true,
  }) : super(key: key);

  final T? value;
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;
  final String? error;
  final bool touched;
  final bool enabled;
  final String hintText;
  final bool required;
  final bool isDense;

  InputDecoration _getEffectiveDecoration(
      BuildContext context, InputDecoration decoration) {
    // final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final InputDecoration effectiveDecoration =
        decoration.applyDefaults(themeData.inputDecorationTheme).copyWith(
              enabled: enabled,
            );

    return effectiveDecoration;
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<T>> menuItems = items.keys.map((T key) {
      return DropdownMenuItem<T>(
        value: key,
        child: Text(items[key]!),
      );
    }).toList();

    if (!required && value != null && value != '' && menuItems.isNotEmpty) {
      menuItems.insert(
        0,
        DropdownMenuItem<T>(value: null, child: const Text('-')),
      );
    }

    final decoration = _getEffectiveDecoration(
      context,
      const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );

    return InputDecorator(
      decoration: decoration,
      child: DropdownButton<T>(
        value: value,
        onChanged: enabled ? onChanged : null,
        items: menuItems,
        underline: Container(),
        isExpanded: true,
        isDense: isDense,
        hint: Text(hintText),
      ),
    );
  }
}
