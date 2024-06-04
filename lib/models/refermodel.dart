// To parse this JSON data, do
//
//     final referModel = referModelFromJson(jsonString);

import 'dart:convert';

ReferModel referModelFromJson(String str) => ReferModel.fromJson(json.decode(str));

String referModelToJson(ReferModel data) => json.encode(data.toJson());

class ReferModel {
  String responseCode;
  String result;
  String responseMsg;
  String code;
  String signupcredit;
  String refercredit;

  ReferModel({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.code,
    required this.signupcredit,
    required this.refercredit,
  });

  factory ReferModel.fromJson(Map<String, dynamic> json) => ReferModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    code: json["code"],
    signupcredit: json["signupcredit"],
    refercredit: json["refercredit"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "code": code,
    "signupcredit": signupcredit,
    "refercredit": refercredit,
  };
}
