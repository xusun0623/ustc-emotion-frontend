import 'package:flutter/material.dart';

const BigWidthScreen = 600;

///用于计算由于转为大屏幕模式损失了多少横向空间
double MinusSpace(BuildContext context) {
  return MediaQuery.of(context).size.width < BigWidthScreen
      ? 0
      : MediaQuery.of(context).size.width - BigWidthScreen;
}

///主页适配大屏幕，主要是针对帖子专栏进行适配
class ResponsiveWidget extends StatefulWidget {
  Widget child;
  ResponsiveWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ResponsiveWidget> createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<ResponsiveWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: (MediaQuery.of(context).size.width - BigWidthScreen) / 2 > 0
            ? (MediaQuery.of(context).size.width - BigWidthScreen) / 2
            : 0,
      ),
      child: widget.child,
    );
  }
}
