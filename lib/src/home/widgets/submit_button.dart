import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    this.child,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool isLoading;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (!isLoading) {
            onPressed();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: isLoading
              ? const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    backgroundColor: Colors.white,
                  ),
                )
              : DefaultTextStyle.merge(
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  child: child ?? const Text('ACEPTAR'),
                ),
        ),
      ),
    );
  }
}
