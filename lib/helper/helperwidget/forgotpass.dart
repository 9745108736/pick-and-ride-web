// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:zigzagbus/apicontroller/fogotpasscontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/const/common_const.dart';

import '../../apicontroller/loginapicontroller.dart';
import '../../apicontroller/mobilecheckcontroller.dart';
import '../../mediaquery/mq.dart';
import '../colornotifier.dart';
import '../logindialog.dart';
import 'firebaseauth.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late ColorNotifier notifier;

  ForgotPassController forgotPassApi = Get.put(ForgotPassController());
  MobileCkeckController mobileCheckApi = Get.put(MobileCkeckController());

  String otpPin = "";
  String pin = "";

  var temp;

  OtpFieldController otpcont = OtpFieldController();
  TextEditingController mobile = TextEditingController();
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return forgotDialog(context, constraints);
    },);
  }
  Widget forgotDialog(context, constraints){
    return SizedBox(
      width: 400,
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter mobile number'.tr,style: TextStyle(fontSize: 28,color: notifier.blackcolor,fontFamily: 'SofiaBold'),),
            const SizedBox(height: 40),
            IntlPhoneField(
              disableLengthCheck: true,
              controller: mobile,
              disableAutoFillHints: true,
              style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 12),
                hintText: 'Phone Number'.tr,
                hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: notifier.sugestionbutton),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: notifier.sugestionbutton),
                ),
              ),
              showCountryFlag: false,
              showDropdownIcon: false,
              dropdownTextStyle: TextStyle(fontSize: 14,color: notifier.blackcolor,fontWeight: FontWeight.w600,fontFamily: 'SofiaLight'),
              initialCountryCode: countryCode,
              onCountryChanged: (value) {
                setState(() {
                  mobileCheckApi.ccode  =  "+${value.dialCode}";
                });
              },
              onChanged: (phone) {

              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text("Back".tr,style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600),),
                ),
                const Spacer(),
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(0),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                    ),
                    onPressed: () {

                      forpassvalid(context, constraints);

                    }, child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6, right: 30, left: 30),
                  child: Text("Next".tr,style: const TextStyle(fontSize: 18,color: Colors.white,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600),),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
  forpassvalid(context, constraints){

      mobileCheckApi.mobileCheck(context, mobile.text).then((value) async {

          if(value["Result"] == "true"){

            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
              msg: value["ResponseMsg"],
              textColor: notifier.blackwhitecolor,
            );
          } else {
            Get.back();
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
              return Dialog(
                backgroundColor: notifier.whitecolor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: otpField(context, constraints),
              );
            },);
            // _signInWithMobileNumber1(context);
           temp = await FirebaseAuthentication().sendOTP(mobile.text, mobileCheckApi.ccode);
          }
      });

  }

  Widget otpField(context, constraints){
    return SizedBox(
      width: 390,
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter OTP'.tr,style: TextStyle(fontSize: 28,color: notifier.blackcolor,fontFamily: 'SofiaBold'),),
            const SizedBox(height: 40),
            OtpTextField(
              numberOfFields: 6,
              borderColor: const Color(0xFF512DA8),
              borderRadius: BorderRadius.circular(10),
              showFieldAsBox: true,
              decoration: InputDecoration(
                 focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: notifier.purplecolor,),borderRadius: BorderRadius.circular(10))
              ),
              fieldWidth: constraints.maxWidth < 600 ? 30 : 50,
              fieldHeight: constraints.maxWidth < 600 ? 30 : 50,
              onCodeChanged: (String code) {
              },
              onSubmit: (String verificationCode){
                pin = verificationCode;
                // showDialog(
                //     context: context,
                //     builder: (context){
                //       return AlertDialog(
                //         title: Text("Verification Code"),
                //         content: Text('Code entered is $verificationCode'),
                //       );
                //     }
                // );
              },
            ),
            const SizedBox(height: 20),
            Text("Re-send",style: TextStyle(fontSize: 14,color: notifier.purplecolor,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600),textAlign: TextAlign.end,),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text("Back".tr,style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600),),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(0),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                      ),
                      onPressed: () {
                        FirebaseAuthentication().authenticateMe(temp, pin).then((value){
                          if(value){
                            Get.back();
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: notifier.whitecolor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  child: changePass(context,constraints),
                                );
                              },);
                          } else {
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_LONG,
                              webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                              msg: 'Something Went wrong!'.tr,
                              textColor: notifier.blackwhitecolor,
                            );
                          }
                        });

                      }, child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 6, right: 30, left: 30),
                    child: Text("Next".tr,style: const TextStyle(fontSize: 18,color: Colors.white,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600),),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget changePass(context, constraints){
    return SizedBox(
      width: 350,
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Change Password'.tr,style: TextStyle(fontSize: 28,color: notifier.blackcolor,fontFamily: 'SofiaBold'),),
            const SizedBox(height: 30),
            TextField(
              controller: pass1,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 12),
                hintText: 'Enter new password'.tr,
                hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: notifier.sugestionbutton),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: notifier.sugestionbutton),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pass2,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 12),
                hintText: 'Re-Enter password'.tr,
                hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: notifier.sugestionbutton),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: notifier.sugestionbutton),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text("Back".tr,style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600),),
                ),
                const Spacer(),
                GetBuilder<LoginApiController>(
                  builder: (logInApi) {
                    return ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                        ),
                        onPressed: () {
                          if(pass1.text == pass2.text){
                            Get.back();
                            forgotPassApi.forgotPassword(context, mobile.text, pass2.text).then((value) {
                              showDialog(
                                context: context, builder: (context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    insetPadding: const EdgeInsets.all(20),
                                    child: const LoginDialog());
                              },
                              ).then((value) {
                                setState(() {
                                  logInApi.getlocaldata();
                                });
                              });
                              if(value["Result"] == "true"){
                                Fluttertoast.showToast(
                                  toastLength: Toast.LENGTH_LONG,
                                  webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                                  msg: value["ResponseMsg"],
                                  textColor: notifier.blackwhitecolor,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  toastLength: Toast.LENGTH_LONG,
                                  webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                                  msg: value["ResponseMsg"],
                                  textColor: notifier.blackwhitecolor,
                                );
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_LONG,
                              webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                              msg: "Password do not match",
                              textColor: notifier.blackwhitecolor,
                            );
                          }
                          forpassvalid(context,constraints);
                        }, child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6, right: 30, left: 30),
                      child: Text("Next".tr,style: const TextStyle(fontSize: 18,color: Colors.white,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600),),
                    ));
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
