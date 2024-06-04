// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:zigzagbus/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/buslayoutmodel.dart';

class BusLayoutApi extends GetxController implements GetxService {

  BuslayoutModel? buslayoutData;
  bool isLoading = true;

  var userData;


  getlocledata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userData  = jsonDecode(prefs.getString("loginDataall")!);
    update();
    // print('+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${userData["id"]}');

  }

  Future busLayout(context, tripDate,busId) async {
    Map body = {
      "uid": userData["id"],
      "bus_id": busId,
      "trip_date": tripDate.toString().split(' ').first
    };
    var buslayoutResponse = await http.post(Uri.parse(Config.baseUrl + Config.buslayout),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',});

    var buslayoutDecode = json.decode(buslayoutResponse.body);

    if(buslayoutResponse.statusCode == 200){

      if(buslayoutDecode["Result"] == "true"){

        buslayoutData = buslayoutModelFromJson(buslayoutResponse.body);

        if(buslayoutData!.result == "true"){
          isLoading = false;
          update();
          return buslayoutDecode;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(buslayoutData!.responseMsg),width: 400, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(buslayoutDecode["ResponseMsg"]),width: 400, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Something Went Wrong!"),width: 400, elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}