/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:39 
 * @Last Modified by: xusun000
 * @Last Modified time: 2022-10-06 17:38:47
 */
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:emotion/util/storage.dart';

// String baseUrl = "/api";
String baseUrl = "http://124.223.79.175:8080";
// String baseUrl = "http://127.0.0.1:8000";

bool isLog = true; //控制是否打印网络输出日志

class XHttp {
  netWorkRequest({
    required bool noTimeOut, //是否有超时
    String url = "",
    bool? withLog = true,
    required Map header,
    required Map param, //参数
  }) async {
    var dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.plain;
    dio.options.connectTimeout = noTimeOut ? 10000000 : 10000;
    dio.options.receiveTimeout = noTimeOut ? 10000000 : 10000;
    if (isLog && (withLog ?? true)) print("地址:$url入参:$param");
    Response response = await dio
        .request(url, data: param, options: Options(method: "POST"))
        .catchError(
      (err) {
        if (isLog && (withLog ?? true)) print("${err}");
      },
    );
    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.toString());
      if (isLog && (withLog ?? true)) print("地址:$url入参:$param回参:$data");
      return data;
    } else {
      print(response.toString());
      return {};
    }
  }

  postWithGlobalToken({
    bool? noTimeOut,
    bool? withLog,
    Map? param,
    required String url,
  }) async {
    String token = await getStorage(key: "token", initData: "");
    if (token != "") {
      param = param ?? {};
      param.addAll({
        "token": token,
      });
    }
    return await netWorkRequest(
      url: url,
      param: param ?? {},
      withLog: withLog,
      noTimeOut: noTimeOut ?? true,
      header: {"Content-Type": "application/x-www-form-urlencoded"},
    );
  }

  //发起POST请求
  post({
    required String url,
    Map? header,
    Map? param,
    bool? noTimeOut,
  }) async {
    return netWorkRequest(
      noTimeOut: noTimeOut ?? true,
      url: url,
      header: header ?? {},
      param: param ?? {},
    );
  }
}
