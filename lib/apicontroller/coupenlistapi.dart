import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/apicontroller/searchbuscontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/couponlistmodel.dart';

class CouponlistApi extends GetxController implements GetxService {

  SearchBusApi searchbus = Get.put(SearchBusApi());
  LoginApiController logInApi = Get.put(LoginApiController());

  bool isLoading = true;
  CouponListModel? couponListData;
  couponList(context, index) async {
    Map body = {
      "uid": logInApi.userData["id"],
      "operator_id": searchbus.searchBusData!.busData[index].operatorId
    };
    var couponlisResponse = await http.post(Uri.parse(Config.baseUrl + Config.couponlist),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json',}
    );

    if(couponlisResponse.statusCode == 200){
      couponListData = couponListModelFromJson(couponlisResponse.body);

      var couponlistDecode = jsonDecode(couponlisResponse.body);

      if(couponlistDecode["Result"] == "true"){

        if(couponListData!.result == "true"){

          isLoading = false;
          update();

        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(couponlistDecode["ResponseMsg"]),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Something Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
      );
    }
  }
}