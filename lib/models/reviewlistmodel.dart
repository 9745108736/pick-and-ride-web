// To parse this JSON data, do
//
//     final reviewListModel = reviewListModelFromJson(jsonString);

import 'dart:convert';

ReviewListModel reviewListModelFromJson(String str) => ReviewListModel.fromJson(json.decode(str));

String reviewListModelToJson(ReviewListModel data) => json.encode(data.toJson());

class ReviewListModel {
  String responseCode;
  String result;
  String responseMsg;
  List<Reviewdatum> reviewdata;

  ReviewListModel({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.reviewdata,
  });

  factory ReviewListModel.fromJson(Map<String, dynamic> json) => ReviewListModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    reviewdata: List<Reviewdatum>.from(json["reviewdata"].map((x) => Reviewdatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "reviewdata": List<dynamic>.from(reviewdata.map((x) => x.toJson())),
  };
}

class Reviewdatum {
  String userTitle;
  String userRate;
  DateTime reviewDate;
  String userDesc;

  Reviewdatum({
    required this.userTitle,
    required this.userRate,
    required this.reviewDate,
    required this.userDesc,
  });

  factory Reviewdatum.fromJson(Map<String, dynamic> json) => Reviewdatum(
    userTitle: json["user_title"],
    userRate: json["user_rate"],
    reviewDate: DateTime.parse(json["review_date"]),
    userDesc: json["user_desc"],
  );

  Map<String, dynamic> toJson() => {
    "user_title": userTitle,
    "user_rate": userRate,
    "review_date": reviewDate.toIso8601String(),
    "user_desc": userDesc,
  };
}
