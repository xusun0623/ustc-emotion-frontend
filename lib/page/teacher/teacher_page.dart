import 'package:emotion/components/bar_chart.dart';
import 'package:emotion/components/big_screen.dart';
import 'package:emotion/components/color.dart';
import 'package:emotion/components/pie_chart.dart';
import 'package:emotion/util/mid_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => TeacherPageState();
}

class TeacherPageState extends State<TeacherPage> {
  var data;
  String download_url = "";

  getData() async {
    var res = await Api().getStatus(
      start_time: "2011-01-05 00:00",
      end_time: "2031-01-05 00:00",
    );
    setState(() {
      data = res["data"];
    });
    print("${res["data"]}");
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool showBarChart = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: data == null || data == ""
          ? Container()
          : Column(
              children: [
                TeacherInfoCard(data: data),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "展示为条形图",
                            style: TextStyle(
                              color: Color(0xFF666666),
                            ),
                          ),
                          Switch(
                            activeTrackColor: Color(0x3311B7CA),
                            activeColor: em_color,
                            value: showBarChart,
                            onChanged: (res) {
                              setState(() {
                                showBarChart = !showBarChart;
                              });
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          backgroundColor:
                              MaterialStateProperty.all(em_color_opa),
                          foregroundColor: MaterialStateProperty.all(em_color),
                        ),
                        onPressed: () async {
                          var res_tmp = await Api().exportExcel(
                            start_time: "2011-01-05 00:00",
                            end_time: "2031-01-05 00:00",
                          );
                          try {
                            Clipboard.setData(
                              ClipboardData(
                                text:
                                    "http://124.223.79.175:8080${res_tmp["data"]["download_url"]}",
                              ),
                            );
                            showToast("复制下载链接成功");
                          } catch (e) {}
                        },
                        child: Text("导出为Excel"),
                      ),
                    ],
                  ),
                ),
                (showBarChart
                    ? InfoBarChart(
                        numData: data["emoji_num"],
                      )
                    : InfoPieChart(
                        numData: data["emoji_num"],
                      )),
                Container(height: 200),
              ],
            ),
    );
  }
}

class TeacherInfoCard extends StatefulWidget {
  var data;
  TeacherInfoCard({
    super.key,
    required this.data,
  });

  @override
  State<TeacherInfoCard> createState() => _TeacherInfoCardState();
}

class _TeacherInfoCardState extends State<TeacherInfoCard> {
  @override
  Widget build(BuildContext context) {
    return widget.data == null
        ? Container()
        : Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            padding: EdgeInsets.only(
              left: 30,
              right: 0,
              top: 30,
              bottom: 30,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoSingle(
                      title: "学生总数",
                      tip: widget.data["total_num"].toString(),
                    ),
                    InfoSingle(
                      title: "平均分",
                      tip: widget.data["avg_score"].toString(),
                    ),
                    InfoSingle(
                      title: "方差",
                      tip: widget.data["var_score"].toString(),
                    ),
                  ],
                ),
                Container(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoSingle(
                      title: "开始",
                      tip: "10:50",
                    ),
                    InfoSingle(
                      title: "结束",
                      tip: "20:08",
                    ),
                    InfoSingle(
                      title: "",
                      tip: "",
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

class InfoSingle extends StatefulWidget {
  String title;
  String tip;
  InfoSingle({
    super.key,
    required this.title,
    required this.tip,
  });

  @override
  State<InfoSingle> createState() => _InfoSingleState();
}

class _InfoSingleState extends State<InfoSingle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          (MediaQuery.of(context).size.width - MinusSpace(context) - 100) / 3,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF555555),
                ),
              ),
            ),
            Container(
              width: 100,
              margin: EdgeInsets.only(top: 5),
              // color: em_color,
              child: Text(
                widget.tip,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
