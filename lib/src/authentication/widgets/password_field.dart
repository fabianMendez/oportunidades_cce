import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    this.enabled,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
  }) : super(key: key);

  final bool? enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: const Text('Contraseña'),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: obscureText
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
          tooltip: obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
        ),
      ),
      onChanged: widget.onChanged,
      keyboardType: obscureText ? null : TextInputType.visiblePassword,
      autocorrect: false,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
    );
  }
}
