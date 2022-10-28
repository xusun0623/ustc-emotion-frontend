import 'package:emotion/components/big_screen.dart';
import 'package:emotion/components/color.dart';
import 'package:emotion/components/toast.dart';
import 'package:emotion/util/mid_interface.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  bool changing = false;
  int select = 0;
  List<String> emojis = ["🥰", "😋", "🤤", "😅", "🥵", "🤡"];

  int getStatusIndex(String s) {
    switch (s) {
      case "🥰":
        return 0;
      case "😋":
        return 1;
      case "🤤":
        return 2;
      case "😅":
        return 3;
      case "🥵":
        return 4;
      case "🤡":
        return 5;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "请设置状态：",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: emojis
                .map((e) => Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              select = getStatusIndex(e);
                              changing = true;
                            });
                          },
                          icon: Text(
                            e,
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 22,
                          child: Transform.translate(
                            offset: Offset(0, 5),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: getStatusIndex(e) == select
                                    ? em_color
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          child: Row(
            children: [
              Opacity(
                opacity: changing ? 1 : 0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(em_color),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    myToast(
                      context: context,
                      type: XSToast.loading,
                      txt: "请稍后…",
                    );
                    var res = await Api().setStatus(type: select + 1);
                    hideToast();
                    try {
                      showToast(
                        "设置成功！",
                        position: ToastPosition.center,
                      );
                    } catch (e) {}
                    setState(() {
                      changing = false;
                    });
                  },
                  child: Row(
                    children: [
                      Text("确认设置"),
                    ],
                  ),
                ),
              ),
              Container(width: 10),
              Opacity(
                opacity: changing ? 1 : 0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(em_color_opa),
                    foregroundColor: MaterialStateProperty.all(em_color),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () async {
                    setState(() {
                      changing = false;
                    });
                  },
                  child: Text("取消"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
