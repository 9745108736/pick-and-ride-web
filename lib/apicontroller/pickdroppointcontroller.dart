import 'dart:convert';

import 'package:zigzagbus/apicontroller/searchbuscontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/pickdropmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'loginapicontroller.dart';

class PickDropController extends GetxController implements GetxService {

  LoginApiController logInApi = Get.put(LoginApiController());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());

  PickdropModel? pickdropData;
  bool isloading = true;

  Future pickdropPoint(context) async {

  Map body = {
  "uid": logInApi.userData["id"],
  "id_pickup_drop": searchBusApi.searchBusData!.busData[0].idPickupDrop
  };

  var pickcropResponse = await http.post(Uri.parse(Config.baseUrl + Config.pickdrop),
  body: jsonEncode(body),
  headers: {'Content-Type': 'application/json',}
  );

  var pickdropEncode = json.decode(pickcropResponse.body);

  if(pickcropResponse.statusCode == 200){
    pickdropData = pickdropModelFromJson(pickcropResponse.body);

    if(pickdropEncode["Result"] == "true"){



      if(pickdropData!.result == "true"){

        isloading = false;
        update();



      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pickdropData!.responseMsg),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pickdropEncode["ResponseMsg"]),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text("Someting Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
    );
  }

}
}