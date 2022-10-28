import 'package:emotion/components/color.dart';
import 'package:emotion/components/niw.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showModal({
  required BuildContext context,
  String? title,
  String? cont,
  String? confirmTxt,
  String? cancelTxt,
  Function? confirm,
  Function? cancel,
}) {
  AlertDialog alert = AlertDialog(
    backgroundColor: em_white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    title: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: Text(
          title ?? "标题",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: em_black,
          ),
        ),
      ),
    ),
    content: Text(
      cont ?? "内容",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: em_black,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cancelTxt == ""
                ? Container()
                : myInkWell(
                    color: Colors.transparent,
                    widget: Container(
                      width: 130,
                      height: 50,
                      child: Center(
                        child: Text(
                          cancelTxt ?? "取消",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: em_black,
                          ),
                        ),
                      ),
                    ),
                    radius: 10,
                    tap: () {
                      Navigator.pop(context);
                      if (cancel != null) cancel();
                    },
                  ),
            myInkWell(
              color: em_color_opa,
              widget: Container(
                width: cancelTxt == "" ? 260 : 130,
                height: 50,
                child: Center(
                  child: Text(
                    confirmTxt ?? "确认",
                    style: TextStyle(
                      color: em_color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              radius: 10,
              tap: () {
                Navigator.pop(context);
                if (confirm != null) confirm();
              },
            ),
          ],
        ),
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
