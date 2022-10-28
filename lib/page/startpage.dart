import 'package:emotion/util/mid_provider.dart';
import 'package:emotion/util/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  getRole() async {
    String roleTxt = await getStorage(key: "role", initData: "");
    String head = await getStorage(key: "head", initData: "");
    if (roleTxt != "") {
      if (!mounted) return;
      Provider.of<RoleManager>(context, listen: false).userInfo["head"] = head;
      Provider.of<RoleManager>(context, listen: false)
          .setRole(int.parse(roleTxt));
    }
  }

  @override
  void initState() {
    getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              "lib/assets/start.svg",
              width: 400,
              height: 400,
              semanticsLabel: 'Acme Logo',
            ),
          ),
          Center(
            child: Text(
              "Python课程设计",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(height: 10),
          Center(
            child: Text(
              "在线聊天室聊天自动检测系统",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Container(height: 100),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => Home(),
              ));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF11B7CA)),
              foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Text(
                "点击进入",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Container(height: 50),
          Center(
            child: Text(
              "- 2022 秋&冬 Python课程 -",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF444444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
