import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/apicontroller/pickdroppointcontroller.dart';
import 'package:zigzagbus/apicontroller/searchbuscontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/bookticketmodel.dart';

class BookTicketApi extends GetxController implements GetxService {
  LoginApiController logInApi = Get.put(LoginApiController());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  PickDropController pickDropApi = Get.put(PickDropController());

  bool isLoading = true;
  BookTicketModel? bookTicketData;

  Future bookTicket(
      // context,
      index,
      walletAmt,
      pickPlace,
      dropPlace,
      amount,
      couAmt,
      paymentId,
      payMethodId,
      pickData,
      dropData,
      passengerData,
      taxAmount,
      seatList,
      commission,
      totalAmt,
      contactName,
      contactMobile,
      contactEmail
      ) async {

    Map body = {
      "uid": logInApi.userData["id"],
      "name": contactName,
      "bus_id": searchBusApi.searchBusData!.busData[index].busId,
      "operator_id": searchBusApi.searchBusData!.busData[index].operatorId,
      "email": contactEmail,
      "ccode": logInApi.ccode,
      "mobile": contactMobile,
      "pickup_id": searchBusApi.boardingId,
      "drop_id": searchBusApi.dropId,
      "total": amount,
      "cou_amt": couAmt,
      "wall_amt": walletAmt,
      "book_date": searchBusApi.selectedDateAndTime.toString().split(' ').first,
      "total_seat": searchBusApi.searchBusData!.busData[index].totlSeat,
      "seat_list": seatList.join(","),
      "payment_method_id": payMethodId,
      "ticket_price": searchBusApi.searchBusData!.busData[index].ticketPrice,
      "transaction_id": paymentId,
      "boarding_city": searchBusApi.searchBusData!.busData[index].boardingCity,
      "drop_city": searchBusApi.searchBusData!.busData[index].dropCity,
      "bus_picktime": searchBusApi.searchBusData!.busData[index].busPicktime,
      "bus_droptime": searchBusApi.searchBusData!.busData[index].busDroptime,
      "Difference_pick_drop": searchBusApi.searchBusData!.busData[index].differencePickDrop,
      "tax_amt": taxAmount,
      "sub_pick_time": pickData["sub_pick_time"],
      "sub_pick_place": pickPlace,
      "sub_pick_address": pickData["sub_pick_address"],
      "sub_pick_mobile": pickData["sub_pick_mobile"],
      "sub_drop_time": dropData["sub_drop_time"],
      "sub_drop_place": dropPlace,
      "sub_drop_address": dropData["sub_drop_address"],
      "subtotal": totalAmt.toString(),
      "user_type": logInApi.userData["user_type"],
      "commission": commission,
      "comm_per": searchBusApi.searchBusData!.busData[index].agentCommission,
      "PessengerData": passengerData,
    };

    var bookticketResponse = await http.post(
        Uri.parse(Config.baseUrl + Config.bookticket),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if (bookticketResponse.statusCode == 200) {
      var bookticketDecode = jsonDecode(bookticketResponse.body);
      if (bookticketDecode["Result"] == "true") {
        bookTicketData = bookTicketModelFromJson(bookticketResponse.body);

        if (bookTicketData!.result == "true") {
          isLoading = false;
          update();
        } else {
          Fluttertoast.showToast(
            msg: bookTicketData!.responseMsg,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: bookticketDecode["ResponseMsg"],
        );
      }

      return bookticketDecode["Result"];
    } else {
      Fluttertoast.showToast(
        msg: "Something Went Wrong!",
      );
    }
  }
}
