// To parse this JSON data, do
//
//     final walletreportModel = walletreportModelFromJson(jsonString);

// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

WalletreportModel walletreportModelFromJson(String str) => WalletreportModel.fromJson(json.decode(str));

String walletreportModelToJson(WalletreportModel data) => json.encode(data.toJson());

class WalletreportModel {
  List<Walletitem> walletitem;
  String wallet;
  String responseCode;
  String result;
  String responseMsg;
  var agentEarning;

  WalletreportModel({
    required this.walletitem,
    required this.wallet,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.agentEarning,
  });

  factory WalletreportModel.fromJson(Map<String, dynamic> json) => WalletreportModel(
    walletitem: List<Walletitem>.from(json["Walletitem"].map((x) => Walletitem.fromJson(x))),
    wallet: json["wallet"],
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    agentEarning: json["Agent_Earning"],
  );

  Map<String, dynamic> toJson() => {
    "Walletitem": List<dynamic>.from(walletitem.map((x) => x.toJson())),
    "wallet": wallet,
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "Agent_Earning": agentEarning,
  };
}

class Walletitem {
  String message;
  String status;
  String amt;

  Walletitem({
    required this.message,
    required this.status,
    required this.amt,
  });

  factory Walletitem.fromJson(Map<String, dynamic> json) => Walletitem(
    message: json["message"],
    status: json["status"],
    amt: json["amt"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "amt": amt,
  };
}
