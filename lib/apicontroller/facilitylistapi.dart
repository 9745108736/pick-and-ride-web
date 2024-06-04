import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/facilitylistmodel.dart';

import '../helper/filldetails.dart';

class FacilitylistApi extends GetxController implements GetxService{

  bool isLoading = true;
  FacilitylistModel? facilityData;
  facilitylist(context) async {

    var response =  await http.get(Uri.parse(Config.baseUrl + Config.facilitylist),headers: {'Content-Type': 'application/json',});

    if(response.statusCode == 200){
      var decodeData = json.decode(response.body);
      if(decodeData["Result"] == "true"){
        facilityData = facilitylistModelFromJson(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: notifier.backgroundColor,
            content: const Text("Something Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: notifier.backgroundColor,
          content: const Text("Something Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
      );
    }
  }
}