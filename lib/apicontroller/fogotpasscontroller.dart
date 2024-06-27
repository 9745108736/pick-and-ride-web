import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/const/common_const.dart';
import 'package:zigzagbus/models/forpassmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/filldetails.dart';

class ForgotPassController extends GetxController implements GetxService{

  TextEditingController forgotPass = TextEditingController();
  TextEditingController forgotMobile = TextEditingController();
  String ccode = phoneCode;
  ForgotPassM? forgotpassData;
  Future forgotPassword(context, mobile, password) async {
    Map body = {
      "mobile": mobile,
      "ccode": ccode,
      "password": password
    };
    var forgotPassResponse = await http.post(Uri.parse("${Config.baseUrl}${Config.forgotpass}"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );
    var forPass = jsonDecode(forgotPassResponse.body);

    if (forgotPassResponse.statusCode == 200) {
      if(forPass["Result"] == true){
        forgotpassData = forgotPassMFromJson(forgotPassResponse.body);
        return forPass;
      } else {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
          msg: forPass["ResponseMsg"],
          textColor: notifier.blackwhitecolor,
        );
      }
    } else {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
        msg: "Something went wrong!".tr,
        textColor: notifier.blackwhitecolor,
      );
    }

  }
}