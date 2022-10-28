import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:emotion/util/mid_request.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:http_parser/http_parser.dart';

String generateMD5(String data) {
  Uint8List content = Utf8Encoder().convert(data);
  Digest digest = md5.convert(content);
  return digest.toString();
}

class Api {
  forceRefresh() async {
    return await XHttp().postWithGlobalToken(
      param: {},
      url: "/comment/force_refresh",
    );
  }

  editAvatar(String url) async {
    return await XHttp().postWithGlobalToken(
      param: {"url": url},
      url: "/user/edit_avatar",
    );
  }

  getUserInfo() async {
    return await XHttp().postWithGlobalToken(
      param: {},
      url: "/user/get_info",
    );
  }

  uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileExtension =
          file.path.split(".")[file.path.split(".").length - 1];
      var dio = Dio();
      var resParam = await getUploadparam();
      var formData = FormData.fromMap({
        'OSSAccessKeyId': resParam["data"]["accessid"],
        'policy': resParam["data"]["policy"],
        'signature': resParam["data"]["signature"],
        'key': 'emotion/${generateMD5(file.path)}.$fileExtension',
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split("/")[file.path.split("/").length - 1],
          contentType: MediaType("image", fileExtension),
        )
      });
      var response = await dio.post(
        'http://ustc-train.oss-cn-hangzhou.aliyuncs.com',
        data: formData,
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print("上传成功");
        return "${generateMD5(file.path)}.$fileExtension";
      }
      return "";
    }
  }

  getUploadparam() async {
    return await XHttp().postWithGlobalToken(
      param: {},
      url: "/comment/get_uploadparam",
    );
  }

  sendComment({
    required cont,
    required type,
  }) async {
    return await XHttp().postWithGlobalToken(
      param: {
        "cont": cont,
        "type": type,
      },
      url: "/comment/send_comment",
    );
  }

  deleteComment({required comment_id}) async {
    return await XHttp().postWithGlobalToken(
      param: {"comment_id": comment_id},
      url: "/comment/delete_comment",
    );
  }

  getComment() async {
    return await XHttp().postWithGlobalToken(
      withLog: false,
      param: {},
      url: "/comment/get_comment",
    );
  }

  setStatus({
    required type,
  }) async {
    return await XHttp().postWithGlobalToken(
      param: {
        "type": type,
      },
      url: "/emoji/set_status",
    );
  }

  exportExcel({
    required start_time,
    required end_time,
  }) async {
    return await XHttp().postWithGlobalToken(
      param: {
        "start_time": start_time,
        "end_time": end_time,
      },
      url: "/emoji/export_excel",
    );
  }

  getStatus({
    required start_time,
    required end_time,
  }) async {
    return await XHttp().postWithGlobalToken(
      param: {
        "start_time": start_time,
        "end_time": end_time,
      },
      url: "/emoji/get_status",
    );
  }

  deleteUser({
    required type, // 仅管理员可以指定
    required user_id, // 仅管理员可以指定
  }) async {
    return await XHttp().postWithGlobalToken(
      param: {
        "type": type,
        "user_id": user_id,
      },
      url: "/user/delete_user",
    );
  }

  editUserInfo({
    nickname,
    password,
    avatar,
    number,
    school_class,
    gender,
    major,
    phone,
    age,
    type, // 仅管理员可以指定
    user_id, // 仅管理员可以指定
  }) async {
    return await XHttp().postWithGlobalToken(
      param: {
        "nickname": nickname ?? "",
        "password": password ?? "",
        "avatar": avatar ?? "",
        "number": number ?? "",
        "school_class": school_class ?? "",
        "major": major ?? "",
        "phone": phone ?? "",
        "age": age ?? "",
        "gender": gender ?? "",
        "type": type ?? "",
        "user_id": user_id ?? "",
      },
      url: "/user/edit_info",
    );
  }

  addUser({required username, required password, required type}) async {
    return await XHttp().postWithGlobalToken(
      param: {
        "username": username,
        "password": password,
        "type": type,
      },
      url: "/user/add_user",
    );
  }

  getAllUser() async {
    return await XHttp().postWithGlobalToken(
      param: {},
      url: "/user/get_all_user",
    );
  }

  login({required username, required password, required type}) async {
    return await XHttp().post(
      param: {
        "username": username,
        "password": password,
        "type": type,
      },
      url: "/user/login",
    );
  }

  test() async {
    return await XHttp().postWithGlobalToken(
      param: {},
      url: "/user/test",
    );
  }
}
