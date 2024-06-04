import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';

class RequestWithdrawApi extends GetxController implements GetxService {

  LoginApiController loginApi = Get.put(LoginApiController());
  Future requestWithdraw(amt, rType, accNumber, bankName, accName, ifscCode, upiId, paypalId) async {
    Map body = {
      "agent_id": loginApi.userData["id"],
      "amt": amt,
      "r_type": rType ?? "",
      "acc_number": accNumber ?? "",
      "bank_name": bankName ?? "",
      "acc_name": accName ?? "",
      "ifsc_code": ifscCode ?? "",
      "upi_id": upiId ?? "",
      "paypal_id": paypalId ?? ""
    };
    
    var response = await http.post(Uri.parse(Config.baseUrl + Config.requestwithdraw),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json',}
    );
    if(response.statusCode == 200){
      var decode = jsonDecode(response.body);
      if(decode["Result"] == "true"){
        return decode["ResponseMsg"];
      }
    }
  }
}