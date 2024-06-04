import 'dart:core';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/helper/signindialog.dart';

import '../apicontroller/loginapicontroller.dart';
import '../apicontroller/mobilecheckcontroller.dart';
import '../apicontroller/searchbuscontroller.dart';
import '../mediaquery/mq.dart';
import 'colornotifier.dart';
import 'helperwidget/forgotpass.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  late ColorNotifier notifier;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(islogin);
  }


  LoginApiController logInApi = Get.put(LoginApiController());
  MobileCkeckController mobileCheckApi = Get.put(MobileCkeckController());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  HomeApiController homeApi = Get.put(HomeApiController());

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
    'Discover new places, one bus ride after another.'.tr,
  ];

  int cpage = 0;

  int tabIndex = 0;

  bool islogin = false;



  bool isloadCarousel = true;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return logInWidget(constraints);
    },);
  }
  Widget logInWidget(constraints){
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
          color: notifier.whitecolor,
          borderRadius: BorderRadius.circular(14)
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10,left: constraints.maxWidth < 500 ? 10 : 100,right: constraints.maxWidth < 500 ? 10 : 100,bottom: 10),
                child: Column(
                  children: [
                    SvgPicture.asset('assets/logo/zigzagLogo.svg',height: 40),
                    Text('ZigzagBus',style: TextStyle(fontSize: 24,color: notifier.purplecolor,fontFamily: 'SofiaBold'),),
                    const SizedBox(height: 20),
                    Text('Log In on Zigzag'.tr,style: TextStyle(fontSize: 28,color: notifier.blackcolor,fontFamily: 'SofiaBold'),),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),

              Container(child: carouselSlider(constraints)),

              Padding(
                padding: EdgeInsets.only(top: 10,left: constraints.maxWidth < 500 ? 16 : 100,right: constraints.maxWidth < 500 ? 16 : 100,bottom: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    IntlPhoneField(
                      keyboardType: TextInputType.number,
                      disableLengthCheck: true,
                      controller: logInApi.logMobile,
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
                          logInApi.ccode = value.dialCode;
                        });
                      },
                      onChanged: (phone) {
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: logInApi.logPass,
                      obscureText: true,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
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
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {
                              Get.back();
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                return Dialog(
                                  backgroundColor: notifier.whitecolor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  child: const ForgotPassword(),
                                );
                              },);
                            },
                            child: Text('Forgot Password'.tr, style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14,fontWeight: FontWeight.w600),))),
                    SizedBox(height: constraints.maxWidth < 500 ? 30 : 40),
                    Container(
                      alignment: Alignment.center,
                      width: 140,
                      child: GetBuilder<LoginApiController>(builder: (logInApi) {
                        return ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                              elevation: const MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))
                          ),
                          onPressed: () {

                            logInVerify();
                            setState(() {

                            });
                          }, child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Center(child: Text('Log In'.tr,style: const TextStyle(fontFamily: 'SofiaBold',color: Colors.white,fontSize: 16,))),
                        ),
                        );
                      },)
                    ),
                    SizedBox(height: constraints.maxWidth < 500 ? 20 : 30),
                    RichText(text: TextSpan(
                        text: "Don't have an account yet? ".tr,
                        style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Get.back();
                              showDialog(
                                context: context, builder: (context) {
                                return Dialog(
                                  backgroundColor: notifier.whitecolor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    insetPadding: const EdgeInsets.all(20),
                                    child: const SigninDialog());
                              },).then((value) {
                                setState(() {
                                  const SigninDialog();
                                });
                              });
                            },
                            text: 'SignUp'.tr,
                            style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14,fontWeight: FontWeight.w700),
                          )
                        ]
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logInVerify(){
    if(logInApi.logMobile.text.length == 10){

      mobileCheckApi.mobileCheck(context,logInApi.logMobile.text).then((value) {

        if (logInApi.logMobile.text.isNotEmpty) {

          if(value["Result"] == "false") {

            if (logInApi.logMobile.text.isNotEmpty && logInApi.logPass.text.isNotEmpty) {

              logInApi.logIn(context).then((value) {
                if(value["Result"] == "true"){
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_LONG,
                    webBgColor: notifier.isDark
                        ? "linear-gradient(to right, #ffffff, #ffffff)"
                        : "linear-gradient(to right, #000000, #000000)",
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
                msg: 'Something Went wrong!'.tr,
                textColor: notifier.blackwhitecolor,
              );
            }
          } else {
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
              msg: 'Mobile number already used!'.tr,
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
                  Text(lottieTitle[a],style: TextStyle(fontFamily: 'SofiaBold',color: notifier.blackcolor,fontSize: 16),textAlign: TextAlign.center,),
                  const SizedBox(height: 5),
                  Container(width: 60,color: notifier.purplecolor,height: 1.5),
                  const SizedBox(height: 10),
                  Text(description[a],style: TextStyle(fontFamily: 'SofiaLight',color: notifier.subgreycolor,fontSize: 12),textAlign: TextAlign.center),
                ],
              ),
            )
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
          height: constraints.maxWidth < 500 ? 230 : 250,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(seconds: 2),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0,
          scrollDirection: Axis.horizontal,
        ));
  }

  signUpWidget(constraints) {}
}
