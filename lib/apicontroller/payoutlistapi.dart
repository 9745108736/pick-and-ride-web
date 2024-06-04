import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/payoutlistmodel.dart';

class PayoutListApi extends GetxController implements GetxService {

  LoginApiController loginApi = Get.put(LoginApiController());

  Payoutlistmodel? payoutData;
  bool isLoading = true;

  Future payoutList() async {

    Map body = {
      "agent_id": loginApi.userData["id"]
    };
    var response = await http.post(Uri.parse(Config.baseUrl + Config.payoutlist),
      body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var decodeData = jsonDecode(response.body);
      if(decodeData["Result"] == "true"){

        payoutData = payoutlistmodelFromJson(response.body);
        if(payoutData!.result == "true"){

          isLoading = false;
          update();
        } else {
          Fluttertoast.showToast(
            msg: payoutData!.responseMsg,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: decodeData["ResponseMsg"],
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
      );
    }
  }
}