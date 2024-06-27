import 'dart:convert';

import 'package:zigzagbus/config.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/const/common_const.dart';
import '../models/mobileckeckmodel.dart';

class MobileCkeckController extends GetxController implements GetxService{

  MobileCheck? mobileCheckData;
  String ccode = phoneCode;
  Future mobileCheck(context,String mobile) async {
    Map body = {
      "mobile": mobile,
      "ccode": ccode
    };
    print(body);
    print(Uri.parse("${Config.baseUrl}${Config.mobilecheck}"));
    var checkResponse = await http.post(Uri.parse("${Config.baseUrl}${Config.mobilecheck}"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );
    print(checkResponse.body);

    if (checkResponse.statusCode == 200) {
      var checkData = jsonDecode(checkResponse.body);
      mobileCheckData = mobileCheckFromJson(checkResponse.body);
      return checkData;
    }

  }
}