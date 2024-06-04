import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';

class PostReviewApi extends GetxController implements GetxService {

  LoginApiController loginApi = Get.put(LoginApiController());

  Future postReview(ticketid, totalrate, ratetax) async {

    Map body = {
      "uid": loginApi.userData["id"],
      "ticket_id": ticketid,
      "total_rate": totalrate,
      "rate_text": ratetax
    };

    var response = await http.post(Uri.parse(Config.baseUrl + Config.postreview),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );

    if(response.statusCode == 200){

      jsonDecode(response.body);

    } else {
      Fluttertoast.showToast(
        msg: "Review not posted",
      );
    }
  }
}