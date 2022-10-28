import 'package:emotion/components/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class MyButton extends StatefulWidget {
  String txt;
  Function tap;
  bool? miniSize;
  Color? color;
  Color? fontColor;
  MyButton({
    super.key,
    required this.txt,
    required this.tap,
    this.miniSize,
    this.color,
    this.fontColor,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: () {
        if (widget.tap != null) {
          widget.tap();
        }
      },
      duration: Duration(milliseconds: 100),
      child: Container(
        height: widget.miniSize ?? false ? 45 : 70,
        width: widget.miniSize ?? false ? 100 : null,
        decoration: BoxDecoration(
          color: widget.color ?? em_color,
          borderRadius: widget.miniSize ?? false
              ? BorderRadius.circular(15)
              : BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            widget.txt,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: widget.fontColor ?? em_white,
            ),
          ),
        ),
      ),
    );
  }
}
