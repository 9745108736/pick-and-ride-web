import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/bookinghmodel.dart';

class BookingHistoryApi extends GetxController implements GetxService {

  LoginApiController loginApi = Get.put(LoginApiController());

  bool isLoading = true;
  bool isLoadingComp = true;
  bool isLoadingCanc = true;

  BookingHistoryModel? bookingHData;
  BookingHistoryModel? bookingHDataComp;
  BookingHistoryModel? bookingHDataCanc;

  Future bookinghistory(context, status) async {

    Map body = {
      "uid" : loginApi.userData["id"],
      "status" : status
    };

    var bookingHistResponse = await http.post(Uri.parse(Config.baseUrl + Config.bookinghistory),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json',}
    );

    if(bookingHistResponse.statusCode == 200){

      var bhDecode = jsonDecode(bookingHistResponse.body);

      if(bhDecode["Result"] == "true"){

          isLoading = false;
          update();
          return bookingHistResponse.body;

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(bhDecode["ResponseMsg"]),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Something Went Wrong!'),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),));
    }
  }
}