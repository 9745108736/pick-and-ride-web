import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/faqmodel.dart';

class FaqApi extends GetxController implements GetxService {

  LoginApiController logInApi = Get.put(LoginApiController());
  bool isLoading = true;
  FaqModel? faqData;
  Future faqfun(context) async {
    Map body = {
      "uid": logInApi.userData["id"]
    };

    var faqResponse = await http.post(Uri.parse(Config.baseUrl + Config.faq),
      body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if(faqResponse.statusCode == 200){

      var faqDecode = jsonDecode(faqResponse.body);

      if(faqDecode["Result"] == "true"){

        faqData = faqModelFromJson(faqResponse.body);

        if(faqData!.result == "true"){

          isLoading = false;
          update();
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Something Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
      );
    }
  }
}