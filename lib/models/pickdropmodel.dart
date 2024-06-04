// To parse this JSON data, do
//
//     final pickdropModel = pickdropModelFromJson(jsonString);

import 'dart:convert';

PickdropModel pickdropModelFromJson(String str) => PickdropModel.fromJson(json.decode(str));

String pickdropModelToJson(PickdropModel data) => json.encode(data.toJson());

class PickdropModel {
  List<PickUpStop> pickUpStops;
  List<DropStop> dropStops;
  String responseCode;
  String result;
  String responseMsg;

  PickdropModel({
    required this.pickUpStops,
    required this.dropStops,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory PickdropModel.fromJson(Map<String, dynamic> json) => PickdropModel(
    pickUpStops: List<PickUpStop>.from(json["PickUpStops"].map((x) => PickUpStop.fromJson(x))),
    dropStops: List<DropStop>.from(json["DropStops"].map((x) => DropStop.fromJson(x))),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "PickUpStops": List<dynamic>.from(pickUpStops.map((x) => x.toJson())),
    "DropStops": List<dynamic>.from(dropStops.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class DropStop {
  String dropId;
  String dropTime;
  String dropPlace;
  String dropAddress;
  String dropMobile;

  DropStop({
    required this.dropId,
    required this.dropTime,
    required this.dropPlace,
    required this.dropAddress,
    required this.dropMobile,
  });

  factory DropStop.fromJson(Map<String, dynamic> json) => DropStop(
    dropId: json["drop_id"],
    dropTime: json["drop_time"],
    dropPlace: json["drop_place"],
    dropAddress: json["drop_address"],
    dropMobile: json["drop_mobile"],
  );

  Map<String, dynamic> toJson() => {
    "drop_id": dropId,
    "drop_time": dropTime,
    "drop_place": dropPlace,
    "drop_address": dropAddress,
    "drop_mobile": dropMobile,
  };
}

class PickUpStop {
  String pickId;
  String pickTime;
  String pickPlace;
  String pickAddress;
  String pickMobile;

  PickUpStop({
    required this.pickId,
    required this.pickTime,
    required this.pickPlace,
    required this.pickAddress,
    required this.pickMobile,
  });

  factory PickUpStop.fromJson(Map<String, dynamic> json) => PickUpStop(
    pickId: json["pick_id"],
    pickTime: json["pick_time"],
    pickPlace: json["pick_place"],
    pickAddress: json["pick_address"],
    pickMobile: json["pick_mobile"],
  );

  Map<String, dynamic> toJson() => {
    "pick_id": pickId,
    "pick_time": pickTime,
    "pick_place": pickPlace,
    "pick_address": pickAddress,
    "pick_mobile": pickMobile,
  };
}
