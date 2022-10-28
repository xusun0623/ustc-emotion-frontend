import 'package:cached_network_image/cached_network_image.dart';
import 'package:emotion/components/big_screen.dart';
import 'package:emotion/components/color.dart';
import 'package:emotion/components/scaffold.dart';
import 'package:emotion/page/admin/admin_page.dart';
import 'package:emotion/page/comment/comment_page.dart';
import 'package:emotion/page/login.dart';
import 'package:emotion/page/person/person.dart';
import 'package:emotion/page/student/student_page.dart';
import 'package:emotion/page/teacher/teacher_page.dart';
import 'package:emotion/util/mid_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<TeacherPageState> teacherPageStateKey = GlobalKey();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RoleManager provider = Provider.of<RoleManager>(context);

    void functionCallback() {}
    return Scaffold(
      appBar: AppBar(
        leading: myBackBtn(context),
        actions: [
          CommentBtn(),
          RoleButton(provider: provider),
          UserHead(provider: provider),
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          return await teacherPageStateKey.currentState?.getData();
        },
        child: SingleChildScrollView(
          child: [
            ResponsiveWidget(child: LogoutPage()),
            ResponsiveWidget(child: AdminPage()),
            ResponsiveWidget(
              child: TeacherPage(
                key: teacherPageStateKey,
              ),
            ),
            ResponsiveWidget(child: StudentPage()),
          ][provider.role],
        ),
      ),
    );
  }
}

class CommentBtn extends StatefulWidget {
  const CommentBtn({super.key});

  @override
  State<CommentBtn> createState() => _CommentBtnState();
}

class _CommentBtnState extends State<CommentBtn> {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(16, 0),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => CommentPage(),
          ));
        },
        icon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(
              color: em_gray,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Icon(
              Icons.mode_comment_outlined,
              color: Color(0xFF555555),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class RoleButton extends StatelessWidget {
  const RoleButton({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final RoleManager provider;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(8, 0),
      child: IconButton(
        onPressed: () {
          if (provider.role != 0) {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => PersonCenter(),
            ));
          } else {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => Login(),
            ));
          }
        },
        icon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(
              color: em_gray,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Text(
                  ["未登录", "管理员", "老师", "学生"][provider.role],
                  style: TextStyle(
                    color: Color(0xFF555555),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserHead extends StatelessWidget {
  RoleManager provider;
  UserHead({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (provider.role != 0) {
          Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => PersonCenter(),
          ));
        } else {
          Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => Login(),
          ));
        }
      },
      icon: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 30,
          maxHeight: 30,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: CachedNetworkImage(
            imageUrl: Provider.of<RoleManager>(context).userInfo["head"],
            errorWidget: (context, url, error) {
              return Container(
                height: 100,
                width: 30,
                color: em_color_opa,
                child: Center(
                  child: Icon(
                    Icons.person_outline,
                    size: 20,
                    color: em_color,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
