import 'package:emotion/components/color.dart';
import 'package:flutter/material.dart';

showPop(BuildContext context, List<Widget> cont) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: em_white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: cont,
        ),
      );
    },
  );
}
