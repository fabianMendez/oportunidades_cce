import 'package:flutter/material.dart';

class DropdownInput<T> extends StatelessWidget {
  const DropdownInput({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.error,
    required this.hintText,
    bool? touched,
    bool? disabled,
    this.required = false,
  })  : touched = touched ?? false,
        disabled = disabled ?? false,
        super(key: key);

  final T? value;
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;
  final String? error;
  final bool touched;
  final bool disabled;
  final String hintText;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color color = disabled
        ? const Color(0xFFCCCCCC)
        : touched && !disabled
            ? error == null
                ? theme.primaryColor
                : const Color(0xCCFF0018)
            : const Color(0xFF8A8D90);

    final List<DropdownMenuItem<T>> menuItems = items.keys.map((T key) {
      return DropdownMenuItem<T>(
        value: key,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          child: Text(items[key]!),
        ),
      );
    }).toList();

    if (!required && value != null && value != '' && menuItems.isNotEmpty) {
      menuItems.insert(
          0,
          DropdownMenuItem<T>(
            value: null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: const Text('-'),
            ),
          ));
    }

    const EdgeInsetsGeometry padding = EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 4,
    );

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        items: menuItems,
        underline: Container(),
        isExpanded: true,
        hint: Container(
          padding: padding,
          child: Text(hintText),
        ),
      ),
    );
  }
}
