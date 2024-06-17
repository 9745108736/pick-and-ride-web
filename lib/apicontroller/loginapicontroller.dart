// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigzagbus/deshboard/deshboard.dart';
import 'package:zigzagbus/helper/filldetails.dart';

import '../models/loginmodel.dart';

HomeApiController homeApi = Get.put(HomeApiController());

class LoginApiController extends GetxController implements GetxService {
  TextEditingController logMobile = TextEditingController();
  TextEditingController logPass = TextEditingController();
  bool islogin = true;
  String ccode = "+974";

  var userData;

  bool isloginsucc = false;
  LogIn? logData;

  Future getlocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isloginsucc = prefs.getBool("islogin") ?? false;
    update();

    if (isloginsucc == true) {
      var decode = jsonDecode(prefs.getString("loginDataall")!);
      userData = decode;
      update();
    }
  }

  Future logIn(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      "mobile": logMobile.text,
      "ccode": ccode,
      "password": logPass.text
    };
    var response = await http.post(
        Uri.parse('${Config.baseUrl}${Config.login}'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        });
    var logInData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (logInData["Result"] == "true") {
        logData = logInFromJson(response.body);
        if (logData!.result == "true") {
          islogin = false;
          update();

          prefs.setBool("islogin", true);

          prefs.setString("loginDataall", jsonEncode(logInData["UserLogin"]));

          getlocaldata().then((value) {
            homeApi.homepage().then((value) {
              Get.to(const deshscreen());
            });
          });
          Get.back();
          return logInData;
        }
      }
      return logInData;
    } else {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        webBgColor: notifier.isDark
            ? "linear-gradient(to right, #ffffff, #ffffff)"
            : "linear-gradient(to right, #000000, #000000)",
        msg: "Something Went Wrong!".tr,
        textColor: notifier.blackwhitecolor,
      );
    }
  }
}
