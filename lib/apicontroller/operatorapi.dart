import 'dart:convert';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/operatormodel.dart';

class OperatorApi extends GetxController implements GetxService {

  bool isLoading = true;
  OperatorModel? operatorData;
  Future operatorList() async {
    
    var response = await http.get(Uri.parse(Config.baseUrl + Config.operatorlist),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      var dataDecode = jsonDecode(response.body);
      if(dataDecode["Result"] == "true"){
        
        operatorData = operatorModelFromJson(response.body);
        if(operatorData!.result == "true"){

          isLoading = false;
          update();
        }
      }
    }
  }
}