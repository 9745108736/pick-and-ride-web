import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/ticketdetailsmodel.dart';

class TicketDetailsApi extends GetxController implements GetxService {

  bool isLoading = true;
  LoginApiController logInApi = Get.put(LoginApiController());
  TicketDetailsModel? ticketDetailsData;
  Future ticketDetails(context, ticketId) async {


    Map body = {
      "uid": logInApi.userData["id"],
      "ticket_id": ticketId
    };

    var response = await http.post(Uri.parse(Config.baseUrl + Config.ticketdetails),
      body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var ticketDetailsDecode = jsonDecode(response.body);

      if(ticketDetailsDecode["Result"] == "true"){

        ticketDetailsData = ticketDetailsModelFromJson(response.body);

        if(ticketDetailsData!.result == "true"){

          isLoading = false;
          update();

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(ticketDetailsData!.responseMsg),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ticketDetailsDecode["ResponseMsg"]),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Something Went Wrong!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
      );
    }
  }
}