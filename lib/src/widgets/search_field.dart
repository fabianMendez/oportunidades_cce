import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.onChanged,
    this.onSubmitted,
    required this.value,
  });

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String value;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
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
  void didUpdateWidget(covariant SearchField oldWidget) {
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
      autocorrect: false,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        label: const Text('Buscar'),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _controller.text.isEmpty ? const SizedBox() : child,
            );
          },
          child: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _onClearPressed,
          ),
        ),
      ),
      textInputAction: TextInputAction.search,
    );
  }
}
