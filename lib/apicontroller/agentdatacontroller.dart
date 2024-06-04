import 'dart:convert';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/agentmodel.dart';

class AgentDataController extends GetxController implements GetxService{

  AgentLogin? agentData;
  Future agentLogin(context) async {

    var agentResponse = await http.get(Uri.parse("${Config.baseUrl}${Config.agentlogin}"),
        headers: {'Content-Type': 'application/json',}
    );
    if(agentResponse.statusCode == 200){
      json.decode(agentResponse.body);
      agentData = agentLoginFromJson(agentResponse.body);
      update();
    }
  }
}