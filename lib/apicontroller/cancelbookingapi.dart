import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';

import '../config.dart';
import '../helper/filldetails.dart';

class CancelBookingApi extends GetxController implements GetxService {

  LoginApiController loginApiController = Get.put(LoginApiController());

  bool loading = true;
  Future cancelBooking(amount, comment) async {
    Map body = {
      "uid" : loginApiController.userData["id"],
      "total" : amount,
      "comment_reject" : comment
    };
      var response = await http.post(Uri.parse("${Config.baseUrl}${Config.cancelbooking}",),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json',}
    );


      if(response.statusCode == 200){
        var responseDecode = jsonDecode(response.body);
        if(responseDecode["Result"] == "true"){
          loading = false;
          update();
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
            msg: responseDecode["Response"],
            textColor: notifier.blackwhitecolor,
          );
          return responseDecode;
        }
      }
  }
}