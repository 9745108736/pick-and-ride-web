// To parse this JSON data, do
//
//     final bookingHistoryModel = bookingHistoryModelFromJson(jsonString);

import 'dart:convert';

BookingHistoryModel bookingHistoryModelFromJson(String str) => BookingHistoryModel.fromJson(json.decode(str));

String bookingHistoryModelToJson(BookingHistoryModel data) => json.encode(data.toJson());

class BookingHistoryModel {
  String responseCode;
  String result;
  String responseMsg;
  List<Tickethistory> tickethistory;

  BookingHistoryModel({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.tickethistory,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) => BookingHistoryModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
    tickethistory: List<Tickethistory>.from(json["tickethistory"].map((x) => Tickethistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
    "tickethistory": List<dynamic>.from(tickethistory.map((x) => x.toJson())),
  };
}

class Tickethistory {
  String ticketId;
  String busName;
  String busNo;
  String busImg;
  String isAc;
  String subtotal;
  DateTime bookDate;
  String ticketPrice;
  String boardingCity;
  String dropCity;
  String busPicktime;
  String busDroptime;
  String differencePickDrop;

  Tickethistory({
    required this.ticketId,
    required this.busName,
    required this.busNo,
    required this.busImg,
    required this.isAc,
    required this.subtotal,
    required this.bookDate,
    required this.ticketPrice,
    required this.boardingCity,
    required this.dropCity,
    required this.busPicktime,
    required this.busDroptime,
    required this.differencePickDrop,
  });

  factory Tickethistory.fromJson(Map<String, dynamic> json) => Tickethistory(
    ticketId: json["ticket_id"],
    busName: json["bus_name"],
    busNo: json["bus_no"],
    busImg: json["bus_img"],
    isAc: json["is_ac"],
    subtotal: json["subtotal"],
    bookDate: DateTime.parse(json["book_date"]),
    ticketPrice: json["ticket_price"],
    boardingCity: json["boarding_city"],
    dropCity: json["drop_city"],
    busPicktime: json["bus_picktime"],
    busDroptime: json["bus_droptime"],
    differencePickDrop: json["Difference_pick_drop"],
  );

  Map<String, dynamic> toJson() => {
    "ticket_id": ticketId,
    "bus_name": busName,
    "bus_no": busNo,
    "bus_img": busImg,
    "is_ac": isAc,
    "subtotal": subtotal,
    "book_date": "${bookDate.year.toString().padLeft(4, '0')}-${bookDate.month.toString().padLeft(2, '0')}-${bookDate.day.toString().padLeft(2, '0')}",
    "ticket_price": ticketPrice,
    "boarding_city": boardingCity,
    "drop_city": dropCity,
    "bus_picktime": busPicktime,
    "bus_droptime": busDroptime,
    "Difference_pick_drop": differencePickDrop,
  };
}
