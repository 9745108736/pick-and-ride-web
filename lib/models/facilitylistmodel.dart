// To parse this JSON data, do
//
//     final facilitylistModel = facilitylistModelFromJson(jsonString);

import 'dart:convert';

FacilitylistModel facilitylistModelFromJson(String str) => FacilitylistModel.fromJson(json.decode(str));

String facilitylistModelToJson(FacilitylistModel data) => json.encode(data.toJson());

class FacilitylistModel {
  List<Facilitylist> facilitylist;
  String responseCode;
  String result;
  String responseMsg;

  FacilitylistModel({
    required this.facilitylist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory FacilitylistModel.fromJson(Map<String, dynamic> json) => FacilitylistModel(
    facilitylist: List<Facilitylist>.from(json["facilitylist"].map((x) => Facilitylist.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "facilitylist": List<dynamic>.from(facilitylist.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class Facilitylist {
  String id;
  String title;
  String img;

  Facilitylist({
    required this.id,
    required this.title,
    required this.img,
  });

  factory Facilitylist.fromJson(Map<String, dynamic> json) => Facilitylist(
    id: json["id"],
    title: json["title"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "img": img,
  };
}
