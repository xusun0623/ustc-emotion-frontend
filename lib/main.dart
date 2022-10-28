import 'dart:io';

import 'package:emotion/components/color.dart';
import 'package:emotion/page/startpage.dart';
import 'package:emotion/util/mid_provider.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Widget 组件
      providers: [
        ChangeNotifierProvider(create: (context) => RoleManager()),
      ],
      child: OKToast(
        position: ToastPosition.top,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: "PingFang",
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              surfaceTintColor: Colors.white,
            ),
            primaryColor: em_color,
          ),
          home: const Material(child: StartPage()),
        ),
      ),
    );
  }
}
