import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/refermodel.dart';

class ReferApi extends GetxController implements GetxService {

  LoginApiController logInApi = Get.put(LoginApiController());
  ReferModel? referData;
  bool isLoading = true;
  Future referandEarn(context) async {
    Map body = {
      "uid": logInApi.userData["id"]
    };
    var referResponse = await http.post(Uri.parse(Config.baseUrl + Config.refer),
      body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if(referResponse.statusCode == 200){

      var referDecode = jsonDecode(referResponse.body);
      if(referDecode["Result"] == "true"){

        referData = referModelFromJson(referResponse.body);
        if(referData!.result == "true"){

          isLoading = false;
          update();
        }
      }
    }
  }
}