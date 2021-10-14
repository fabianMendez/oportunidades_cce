import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextLink extends StatefulWidget {
  const TextLink({
    Key? key,
    this.prefixText = '',
    this.linkText,
    this.onTap,
  }) : super(key: key);

  final String prefixText;
  final String? linkText;
  final GestureTapCallback? onTap;

  @override
  State<TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<TextLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return RichText(
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
                      _hover ? Theme.of(context).splashColor : null,
                ),
            onEnter: (_) {
              setState(() {
                _hover = true;
              });
            },
            onExit: (_) {
              setState(() {
                _hover = false;
              });
            },
            recognizer: TapGestureRecognizer()
              ..onTapDown = (_) {
                setState(() {
                  _hover = true;
                });
              }
              ..onTapUp = (_) {
                setState(() {
                  _hover = false;
                });
              }
              ..onTap = widget.onTap,
          ),
        ],
      ),
    );
  }
}
