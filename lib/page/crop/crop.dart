import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:dio/dio.dart';
import 'package:emotion/components/button.dart';
import 'package:emotion/components/color.dart';
import 'package:emotion/util/mid_interface.dart';
import 'package:emotion/util/mid_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:http_parser/http_parser.dart';
import "package:image/image.dart" as IMG;
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CropImg extends StatefulWidget {
  const CropImg({Key? key}) : super(key: key);

  @override
  _CropImgState createState() => _CropImgState();
}

class _CropImgState extends State<CropImg> {
  final _controller = CropController();
  Uint8List? img;
  bool edit_done = false;

  _pickImg() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      img = await File(result.files.single.path!).readAsBytes();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: em_white,
        foregroundColor: em_black,
        title: Text(edit_done ? "" : "上传新头像", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
      ),
      backgroundColor: em_white,
      body: edit_done
          ? EditDoneDisplay()
          : ListView(
              physics: BouncingScrollPhysics(),
              children: [
                img == null
                    ? Bounce(
                        onPressed: () {
                          _pickImg();
                        },
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          height: MediaQuery.of(context).size.width - 40,
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: em_gray,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_size_select_actual_rounded,
                                  color: em_black,
                                ),
                                Container(width: 10),
                                Text(
                                  "点此选择您的新头像",
                                  style: TextStyle(
                                    color: em_black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.black.withAlpha(150),
                        child: Container(
                          height: MediaQuery.of(context).size.width,
                          child: Material(
                            child: Crop(
                              controller: _controller,
                              image: img!,
                              onCropped: (image) async {
                                IMG.Image img = IMG.decodeImage(image)!;
                                List<int> resizedData200 = IMG.encodeJpg(IMG
                                    .copyResize(img, width: 200, height: 200));
                                Uint8List imageByte =
                                    Uint8List.fromList(resizedData200);
                                var tempDir = await getTemporaryDirectory();
                                var file = await File(
                                  '${tempDir.path}/image_${DateTime.now().millisecond}.jpg',
                                ).create();
                                file.writeAsBytesSync(imageByte);

                                var dio = Dio();
                                var resParam = await Api().getUploadparam();
                                var formData = FormData.fromMap({
                                  'OSSAccessKeyId': resParam["data"]
                                      ["accessid"],
                                  'policy': resParam["data"]["policy"],
                                  'signature': resParam["data"]["signature"],
                                  'key':
                                      'emotion/${generateMD5(file.path)}.jpg',
                                  'file': await MultipartFile.fromFile(
                                    file.path,
                                    filename: file.path.split(
                                        "/")[file.path.split("/").length - 1],
                                    contentType: MediaType("image", "jpg"),
                                  )
                                });
                                var response = await dio.post(
                                  'http://ustc-train.oss-cn-hangzhou.aliyuncs.com',
                                  data: formData,
                                );
                                if (response.statusCode! >= 200 &&
                                    response.statusCode! < 300) {
                                  String head_url =
                                      "http://oss.xusun000.top/emotion/${generateMD5(file.path)}.jpg";
                                  var res = await Api().editAvatar(head_url);
                                  showToast(res["msg"]);
                                  Future.delayed(Duration(milliseconds: 200));
                                  Provider.of<RoleManager>(context,
                                          listen: false)
                                      .userInfo["head"] = head_url;
                                  Provider.of<RoleManager>(context,
                                          listen: false)
                                      .refresh();
                                  Navigator.pop(context);
                                }
                              },
                              radius: 15,
                              aspectRatio: 1,
                              maskColor: Colors.black.withAlpha(150),
                              cornerDotBuilder: (size, edgeAlignment) =>
                                  const DotControl(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                Container(height: 20),
                Center(
                  child: MyButton(
                    miniSize: true,
                    tap: () {
                      showToast("努力上传中…");
                      _controller.crop();
                    },
                    txt: "完成",
                  ),
                ),
                Container(height: 10),
                Center(
                  child: MyButton(
                    color: em_color_opa,
                    fontColor: em_color,
                    miniSize: true,
                    tap: () {
                      setState(() {
                        img = null;
                      });
                      _pickImg();
                    },
                    txt: "重新选择",
                  ),
                ),
                Container(height: 20),
              ],
            ),
    );
  }
}

class EditDoneDisplay extends StatelessWidget {
  const EditDoneDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.done,
            size: 50,
            color: em_color,
          ),
          Container(height: 10),
          Text(
            "上传头像成功",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Container(height: 10),
          Container(
            width: 300,
            child: Text(
              "您已成功上传新的头像，在其它具有缓存的客户端可能有延时，你可以尝试清除缓存后查看新头像",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Container(height: 300),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 150,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color.fromRGBO(0, 77, 255, 1),
              ),
              child: Center(
                child: Text(
                  "返回",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: em_white,
                  ),
                ),
              ),
            ),
          ),
          Container(height: 100),
        ],
      ),
    );
  }
}
