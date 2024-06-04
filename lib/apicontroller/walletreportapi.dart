import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/walletreportmodel.dart';

class WalletReportApi extends GetxController implements GetxService {

  LoginApiController logInApi = Get.put(LoginApiController());

  bool isLoading = true;
  WalletreportModel? walletreportData;

  Future walletReport(context) async {

    Map body = {
      "uid": logInApi.userData["id"]
    };
  var walletreportResponse = await http.post(Uri.parse(Config.baseUrl + Config.walletreport),
    body: jsonEncode(body),
    headers: {'Content-Type': 'application/json',}
  );

  if(walletreportResponse.statusCode == 200){

    var walletreportDecode = jsonDecode(walletreportResponse.body);

    if(walletreportDecode["Result"] == "true"){

      walletreportData = walletreportModelFromJson(walletreportResponse.body);

      if(walletreportData!.result == "true"){

        isLoading = false;
        update();

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(walletreportData!.responseMsg),width: 500, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(walletreportDecode["ResponseMsg"]),width: 500, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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