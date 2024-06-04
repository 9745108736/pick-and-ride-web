import 'dart:convert';

import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/searchbusmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchBusApi extends GetxController implements GetxService {

  SearchBusModel? searchBusData;
  String? boardingPoint;
  String? dropPoint;
  String? boardingId;
  String? dropId;
  var selectedDateAndTime = DateTime.now();

  bool isLoading = true;

  String logdataDecode = "";

  String departureTime = "0";
  String sortBy = "0";
  String arrivalTime = "0";
  String busType = "0";
  String facilityList = "0";
  String operatorList = "0";


  LoginApiController logInApi = Get.put(LoginApiController());

 Future searchBus(context) async {
    Map body = {
      "uid": logInApi.userData["id"],
      "boarding_id": boardingId,
      "drop_id": dropId,
      "trip_date": selectedDateAndTime.toString().split(' ').first,
      "sort": sortBy,
      "pickupfilter": departureTime,
      "bustype": busType,
      "operatorlist": operatorList,
      "dropfilter": arrivalTime,
      "facilitylist": facilityList
    };

    var searchBusResponse = await http.post(
        Uri.parse(Config.baseUrl + Config.bussearch),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',});

    var searchbusDecode = jsonDecode(searchBusResponse.body);

    if (searchBusResponse.statusCode == 200) {
      if (searchbusDecode["Result"] == "true") {
        searchBusData = searchBusModelFromJson(searchBusResponse.body);
        if(searchBusData!.result == "true"){

          isLoading = false;
          update();
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(searchbusDecode["ResponseMsg"]),width: 500, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Something Went Wrong!"),width: 300, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
