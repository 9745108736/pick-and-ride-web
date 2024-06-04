import 'dart:convert';

import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/citylistmodel.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CityListDataApi extends GetxController implements GetxService{



  CityListM? citylistData;
  Future<void> cityList(context) async {
    var cityListResponse = await http.get(Uri.parse("${Config.baseUrl}${Config.citylist}"),
        headers: {'Content-Type': 'application/json',}
    );

    if(cityListResponse.statusCode == 200){
      json.decode(cityListResponse.body);
      citylistData = cityListMFromJson(cityListResponse.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dataencode = jsonEncode(citylistData);
      prefs.setString("citylistdata", dataencode);
      update();
    }
  }
}