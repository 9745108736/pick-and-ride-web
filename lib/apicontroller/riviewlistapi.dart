import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/reviewlistmodel.dart';

class ReviewListApi extends GetxController implements GetxService {

  bool isLoading = true;
  ReviewListModel? reviewlistData;
  Future reviewlist(context, busId) async {
    Map body = {
      "bus_id": busId
    };
    var response = await http.post(Uri.parse(Config.baseUrl + Config.reviewlist),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var reviewlistDecode = jsonDecode(response.body);

      if(reviewlistDecode["Result"] == "true"){

        reviewlistData = reviewListModelFromJson(response.body);

        if(reviewlistData!.result == "true"){
          isLoading = false;
          update();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(reviewlistData!.responseMsg),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(reviewlistDecode["ResponseMsg"]),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Something Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
      );
    }
  }
}