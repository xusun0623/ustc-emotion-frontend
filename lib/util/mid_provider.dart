import 'package:flutter/material.dart';

class RoleManager extends ChangeNotifier {
  int role = 0; // 0-未登录 1-管理员 2-老师 3-学生
  Map userInfo = {
    "head":
        "https://img0.baidu.com/it/u=3512920656,1363147042&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
  };

  logout() {
    role = 0;
    userInfo = {"head": ""};
    refresh();
  }

  refresh() {
    notifyListeners();
  }

  setRole(int idx) {
    role = idx;
    refresh();
  }
}
