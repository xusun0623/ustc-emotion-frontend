import 'package:emotion/components/color.dart';
import 'package:emotion/components/comment.dart';
import 'package:emotion/components/scaffold.dart';
import 'package:emotion/page/home.dart';
import 'package:emotion/util/mid_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: myBackBtn(context),
        actions: [
          UserHead(
            provider: Provider.of<RoleManager>(context),
          ),
        ],
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "评论区",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Color(0xFFF1F1F1),
      body: CommentSection(),
    );
  }
}
