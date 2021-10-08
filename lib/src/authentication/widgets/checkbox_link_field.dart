import 'package:flutter/material.dart';

class CheckboxField extends StatefulWidget {
  const CheckboxField({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.child,
    this.enabled,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;
  final bool? enabled;

  @override
  _CheckboxFieldState createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  void onChanged() {
    if (widget.enabled != false) {
      widget.onChanged(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.value,
          onChanged: widget.enabled == false ? null : (_) => onChanged(),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onChanged,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: widget.child,
            ),
          ),
        )
      ],
    );
  }
}
