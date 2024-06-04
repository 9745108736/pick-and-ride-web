// To parse this JSON data, do
//
//     final agentLogin = agentLoginFromJson(jsonString);

import 'dart:convert';

AgentLogin agentLoginFromJson(String str) => AgentLogin.fromJson(json.decode(str));

String agentLoginToJson(AgentLogin data) => json.encode(data.toJson());

class AgentLogin {
  String responseCode;
  String result;
  String responseMsg;
  String agentStatus;

  AgentLogin({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.agentStatus,
  });

  factory AgentLogin.fromJson(Map<String, dynamic> json) => AgentLogin(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    agentStatus: json["agent_status"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "agent_status": agentStatus,
  };
}
