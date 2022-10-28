import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:emotion/components/button.dart';
import 'package:emotion/components/color.dart';
import 'package:emotion/components/input.dart';
import 'package:emotion/components/modal.dart';
import 'package:emotion/components/scaffold.dart';
import 'package:emotion/page/crop/crop.dart';
import 'package:emotion/util/mid_interface.dart';
import 'package:emotion/util/mid_provider.dart';
import 'package:emotion/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class PersonCenter extends StatefulWidget {
  const PersonCenter({super.key});

  @override
  State<PersonCenter> createState() => _PersonCenterState();
}

class _PersonCenterState extends State<PersonCenter> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  getData() async {
    var res = await Api().getUserInfo();
    setStorage(key: "head", value: res["msg"]["avatar"]);
    Provider.of<RoleManager>(context, listen: false).userInfo["head"] =
        res["msg"]["avatar"];
    Provider.of<RoleManager>(context, listen: false).refresh();
    setState(() {
      nicknameController.text = res["msg"]["nickname"];
      ageController.text = res["msg"]["age"].toString();
      genderController.text = res["msg"]["gender"] == 0 ? "女" : "男";
      phoneController.text = res["msg"]["phone"].toString();
    });
    print("$res");
  }

  submit() async {
    String nickname = nicknameController.text;
    String age = ageController.text;
    String gender = genderController.text;
    String phone = phoneController.text;
    var res = await Api().editUserInfo(
      nickname: nickname,
      age: age,
      gender: gender == "男" ? 1 : 0,
      phone: phone,
    );
    showToast(res["msg"]);
    await Future.delayed(Duration(milliseconds: 200));
    Navigator.pop(context);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: myBackBtn(context),
        actions: [
          IconButton(
            onPressed: () {
              showModal(
                context: context,
                title: "请确认",
                cont: "是否将要退出登录?",
                confirm: () {
                  setStorage(key: "token", value: "");
                  setStorage(key: "role", value: "");
                  Provider.of<RoleManager>(context, listen: false).logout();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
            icon: Row(
              children: [
                Text(
                  "退出登录",
                  style: TextStyle(
                    color: Color(0x77000000),
                  ),
                ),
                Container(width: 10),
                Icon(
                  Icons.logout,
                  size: 18,
                  color: Color(0x77000000),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: em_white,
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return CropImg();
                    },
                  ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl:
                        Provider.of<RoleManager>(context).userInfo["head"],
                    width: 80,
                    height: 80,
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: em_color_opa,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: em_color,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          UserNameInput(
            textController: nicknameController,
            placeholder: "用户昵称",
          ),
          UserNameInput(
            textController: ageController,
            placeholder: "年龄",
          ),
          UserNameInput(
            textController: genderController,
            placeholder: "性别",
          ),
          UserNameInput(
            textController: phoneController,
            placeholder: "电话号码",
          ),
          Container(height: 50),
          Center(
            child: MyButton(
              txt: "修改信息",
              tap: () {
                submit();
              },
              miniSize: true,
            ),
          ),
          Container(height: 50),
        ],
      ),
    );
  }
}

class UserNameInput extends StatefulWidget {
  final TextEditingController textController;
  final String placeholder;
  UserNameInput({
    super.key,
    required this.textController,
    required this.placeholder,
  });

  @override
  State<UserNameInput> createState() => _UserNameInputState();
}

class _UserNameInputState extends State<UserNameInput> {
  Icon getIcon() {
    if (widget.placeholder == "用户昵称") {
      return Icon(Icons.person_outline);
    }
    if (widget.placeholder == "年龄") {
      return Icon(Icons.calendar_today_outlined);
    }
    if (widget.placeholder == "性别") {
      return Icon(Icons.face_unlock_outlined);
    }
    if (widget.placeholder == "电话号码") {
      return Icon(Icons.phone_android);
    }
    return Icon(Icons.emoji_emotions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 10),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 35),
          iconColor: em_color,
          title: Row(
            children: [
              getIcon(),
              Container(width: 10),
              Text(widget.placeholder),
            ],
          ),
        ),
        widget.placeholder == "性别"
            ? MyInputSelect(
                smallSize: true,
                index: widget.textController.text == "女" ? 0 : 1,
                change: (res) {
                  setState(() {
                    widget.textController.text = res;
                  });
                },
                placeholder: [
                  "女",
                  "男",
                ],
              )
            : Container(),
        widget.placeholder == "性别"
            ? Container()
            : MyInput(
                smallSize: true,
                onlyNumber: widget.placeholder == "年龄" ? true : false,
                controller: widget.textController,
                placeholder: "请输入",
              ),
      ],
    );
  }
}
