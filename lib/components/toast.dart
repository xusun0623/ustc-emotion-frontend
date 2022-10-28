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

var isShown = false;
BuildContext? context_tmp;

enum XSToast {
  loading,
  success,
  done,
  none,
}

void hideToast() {
  if (isShown) {
    isShown = false;
    Navigator.pop(context_tmp!);
  }
}

void myToast({
  required BuildContext context,
  required XSToast type,
  String? txt,
  int? duration,
}) {
  if (isShown) return;
  isShown = true;
  if (type == XSToast.none) {
    popDialogNoWill(
      delay: duration ?? 1500,
      context: context,
      widget: Container(
        // padding: EdgeInsets.all(30),
        width: 240,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xBB000000),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                txt ?? "加载中…",
                textAlign: TextAlign.center,
                style: TextStyle(color: em_white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  if (type == XSToast.loading) {
    popDialog(
      delay: duration ?? 3000,
      context: context,
      widget: Container(
        padding: EdgeInsets.all(30),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xBB000000),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: em_white, strokeWidth: 4),
            Container(height: 20),
            Container(
              child: Text(txt ?? "加载中…", style: TextStyle(color: em_white)),
            ),
          ],
        ),
      ),
    );
  }
  if (type == XSToast.success) {
    popDialogNoWill(
      delay: duration ?? 700,
      context: context,
      widget: Container(
        padding: EdgeInsets.all(30),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xBB000000),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.done,
              color: em_white,
              size: 50,
            ),
            Container(height: 20),
            Text(txt ?? "完成", style: TextStyle(color: em_white)),
          ],
        ),
      ),
    );
  }
}

void popDialogNoWill({
  required BuildContext context,
  required Widget widget,
  int delay = 600,
  Color back = Colors.black38,
}) {
  context_tmp = context;
  showDialog(
    context: context,
    barrierColor: back,
    barrierDismissible: false,
    builder: (ctx) {
      return Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(bottom: 150),
          child: Container(child: Center(child: widget)),
        ),
      );
    },
  );
  Future.delayed(Duration(milliseconds: delay)).then((value) {
    if (!isShown) return; //已经取消弹窗了
    isShown = false;
    Navigator.pop(context);
  });
}

void popDialog({
  required BuildContext context,
  required Widget widget,
  int delay = 600,
  Color back = Colors.black38,
}) {
  context_tmp = context;
  showDialog(
    context: context,
    barrierColor: back,
    barrierDismissible: false,
    builder: (ctx) {
      return Material(
        color: Colors.transparent,
        child: WillPopScope(
          //阻止用户返回
          onWillPop: () async {
            return await Future.delayed(Duration(milliseconds: 0));
          },
          child: Container(
            color: Colors.transparent,
            margin: EdgeInsets.only(bottom: 150),
            child: Container(child: Center(child: widget)),
          ),
        ),
      );
    },
  );
  Future.delayed(Duration(milliseconds: delay)).then((value) {
    if (!isShown) return; //已经取消弹窗了
    isShown = false;
    Navigator.pop(context);
  });
}
