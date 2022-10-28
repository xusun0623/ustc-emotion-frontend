import 'package:flutter/material.dart';

Widget myBackBtn(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: Icon(Icons.chevron_left_rounded),
  );
}
