import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/paygetwaymodel.dart';

class PayGetwayApi extends GetxController implements GetxService {

  PaymentGetwaymodel? paygetwayData;
  bool isLoading = true;

  Future payGetway(context) async {

    var paygetwayResponde = await http.get(Uri.parse(Config.baseUrl + Config.paygetway));

    if(paygetwayResponde.statusCode == 200){

      var paygetwayDecode = jsonDecode(paygetwayResponde.body);

      if(paygetwayDecode["Result"] == "true"){

        paygetwayData = paymentGetwaymodelFromJson(paygetwayResponde.body);
        if(paygetwayData!.result == "true"){

          isLoading = false;
          update();

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(paygetwayData!.responseMsg),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
          );
        }
      }  else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(paygetwayDecode["ResponseMsg"]),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Something Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
      );
    }
  }
}