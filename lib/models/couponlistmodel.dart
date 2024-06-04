// To parse this JSON data, do
//
//     final couponListModel = couponListModelFromJson(jsonString);

import 'dart:convert';

CouponListModel couponListModelFromJson(String str) => CouponListModel.fromJson(json.decode(str));

String couponListModelToJson(CouponListModel data) => json.encode(data.toJson());

class CouponListModel {
  List<Couponlist> couponlist;
  String responseCode;
  String result;
  String responseMsg;

  CouponListModel({
    required this.couponlist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory CouponListModel.fromJson(Map<String, dynamic> json) => CouponListModel(
    couponlist: List<Couponlist>.from(json["couponlist"].map((x) => Couponlist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "couponlist": List<dynamic>.from(couponlist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Couponlist {
  String id;
  String couponImg;
  DateTime expireDate;
  String cDesc;
  String couponVal;
  String couponCode;
  String couponTitle;
  String couponSubtitle;
  String minAmt;

  Couponlist({
    required this.id,
    required this.couponImg,
    required this.expireDate,
    required this.cDesc,
    required this.couponVal,
    required this.couponCode,
    required this.couponTitle,
    required this.couponSubtitle,
    required this.minAmt,
  });

  factory Couponlist.fromJson(Map<String, dynamic> json) => Couponlist(
    id: json["id"],
    couponImg: json["coupon_img"],
    expireDate: DateTime.parse(json["expire_date"]),
    cDesc: json["c_desc"],
    couponVal: json["coupon_val"],
    couponCode: json["coupon_code"],
    couponTitle: json["coupon_title"],
    couponSubtitle: json["coupon_subtitle"],
    minAmt: json["min_amt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "coupon_img": couponImg,
    "expire_date": "${expireDate.year.toString().padLeft(4, '0')}-${expireDate.month.toString().padLeft(2, '0')}-${expireDate.day.toString().padLeft(2, '0')}",
    "c_desc": cDesc,
    "coupon_val": couponVal,
    "coupon_code": couponCode,
    "coupon_title": couponTitle,
    "coupon_subtitle": couponSubtitle,
    "min_amt": minAmt,
  };
}
