/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-10-06 17:15:48 
 * @Last Modified by:   xusun000 
 * @Last Modified time: 2022-10-06 17:15:48 
 */
import 'package:shared_preferences/shared_preferences.dart';

getStorage({required String key, String initData = ""}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? s = prefs.getString(key);
  if (s == null) {
    await prefs.setString(key, initData);
    return initData;
  } else {
    return s;
  }
}

setStorage({required String key, required String value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? _ = prefs.getString(key);
  return await prefs.setString(key, value);
}
