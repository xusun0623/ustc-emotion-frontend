import 'package:emotion/components/big_screen.dart';
import 'package:emotion/components/button.dart';
import 'package:emotion/components/color.dart';
import 'package:emotion/components/input.dart';
import 'package:emotion/components/scaffold.dart';
import 'package:emotion/util/mid_interface.dart';
import 'package:emotion/util/mid_provider.dart';
import 'package:emotion/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _editingUsernameController =
      TextEditingController();
  final TextEditingController _editingPasswordController =
      TextEditingController();

  String role = "管理员";

  int getRoleInt() {
    return role == "管理员"
        ? 1
        : role == "老师"
            ? 2
            : 3;
  }

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: myBackBtn(context),
        title: Text(
          "登录",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: em_white,
      body: Center(
        child: ResponsiveWidget(
          child: Column(
            children: [
              // Container(height: 50),
              MyInput(
                controller: _editingUsernameController,
                placeholder: "用户名",
              ),
              MyInput(
                controller: _editingPasswordController,
                placeholder: "密码",
                isPassword: true,
              ),
              Container(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoleSelector(
                        role: role,
                        change: (res) {
                          setState(() {
                            role = res;
                          });
                        }),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: MyButton(
                          txt: "登录",
                          tap: () async {
                            var res = await Api().login(
                              username: _editingUsernameController.text,
                              password: _editingPasswordController.text,
                              type: getRoleInt(),
                            );
                            try {
                              setStorage(
                                key: "token",
                                value: res["data"]["token"],
                              );
                              setStorage(
                                key: "role",
                                value: getRoleInt().toString(),
                              );
                              setStorage(
                                key: "head",
                                value: res["data"]["head"] ?? "",
                              );
                              if (!mounted) return;
                              Provider.of<RoleManager>(context, listen: false)
                                  .userInfo["head"] = res["data"]["head"] ?? "";
                              Provider.of<RoleManager>(context, listen: false)
                                  .setRole(getRoleInt());
                              showToast("登录成功");
                              Navigator.pop(context);
                            } catch (e) {
                              try {
                                showToast(res["msg"]);
                              } catch (e) {
                                showToast(e.toString());
                              }
                            }
                            print("$res");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleSelector extends StatefulWidget {
  String role;
  Function change;
  RoleSelector({
    super.key,
    required this.role,
    required this.change,
  });

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: (MediaQuery.of(context).size.width - MinusSpace(context)) * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: Color(0xFFEEEEEE),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: DropdownButtonFormField(
            itemHeight: 70,
            isExpanded: true,
            value: widget.role,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
            ),
            borderRadius: BorderRadius.circular(20),
            focusColor: Colors.white,
            elevation: 4,
            style: TextStyle(
              fontSize: 15,
              color: em_black,
            ),
            items: const [
              DropdownMenuItem(
                value: "管理员",
                child: Center(child: Text("管理员")),
              ),
              DropdownMenuItem(
                value: "老师",
                child: Center(child: Text("老师")),
              ),
              DropdownMenuItem(
                value: "学生",
                child: Center(child: Text("学生")),
              ),
            ],
            onChanged: ((value) {
              widget.change(value ?? "管理员");
            }),
          ),
        ),
      ),
    );
  }
}

class UserNameInput extends StatelessWidget {
  const UserNameInput({
    Key? key,
    required TextEditingController editingUsernameController,
  })  : _editingUsernameController = editingUsernameController,
        super(key: key);

  final TextEditingController _editingUsernameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: em_gray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _editingUsernameController,
        decoration: InputDecoration(
          hintText: "用户名",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
