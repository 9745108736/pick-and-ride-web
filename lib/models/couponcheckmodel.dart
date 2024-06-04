// To parse this JSON data, do
//
//     final couponCheckModel = couponCheckModelFromJson(jsonString);

import 'dart:convert';

CouponCheckModel couponCheckModelFromJson(String str) => CouponCheckModel.fromJson(json.decode(str));

String couponCheckModelToJson(CouponCheckModel data) => json.encode(data.toJson());

class CouponCheckModel {
  String responseCode;
  String result;
  String responseMsg;

  CouponCheckModel({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CouponCheckModel.fromJson(Map<String, dynamic> json) => CouponCheckModel(
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
