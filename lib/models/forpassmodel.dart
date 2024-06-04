// To parse this JSON data, do
//
//     final forgotPassM = forgotPassMFromJson(jsonString);

import 'dart:convert';

ForgotPassM forgotPassMFromJson(String str) => ForgotPassM.fromJson(json.decode(str));

String forgotPassMToJson(ForgotPassM data) => json.encode(data.toJson());

class ForgotPassM {
  String responseCode;
  String result;
  String responseMsg;

  ForgotPassM({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory ForgotPassM.fromJson(Map<String, dynamic> json) => ForgotPassM(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}
