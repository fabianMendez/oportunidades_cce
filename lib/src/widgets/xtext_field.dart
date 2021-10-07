import 'package:flutter/material.dart';

class XTextField extends StatefulWidget {
  const XTextField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    required this.value,
    this.autofocus = false,
    this.textInputAction,
    this.textInputType,
    this.label,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.enabled,
    this.autocorrect = false,
  }) : super(key: key);

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String value;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final String? label;
  final Widget? prefixIcon;
  final TextCapitalization textCapitalization;
  final bool? enabled;
  final bool autocorrect;

  @override
  State<XTextField> createState() => _XTextFieldState();
}

class _XTextFieldState extends State<XTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value)
      ..addListener(_onValueChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant XTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  void _onValueChanged() {
    if (widget.onChanged != null && widget.value != _controller.text) {
      widget.onChanged!(_controller.text);
    }
  }

  void _onClearPressed() {
    _controller.clear();

    if (widget.onSubmitted != null) {
      widget.onSubmitted!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autocorrect: widget.autocorrect,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        label: widget.label != null ? Text(widget.label!) : null,
        border: const OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Visibility(
              visible: widget.enabled != false && _controller.text.isNotEmpty,
              child: child!,
            );
            // return AnimatedSwitcher(
            //   duration: const Duration(milliseconds: 100),
            //   child: _controller.text.isEmpty ? const SizedBox() : child,
            // );
          },
          child: Focus(
            descendantsAreFocusable: false,
            skipTraversal: true,
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _onClearPressed,
            ),
          ),
        ),
      ),
      textInputAction: widget.textInputAction,
      keyboardType: widget.textInputType,
      textCapitalization: widget.textCapitalization,
      enabled: widget.enabled,
    );
  }
}
