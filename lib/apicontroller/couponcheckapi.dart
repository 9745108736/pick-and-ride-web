import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/couponcheckmodel.dart';

class CouponCheckApi extends GetxController implements GetxService {

  bool isLoading = true;

  CouponCheckModel? couponCheckData;

  LoginApiController loginApi = Get.put(LoginApiController());

 couponCheck(context) async {

   Map body = {
     "uid": loginApi.userData["id"],
     "cid": "1"
   };

   var couponCheckResponse = await http.post(Uri.parse(Config.baseUrl + Config.couponcheck),
       body: jsonEncode(body),
       headers: {'Content-Type': 'application/json',}
   );

   if(couponCheckResponse.statusCode == 200){

     var couponcheckDecode = jsonDecode(couponCheckResponse.body);

     if(couponcheckDecode["Result"] == "true"){

       couponCheckData = couponCheckModelFromJson(couponCheckResponse.body);

     } else {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(couponcheckDecode["ResponseMsg"]),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
       );
     }
   } else {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: const Text("Something Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
     );
   }
 }
}