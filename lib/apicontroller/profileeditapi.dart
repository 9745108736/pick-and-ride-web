import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';

import '../models/profileeditmodel.dart';

class ProfileEditApi extends GetxController implements GetxService {

  bool isLoading = true;
  ProfileEditModel? profileEditData;
  LoginApiController loginApi = Get.put(LoginApiController());

  Future profileEdit(context, name, email, password) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      "uid": loginApi.userData["id"],
      "name": name,
      "email": email,
      "password": password
    };

    var response = await http.post(Uri.parse(Config.baseUrl + Config.profileedit),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var peDecode = jsonDecode(response.body);

      if(peDecode["Result"] == "true"){

        profileEditData = profileEditModelFromJson(response.body);

        if(profileEditData!.result == "true"){

          prefs.setString("loginDataall", jsonEncode(peDecode["UserLogin"]));

          isLoading = false;
          update();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileEditData!.responseMsg),width: 500, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileEditData!.responseMsg),width: 500, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(peDecode["ResponseMsg"]),width: 500, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Something Went Wrong!"),width: 500, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}