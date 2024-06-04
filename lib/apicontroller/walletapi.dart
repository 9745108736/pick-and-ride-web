import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/config.dart';
import 'loginapicontroller.dart';

class WalletApi extends GetxController implements GetxService {

  LoginApiController logInApi = Get.put(LoginApiController());

  Future wallet(walletAmt) async{
    Map body = {
      "uid": logInApi.userData["id"],
      "wallet": walletAmt
    };

    var response = await http.post(Uri.parse(Config.baseUrl + Config.wallet),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      jsonDecode(response.body);

    }
  }
}