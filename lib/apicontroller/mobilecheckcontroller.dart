import 'dart:convert';

import 'package:zigzagbus/config.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../models/mobileckeckmodel.dart';

class MobileCkeckController extends GetxController implements GetxService{

  MobileCheck? mobileCheckData;
  String ccode = "+91";
  Future mobileCheck(context,String mobile) async {
    Map body = {
      "mobile": mobile,
      "ccode": ccode
    };
    var checkResponse = await http.post(Uri.parse("${Config.baseUrl}${Config.mobilecheck}"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if (checkResponse.statusCode == 200) {
      var checkData = jsonDecode(checkResponse.body);
      mobileCheckData = mobileCheckFromJson(checkResponse.body);
      return checkData;
    }

  }
}