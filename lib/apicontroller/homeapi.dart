import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/models/homemodel.dart';

import '../helper/filldetails.dart';

class HomeApiController extends GetxController implements GetxService {

  bool isLoading = true;
  HomeApiModel? homeData;

  LoginApiController loginApi = Get.put(LoginApiController());

  Future homepage() async {
    Map body = {
      "uid":  loginApi.isloginsucc ? loginApi.userData["id"] : "0",
    };
    var homeResponse = await http.post(Uri.parse(Config.baseUrl + Config.home),
      body: jsonEncode(body),
        headers: {'Content-Type': 'application/json',}
    );
    var homeDecode = jsonDecode(homeResponse.body);
    if(homeResponse.statusCode == 200){

      if(homeDecode["Result"] == "true"){

        homeData = homeApiModelFromJson(homeResponse.body);

        if(homeData!.result == "true"){

          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString("homedata", jsonEncode(homeDecode));
          isLoading = false;
          update();

        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(homeData!.responseMsg),width: 500,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
          // );
        }
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(homeDecode["ResponseMsg"]),width: 500,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        // );
      }
    } else {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
        msg: "Sorry! please network do ",
        textColor: notifier.blackwhitecolor,
      );
    }
  }
}