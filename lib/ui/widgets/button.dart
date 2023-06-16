import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.loadingStream,
    this.height = 40.0,
  });
  final String text;
  final void Function()? onPressed;
  final Stream<bool?>? loadingStream;
  final Color? color;
  final Color? textColor;

  final double height;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: loadingStream != null
            ? StreamBuilder<bool?>(
                stream: loadingStream,
                builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                  return (snapshot.hasData && snapshot.data!)
                      ? SizedBox(
                          height: height - 10,
                          width: height - 10,
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : _textWidget;
                },
              )
            : _textWidget,
      ),
    );
  }

  Text get _textWidget => Text(
        text,
        style: TextStyle(color: textColor ?? Colors.white),
      );
}
