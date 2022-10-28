import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';

import 'color.dart';

class MyInputSelect extends StatefulWidget {
  List<String> placeholder;
  Function change;
  int index;
  bool? smallSize;
  MyInputSelect({
    super.key,
    required this.placeholder,
    required this.index,
    required this.change,
    this.smallSize,
  });

  @override
  State<MyInputSelect> createState() => _MyInputSelectState();
}

class _MyInputSelectState extends State<MyInputSelect> {
  String value = "点击选择";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      child: GestureDetector(
        onTap: () {
          showAdaptiveActionSheet(
            context: context,
            title: const Text('请选择您的性别'),
            androidBorderRadius: 30,
            actions: (widget.placeholder.map((e) {
              return BottomSheetAction(
                  title: Text(
                    e,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: (_) {
                    setState(() {
                      value = e;
                    });
                    widget.change(e);
                    Navigator.pop(context);
                  });
            }).toList()),
            cancelAction: CancelAction(
                title: const Text(
              '取消',
              style: TextStyle(
                fontSize: 16,
              ),
            )),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: (widget.smallSize ?? false) ? 17.5 : 27.5,
          ),
          decoration: BoxDecoration(
            color: em_gray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.index == 0 ? "女" : "男",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xaa000000),
            ),
          ),
        ),
      ),
    );
  }
}

class MyInput extends StatefulWidget {
  TextEditingController controller;
  bool? isPassword;
  bool? onlyNumber;
  bool? smallSize;
  String? placeholder;
  MyInput({
    super.key,
    required this.controller,
    this.placeholder,
    this.onlyNumber,
    this.isPassword,
    this.smallSize,
  });

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: TextField(
          keyboardType: (widget.onlyNumber ?? false)
              ? TextInputType.number
              : TextInputType.text,
          controller: widget.controller,
          obscureText: (widget.isPassword ?? false) ? !showPassword : false,
          cursorColor: em_color,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 25,
              vertical: (widget.smallSize ?? false) ? 20 : 30,
            ),
            fillColor: em_gray,
            filled: true,
            hintText: widget.placeholder,
            border: InputBorder.none,
            suffixIcon: (widget.isPassword ?? false)
                ? Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(
                        !showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFFBBBBBB),
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
