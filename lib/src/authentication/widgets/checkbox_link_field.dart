import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CheckboxLinkField extends StatefulWidget {
  const CheckboxLinkField({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.prefixText,
    this.linkText,
    this.enabled,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;
  final String prefixText;
  final String? linkText;
  final bool? enabled;

  @override
  _CheckboxLinkFieldState createState() => _CheckboxLinkFieldState();
}

class _CheckboxLinkFieldState extends State<CheckboxLinkField> {
  bool hover = false;

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
              child: RichText(
                text: TextSpan(
                  text: widget.prefixText,
                  style: Theme.of(context).textTheme.bodyText2,
                  children: [
                    TextSpan(
                      text: widget.linkText,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            backgroundColor:
                                hover ? Theme.of(context).splashColor : null,
                          ),
                      onEnter: (_) {
                        setState(() {
                          hover = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          hover = false;
                        });
                      },
                      recognizer: TapGestureRecognizer()
                        ..onTapDown = (_) {
                          setState(() {
                            hover = true;
                          });
                        }
                        ..onTapUp = (_) {
                          setState(() {
                            hover = false;
                          });
                        }
                        ..onTap = () {
                          print('hello');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
