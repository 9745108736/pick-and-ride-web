import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:zigzagbus/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/filldetails.dart';
import '../models/signupmodel.dart';

class SignUpApi extends GetxController implements GetxService{
  TextEditingController signName = TextEditingController();
  TextEditingController signMobile = TextEditingController();
  TextEditingController signEmail = TextEditingController();
  TextEditingController signPass = TextEditingController();
  TextEditingController referalCode = TextEditingController();
  String? userType;
  String ccode = "+974";

  SignUpM? signData;
  Future signUpWithMobile(context) async {
    Map body = {
      "name": signName.text,
      "email": signEmail.text,
      "mobile": signMobile.text,
      "password": signPass.text,
      "ccode": ccode,
      "user_type": userType,
      "rcode" : referalCode.text
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.post(Uri.parse(Config.baseUrl + Config.signup), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',});


    var signUpData = jsonDecode(response.body);


    if(response.statusCode == 200){
      if (signUpData["Result"] == "true") {
        signData = signUpMFromJson(response.body);
        update();

        prefs.setString("loginDataall", jsonEncode(signUpData["UserLogin"]));
        prefs.setBool("islogin", true);
        Get.back();
        return signUpData;
      }
      return signUpData;
      // update();
    } else {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
        msg: 'Something Went wrong!'.tr,
        textColor: notifier.blackwhitecolor,
      );
    }
  }
}