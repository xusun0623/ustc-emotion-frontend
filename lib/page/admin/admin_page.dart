import 'package:cached_network_image/cached_network_image.dart';
import 'package:emotion/components/big_screen.dart';
import 'package:emotion/components/button.dart';
import 'package:emotion/components/color.dart';
import 'package:emotion/components/input.dart';
import 'package:emotion/components/modal.dart';
import 'package:emotion/components/show_pop.dart';
import 'package:emotion/page/login.dart';
import 'package:emotion/util/mid_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oktoast/oktoast.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with AutomaticKeepAliveClientMixin {
  List data = [];
  getAllUser() async {
    var res = await Api().getAllUser();
    try {
      setState(() {
        data = res["data"];
      });
    } catch (e) {
      print("$e");
    }
  }

  @override
  void initState() {
    getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...(data
            .map((e) => StudentInfoCard(
                  data: e,
                  refresh: () {
                    getAllUser();
                  },
                ))
            .toList()),
        Container(height: 50),
        MyButton(
          miniSize: true,
          txt: "新增用户",
          tap: () {
            showPop(context, [
              AddUserWidget(refresh: () {
                getAllUser();
              })
            ]);
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AddUserBtn extends StatefulWidget {
  Function tap;
  AddUserBtn({super.key, required this.tap});

  @override
  State<AddUserBtn> createState() => _AddUserBtnState();
}

class _AddUserBtnState extends State<AddUserBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tap();
      },
      child: Container(
        width: 250,
        height: 65,
        margin: EdgeInsets.only(top: 100),
        decoration: BoxDecoration(
          color: em_color_opa,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            "新增用户",
            style: TextStyle(
              color: em_color,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class StudentInfoCard extends StatefulWidget {
  Map data;
  Function refresh;
  StudentInfoCard({
    super.key,
    required this.data,
    required this.refresh,
  });

  @override
  State<StudentInfoCard> createState() => _StudentInfoCardState();
}

class _StudentInfoCardState extends State<StudentInfoCard> {
  bool editing = false;
  final TextEditingController _controller = TextEditingController();

  _confirmEditPassword() async {
    String new_password = _controller.text;
    if (new_password == "" || new_password.length < 5) {
      showToast(new_password == "" ? "请输入密码" : "密码长度请大于5");
      return;
    }
    var res = await Api().editUserInfo(
      type: 3,
      user_id: widget.data["id"],
      password: new_password,
    );
    try {
      if (res["code"] == 1) {
        showToast(res["msg"]);
      }
      setState(() {
        editing = false;
        Navigator.pop(context);
        _controller.text = "";
      });
    } catch (e) {
      try {
        showToast(res["msg"]);
      } catch (e) {}
    }
    ;
  }

  _deleteUser() async {
    await Api().deleteUser(type: 3, user_id: widget.data["id"]);
    widget.refresh();
    showToast("删除成功");
  }

  _editPassword() {
    showPop(context, [
      Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          "修改密码",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      MyInput(
        controller: _controller,
        placeholder: "请输入新的密码",
      ),
      Container(height: 30),
      MyButton(
        miniSize: true,
        txt: "确定",
        tap: () {
          _confirmEditPassword();
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (res) {
                _editPassword();
              },
              backgroundColor: Color(0xFF70d3a0),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: '改密',
            ),
            SlidableAction(
              onPressed: (res) {
                showModal(
                    context: context,
                    title: "请确认",
                    cont: "是否要删除此用户，该操作不可取消",
                    confirm: () {
                      _deleteUser();
                    });
              },
              backgroundColor: Color(0xFFed7868),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '删除',
            ),
          ],
        ),
        child: StudentInfoCont(
          data: widget.data,
        ),
      ),
    );
  }
}

class StudentInfoCont extends StatefulWidget {
  Map data;
  StudentInfoCont({super.key, required this.data});

  @override
  State<StudentInfoCont> createState() => _StudentInfoContState();
}

class _StudentInfoContState extends State<StudentInfoCont> {
  _editUserInfo() async {
    showPop(context, []);
  }

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: () {
        // _editUserInfo();
      },
      duration: Duration(milliseconds: 100),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 25, top: 20, bottom: 20),
        decoration: BoxDecoration(
          color: em_gray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.data["avatar"] ?? "",
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFCCCCCC),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 10),
                    Text(
                      widget.data["username"] ?? "",
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.data["number"] ?? "",
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 15,
                  ),
                )
              ],
            ),
            Container(height: 12.5),
            Container(
              child: Text(
                "${widget.data["school_class"] ?? "暂无专业"}   ${widget.data["major"] ?? "暂无班级"}",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddUserWidget extends StatefulWidget {
  Function refresh;
  AddUserWidget({
    super.key,
    required this.refresh,
  });

  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String role = "学生";

  int getRoleInt() {
    return role == "管理员"
        ? 1
        : role == "老师"
            ? 2
            : 3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              "新增用户",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ResponsiveWidget(
            child: MyInput(
              controller: _usernameController,
              placeholder: "账号",
            ),
          ),
          ResponsiveWidget(
            child: MyInput(
              controller: _passwordController,
              isPassword: true,
              placeholder: "密码",
            ),
          ),
          ResponsiveWidget(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  RoleSelector(
                      role: role,
                      change: (res) {
                        setState(() {
                          role = res;
                        });
                      }),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: MyButton(
                        txt: "新增用户",
                        tap: () async {
                          var res = await Api().addUser(
                            username: _usernameController.text,
                            password: _passwordController.text,
                            type: getRoleInt(),
                          );
                          try {
                            showToast(res["msg"]);
                            Navigator.pop(context);
                          } catch (e) {}
                          widget.refresh();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
