// To parse this JSON data, do
//
//     final bookTicketModel = bookTicketModelFromJson(jsonString);

import 'dart:convert';

BookTicketModel bookTicketModelFromJson(String str) => BookTicketModel.fromJson(json.decode(str));

String bookTicketModelToJson(BookTicketModel data) => json.encode(data.toJson());

class BookTicketModel {
  String responseCode;
  String result;
  String responseMsg;
  String wallet;

  BookTicketModel({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.wallet,
  });

  factory BookTicketModel.fromJson(Map<String, dynamic> json) => BookTicketModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    wallet: json["wallet"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "wallet": wallet,
  };
}
