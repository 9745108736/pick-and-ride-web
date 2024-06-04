import 'dart:convert';

import 'package:zigzagbus/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cacellationmodel.dart';


class PageListApi extends GetxController implements GetxService {


  CancellationModel? cancellationPolicyData;
  bool isLoading = true;


  Future cancellationPolicy(context) async {

    var policyResponse = await http.get(Uri.parse(Config.baseUrl + Config.cancellationpolicy),headers: {'Content-Type': 'application/json',});

    var policyData = jsonDecode(policyResponse.body);

    if(policyResponse.statusCode == 200){

      if(policyData["Result"] == "true"){

        cancellationPolicyData = cancellationModelFromJson(policyResponse.body);

        if(cancellationPolicyData!.result == "true"){

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("cancelationpolicy", cancellationPolicyData!.pagelist[3].description);
          prefs.setString("policypolicy", cancellationPolicyData!.pagelist[0].description);
          prefs.setString("termcondition", cancellationPolicyData!.pagelist[1].description);
          prefs.setString("contactus", cancellationPolicyData!.pagelist[2].description);

          isLoading = false;
          update();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cancellationPolicyData!.responseMsg),width: 400, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(policyData["ResponseMsg"]),width: 400, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Something Went Wromg!"),width: 400, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}