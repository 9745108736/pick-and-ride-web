
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zigzagbus/helper/logindialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../apicontroller/agentdatacontroller.dart';
import '../apicontroller/mobilecheckcontroller.dart';
import '../apicontroller/searchbuscontroller.dart';
import '../apicontroller/signupapi.dart';
import '../mediaquery/mq.dart';
import 'colornotifier.dart';
import 'helperwidget/firebaseauth.dart';

class SigninDialog extends StatefulWidget {
  const SigninDialog({super.key});

  @override
  State<SigninDialog> createState() => _SigninDialogState();
}

class _SigninDialogState extends State<SigninDialog> {
  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(islogin);
    agentLogin.agentLogin(context);
  }


  SignUpApi signUpApi = Get.put(SignUpApi());
  AgentDataController agentLogin = Get.put(AgentDataController());
  MobileCkeckController mobileCheckApi = Get.put(MobileCkeckController());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());

  List logsignLottie = [
    'assets/lottie/slider1.json',
    'assets/lottie/slider2.json',
    'assets/lottie/slider3.json',
    'assets/lottie/slider4.json',
  ];

  List lottieTitle = [
    "Your Journey, Your Way".tr,
    "Seamless Travel Simplified".tr,
    "Book, Ride, Enjoy".tr,
    "Explore, One Bus at a Time".tr
  ];

  List description = [
    'Customize your travel effortlessly.'.tr,
    'Easy booking and boarding for a stress-free journey.'.tr,
    'Swift booking and delightful bus rides.'.tr,
    'Discover new places, one bus ride after another.'.tr
  ];

  int cpage = 0;
  int tabIndex = 0;
  var getSignResponse;
  bool isSignup = false;

  String pin = "";
  var temp;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return signUpWidget(constraints);
    },);
  }

  Widget signUpWidget(constraints){
    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth < 500 ? 50 : 100,right: constraints.maxWidth < 500 ? 50 : 100,top: 10, bottom: 10),
                child: Column(
                  children: [
                    SvgPicture.asset('assets/logo/zigzagLogo.svg',height: 40),
                    Text('ZigzagBus',style: TextStyle(fontSize: 24,color: notifier.purplecolor,fontFamily: 'SofiaBold'),),
                    const SizedBox(height: 20),
                    Text('Sign Up on Zigzag'.tr,style: TextStyle(fontSize: 28,color: notifier.blackcolor,fontFamily: 'SofiaBold'),),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
              Container(child: carouselSlider(constraints)),
              Padding(
                padding: agentLogin.agentData?.agentStatus == "1" ? EdgeInsets.only(left: constraints.maxWidth < 500 ? 16 : 100,right: constraints.maxWidth < 500 ? 16 : 100, bottom: 20) :
                EdgeInsets.only(left: constraints.maxWidth < 500 ? 50 : 100,right: constraints.maxWidth < 500 ? 50 : 100,top: 10, bottom: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    agentLogin.agentData?.agentStatus == "1" ? TabBar(
                      indicatorColor: notifier.purplecolor,
                      onTap: (value) {
                        setState(() {
                          tabIndex = value;
                        });
                      },
                      tabs: [
                        Tab(
                          child: Text('User'.tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor,fontWeight: FontWeight.w600),),
                        ),
                        Tab(
                          child: Text('Agent'.tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor,fontWeight: FontWeight.w600),
                          ),),
                      ],
                    ) : const SizedBox(),
                    SizedBox(height: constraints.maxWidth < 500 ? 30 : 40,),
                    TextField(
                      controller: signUpApi.signName,
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 12),
                        hintText: 'Enter your Name'.tr,
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
                      controller: signUpApi.signEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 12),
                        hintText: 'Enter your Email'.tr,
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
                    IntlPhoneField(
                      controller: signUpApi.signMobile,
                      keyboardType: TextInputType.number,
                      disableLengthCheck: true,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
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
                      initialCountryCode: 'IN',
                      onCountryChanged: (value) {
                        setState(() {
                          signUpApi.ccode  =  value.dialCode;
                        });
                      },
                      onChanged: (phone) {

                      },
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: signUpApi.signPass,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 12),
                        hintText: 'Enter Password'.tr,
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
                      controller: signUpApi.referalCode,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 12),
                        hintText: 'Enter Referral Code (optional)'.tr,
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
                    SizedBox(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                            elevation: const MaterialStatePropertyAll(0),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))
                        ),
                        onPressed: () async {


                          callSignUp(constraints);


                          (agentLogin.agentData!.agentStatus == tabIndex.toString()) ? signUpApi.userType = "AGENT" : signUpApi.userType = "USER";

                        }, child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('Sign Up'.tr,style: const TextStyle(fontFamily: 'SofiaBold',color: Colors.white,fontSize: 16,)),
                      ),
                      ),
                    ),
                    SizedBox(height: constraints.maxWidth < 500 ? 20 : 30),
                    RichText(
                        text: TextSpan(
                            text: "Already have an account ".tr,
                            style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Get.back();
                                  showDialog(
                                    context: context, builder: (context) {
                                    return Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        insetPadding: const EdgeInsets.all(20),
                                        child: const LoginDialog());
                                  },
                                  );
                                },
                                text: 'Log In'.tr,
                                style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),
                              )
                            ]
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  callSignUp(constraints){
    if(signUpApi.signMobile.text.length == 10){

      mobileCheckApi.mobileCheck(context,signUpApi.signMobile.text).then((value) async {

        if (signUpApi.signMobile.text.isNotEmpty) {

          if(value["Result"] == "true"){

            if(signUpApi.signName.text.isNotEmpty && signUpApi.signEmail.text.isNotEmpty && signUpApi.signMobile.text.isNotEmpty && signUpApi.signPass.text.isNotEmpty){

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
              temp = await FirebaseAuthentication().sendOTP(signUpApi.signMobile.text);

            } else {
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_LONG,
                webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                msg: 'Something Went wrong!'.tr,
                textColor: notifier.blackwhitecolor,
              );
          }
            } else {
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
              msg: 'Something Went wrong! Please try again'.tr,
              textColor: notifier.blackwhitecolor,
            );
          }
        } else {
          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
            msg: 'Something Went wrong!'.tr,
            textColor: notifier.blackwhitecolor,
          );
        }

      });
      // Get.back();
    } else {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
        msg: 'Something Went wrong!'.tr,
        textColor: notifier.blackwhitecolor,
      );
    }
  }

  Widget carouselSlider(constraints){
    return  CarouselSlider(
        items: [
          for (int a = 0; a < logsignLottie.length; a++)
            Padding(
              padding: const EdgeInsets.only(right: 6, left: 12),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(right: 5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Lottie.asset( logsignLottie[a],height: constraints.maxWidth < 500 ? 160 : 180)
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(lottieTitle[a],style: TextStyle(fontFamily: 'SofiaBold',color: notifier.blackcolor,fontSize: 16),textAlign: TextAlign.center),
                  const SizedBox(height: 5),
                  Container(width: 60,color: notifier.purplecolor,height: 1.5),
                  const SizedBox(height: 10),
                  Text(description[a],style: TextStyle(fontFamily: 'SofiaLight',color: notifier.subgreycolor,fontSize: 12),textAlign: TextAlign.center,),
                ],
              ),
            ),
        ],
        options: CarouselOptions(
          viewportFraction: 0.99,
          initialPage: 0,
          onPageChanged: (index, reason) {
            cpage = index;
            setState(() {});
          },
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          height: constraints.maxWidth < 500 ? 230 : 250,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(seconds: 2),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0,
          scrollDirection: Axis.horizontal,
        ));
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
            // OTPTextField(
            //   length: 5,
            //   width: MediaQuery.of(context).size.width,
            //   fieldWidth: 80,
            //   style: TextStyle(
            //       fontSize: 17
            //   ),
            //   textFieldAlignment: MainAxisAlignment.spaceAround,
            //   fieldStyle: FieldStyle.underline,
            //   onCompleted: (pin) {
            //     print("Completed: " + pin);
            //   },
            // ),
            // OTPTextField(
            //   controller: otpcont,
            //   length: 6,
            //   width: MediaQuery.of(context).size.width,
            //   fieldWidth: 30,
            //   style: TextStyle(
            //       fontSize: 17
            //   ),
            //   textFieldAlignment: MainAxisAlignment.spaceAround,
            //   onCompleted: (pin) {
            //       otpPin = pin;
            //     print("Completed: " + pin);
            //   },
            // ),
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
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_LONG,
                              webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                              msg: 'Something Went wrong!'.tr,
                              textColor: notifier.blackwhitecolor,
                            );
                            Get.back();
                          } else {
                            signUpApi.signUpWithMobile(context).then((value) {
                              if(value["Result"] == "true"){
                                Fluttertoast.showToast(
                                  toastLength: Toast.LENGTH_LONG,
                                  webBgColor: notifier.isDark
                                      ? "linear-gradient(to right, #ffffff, #ffffff)"
                                      : "linear-gradient(to right, #000000, #000000)",
                                  msg: value["ResponseMsg"],
                                  textColor: notifier.blackwhitecolor,
                                );
                              } else { Fluttertoast.showToast(
                                toastLength: Toast.LENGTH_LONG,
                                webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                                msg: value["ResponseMsg"],
                                textColor: notifier.blackwhitecolor,
                              );
                              }
                            });
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
}
