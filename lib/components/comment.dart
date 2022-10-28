import 'dart:async';
import 'dart:ui';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emotion/components/big_screen.dart';
import 'package:emotion/components/color.dart';
import 'package:emotion/components/niw.dart';
import 'package:emotion/components/photo_view.dart';
import 'package:emotion/components/relativetime.dart';
import 'package:emotion/components/toast.dart';
import 'package:emotion/util/mid_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({super.key});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection>
    with AutomaticKeepAliveClientMixin {
  List data = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = new FocusNode();
  final ScrollController _scrollController = ScrollController();
  late Timer timer;

  getData() async {
    var res = await Api().getComment();
    try {
      setState(() {
        data = res["data"];
      });
      // _scrollController.animateTo(rc
    } catch (e) {
      try {
        showToast(res["msg"]);
      } catch (e) {}
    }
  }

  _sendComment() async {
    if (_controller.text == "") {
      _focusNode.unfocus();
      return;
    }
    myToast(context: context, type: XSToast.loading, txt: "发送中…");
    var res = await Api().sendComment(
      cont: _controller.text,
      type: "text",
    );
    hideToast();
    await Future.delayed(Duration(milliseconds: 10));
    try {
      showToast(res["msg"]);
      _controller.text = "";
      _focusNode.unfocus();
      setState(() {});
      getData();
    } catch (e) {}
  }

  startGetData() async {
    getData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getData();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startGetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: data.isEmpty
              ? Center(
                  child: Text(
                    "加载中…",
                    style: TextStyle(color: Color(0xFF999999)),
                  ),
                )
              : ListView(
                  controller: _scrollController,
                  cacheExtent: 9999,
                  reverse: true,
                  children: [
                    ...(data
                        .map(
                          (e) => ResponsiveWidget(
                            child: CommentCard(
                              data: e,
                              refresh: () {
                                // getData();
                              },
                            ),
                          ),
                        )
                        .toList()),
                  ],
                ),
        ),
        Container(
          child: SendFunc(
            scrollController: _scrollController,
            focusNode: _focusNode,
            controller: _controller,
            sendComment: _sendComment,
            getData: getData,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SendFunc extends StatefulWidget {
  FocusNode focusNode;
  TextEditingController controller;
  ScrollController scrollController;
  Function sendComment;
  Function getData;
  SendFunc({
    super.key,
    required this.focusNode,
    required this.scrollController,
    required this.controller,
    required this.sendComment,
    required this.getData,
  });

  @override
  State<SendFunc> createState() => _SendFuncState();
}

class _SendFuncState extends State<SendFunc> {
  bool showBackToTop = false;

  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset > 3000 && !showBackToTop) {
        setState(() {
          showBackToTop = true;
        });
      } else if (widget.scrollController.offset < 3000 && showBackToTop) {
        setState(() {
          showBackToTop = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 25),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(100),
          border: Border(
            top: BorderSide(
              color: Color(0xFFE9E9E9),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          color: Color(0xFFF1F1F1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  onSubmitted: (res) {
                    widget.sendComment();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 17.5,
                      vertical: 15,
                    ),
                    border: InputBorder.none,
                    hintText: "说点什么吧…",
                    filled: true,
                    fillColor: em_white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: myInkWell(
                radius: 10,
                color: Colors.transparent,
                tap: () async {
                  String imageName = await Api().uploadImage();
                  if (imageName != "") {
                    myToast(
                      context: context,
                      type: XSToast.loading,
                      txt: "发送中…",
                    );
                    var res = await Api().sendComment(
                      cont: "http://oss.xusun000.top/emotion/$imageName",
                      type: "image",
                    );
                    hideToast();
                    await Future.delayed(Duration(milliseconds: 10));
                    try {
                      showToast(res["msg"]);
                      widget.getData();
                    } catch (e) {}
                  }
                },
                widget: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.image_outlined),
                ),
              ),
            ),
            myInkWell(
              radius: 10,
              color: Colors.transparent,
              tap: () async {
                if (showBackToTop) {
                  widget.scrollController.animateTo(0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                } else {
                  widget.sendComment();
                }
              },
              widget: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  showBackToTop ? Icons.arrow_downward : Icons.send,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentCard extends StatefulWidget {
  var data;
  Function refresh;
  CommentCard({
    super.key,
    required this.data,
    required this.refresh,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 15,
        right: 5,
        top: 15,
        bottom: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.data["is_mine"] == 1
              ? Container()
              : HeadImage(data: widget.data),
          TxtCont(data: widget.data),
          widget.data["is_mine"] == 1
              ? HeadImage(data: widget.data)
              : Container(),
        ],
      ),
    );
  }
}

class TxtCont extends StatefulWidget {
  var data;
  TxtCont({
    super.key,
    required this.data,
  });

  @override
  State<TxtCont> createState() => _TxtContState();
}

class _TxtContState extends State<TxtCont> {
  String getToxicStr(int type) {
    List<String> tmp = [
      "违规违禁",
      "低质灌水",
      "色情",
      "敏感信息",
      "恶意推广",
      "低俗辱骂",
      "恶意推广——联系方式",
      "恶意推广——软文推广"
    ];
    return tmp[type];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onLongPress: () {
          showAdaptiveActionSheet(
            context: context,
            title: const Text('操作'),
            androidBorderRadius: 30,
            actions: <BottomSheetAction>[
              BottomSheetAction(
                title: const Text(
                  '删除',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onPressed: (_) {
                  Navigator.pop(context);
                  showModal(
                    context: context,
                    title: "请确认",
                    cont: "是否要删除此用户，该操作不可取消",
                    confirm: () async {
                      var res = await Api()
                          .deleteComment(comment_id: widget.data["comment_id"]);
                      try {
                        showToast(res["msg"]);
                      } catch (e) {}
                    },
                  );
                },
              ),
              BottomSheetAction(
                title: const Text(
                  '复制内容',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onPressed: (_) {
                  Clipboard.setData(
                    ClipboardData(text: widget.data["cont"]),
                  );
                  Navigator.pop(context);
                  showToast(
                    "复制成功",
                    position: ToastPosition.center,
                  );
                },
              ),
            ],
            cancelAction: CancelAction(
                title: const Text(
              '取消',
              style: TextStyle(
                fontSize: 16,
              ),
            )),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: widget.data["is_mine"] == 1
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  widget.data["nick_name"] ?? "匿名用户",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777777),
                  ),
                ),
                Container(
                  width: widget.data["is_mine"] == 1 ? 10 : 0,
                ),
                widget.data["is_mine"] == 0
                    ? RoleTag(
                        type: widget.data["user_type"] == "admin"
                            ? 1
                            : widget.data["user_type"] == "teacher"
                                ? 2
                                : 3,
                      )
                    : Container(),
              ],
            ),
            Container(height: 3),
            widget.data["toxic_type"] == -1
                ? Container()
                : Container(
                    margin: EdgeInsets.only(right: 10, top: 7.5, bottom: 10),
                    child: Row(
                      mainAxisAlignment: widget.data["is_mine"] == 1
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0x15FF0000),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 210,
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                children: [
                                  TextSpan(
                                    text: "下面评论可能包含 ",
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                    text: getToxicStr(
                                      widget.data["toxic_type"],
                                    ),
                                  ),
                                  TextSpan(
                                    text: " 内容，请谨慎甄别",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Container(height: widget.data["is_mine"] == 1 ? 0 : 3),
            widget.data["comment_type"] == "text"
                ? Row(
                    mainAxisAlignment: widget.data["is_mine"] == 1
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        // width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        margin: EdgeInsets.only(
                          right: widget.data["is_mine"] == 1 ? 10 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: widget.data["is_mine"] == 1
                              ? em_color
                              : Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(
                                widget.data["is_mine"] == 1 ? 0 : 10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(
                                widget.data["is_mine"] == 1 ? 10 : 0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width -
                                    MinusSpace(context) -
                                    180,
                              ),
                              child: Text(
                                widget.data["cont"] ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: widget.data["is_mine"] == 1
                                      ? em_white
                                      : em_black,
                                ),
                              ),
                            ),
                            Container(height: 5),
                            Text(
                              RelativeDateFormat.format(DateTime.parse(
                                widget.data["time"].toString().substring(0, 19),
                              )),
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.data["is_mine"] == 1
                                    ? Color(0x99FFFFFF)
                                    : Color(0xFFAAAAAA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: widget.data["is_mine"] == 1
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 175,
                        height: 283,
                        margin: EdgeInsets.only(
                          right: widget.data["is_mine"] == 1 ? 10 : 0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PhotoPreview(
                                    galleryItems: [widget.data["cont"]],
                                    commentId:
                                        widget.data["comment_id"].toString(),
                                    defaultImage: 0,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: widget.data["cont"] +
                                  widget.data["comment_id"].toString(),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: widget.data["cont"],
                                placeholder: (context, url) {
                                  return Container(
                                    height: 283,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class RoleTag extends StatefulWidget {
  int type = 1; //1-管理员 2-老师 3-学生
  RoleTag({
    super.key,
    required this.type,
  });

  @override
  State<RoleTag> createState() => _RoleTagState();
}

class _RoleTagState extends State<RoleTag> {
  @override
  Widget build(BuildContext context) {
    return widget.type == 3
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: em_color_opa,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              widget.type == 1 ? "管理员" : "老师",
              style: TextStyle(
                color: em_color,
                fontSize: 12,
              ),
            ),
          );
  }
}

class HeadImage extends StatefulWidget {
  var data;
  HeadImage({
    super.key,
    required this.data,
  });

  @override
  State<HeadImage> createState() => _HeadImageState();
}

class _HeadImageState extends State<HeadImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          width: 44,
          height: 44,
          imageUrl: widget.data["user_avatar"].toString(),
          errorWidget: (context, url, error) => Container(
            width: 44,
            height: 44,
            child: Icon(
              Icons.person,
              size: 25,
              color: Color(0xFF444444),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFDDDDDD),
            ),
          ),
        ),
      ),
    );
  }
}
