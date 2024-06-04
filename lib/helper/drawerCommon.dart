// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigzagbus/apicontroller/bookinghistory.dart';
import 'package:zigzagbus/apicontroller/homelistapi.dart';
import 'package:zigzagbus/deshboard/deshboard.dart';
import 'package:zigzagbus/deshboard/myticket.dart';

import '../apicontroller/agentdatacontroller.dart';
import '../apicontroller/faqapi.dart';
import '../apicontroller/loginapicontroller.dart';
import '../apicontroller/mobilecheckcontroller.dart';
import '../apicontroller/referapi.dart';
import '../apicontroller/searchbuscontroller.dart';
import '../apicontroller/signupapi.dart';
import '../apicontroller/walletapi.dart';
import '../apicontroller/walletreportapi.dart';
import '../deshboard/faq.dart';
import '../deshboard/pagelist.dart';
import '../deshboard/profile.dart';
import '../deshboard/referandearn.dart';
import '../deshboard/wallet.dart';
import '../mediaquery/mq.dart';
import '../models/bookinghmodel.dart';
import '../splash.dart';
import 'colornotifier.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({super.key});

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fun();
    // print(islogin);
    // agentLogin.agentLogin(context);
  }

  List menuItemImage = [
    "assets/Icons/userIcon.svg",
    "assets/Icons/ticketIcon.svg",
    "assets/Icons/walletIcon.svg",
    "assets/Icons/referIcon.svg",
    "assets/Icons/chatIcon.svg",
    "assets/Icons/moonIcon.svg",
    "assets/Icons/noteIcon.svg",
    "assets/Icons/noteIcon.svg",
    "assets/Icons/noteIcon.svg",
    "assets/Icons/noteIcon.svg",
  ];

  List mItems = [
    "Personal Info".tr,
    "My Ticket".tr,
    "My Wallet".tr,
    "Refer and Earn".tr,
    "Faq",
    "Dark Mode".tr,
    "Privacy Policy".tr,
    "Term & Conditions".tr,
    "Contact Us".tr,
    "Cancellation Policy".tr,
    "",
    ""
  ];

  final List locale = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Spanish', 'locale': const Locale('sp', 'SPANISH')},
    {'name': 'Arabic', 'locale': const Locale('ar', 'ARABIC')},
    {'name': 'Hindi', 'locale': const Locale('hi', 'HINDI')},
    {'name': 'Gujarati', 'locale': const Locale('gu', 'GUJARATI')},
    {'name': 'Afrikaan', 'locale': const Locale('af', 'AFRIKAAN')},
    {'name': 'Bengali', 'locale': const Locale('be', 'BENGALI')},
    {'name': 'Indonesian', 'locale': const Locale('in', 'INDO')},
  ];

  updateLanguage(Locale locale) {
    // Get.back();
    // save("lan1", locale.countryCode);
    // save("lan2", locale.languageCode);
    setState(() {
      Get.updateLocale(locale);
    });
  }
  SignUpApi signUpApi = Get.put(SignUpApi());
  AgentDataController agentLogin = Get.put(AgentDataController());
  LoginApiController logInApi = Get.put(LoginApiController());
  MobileCkeckController mobileCheckApi = Get.put(MobileCkeckController());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  BookingHistoryApi bookingHApi = Get.put(BookingHistoryApi());
  PageListApi pageListApi = Get.put(PageListApi());
  FaqApi faqApi = Get.put(FaqApi());
  ReferApi referApi = Get.put(ReferApi());
  WalletApi walletApi = Get.put(WalletApi());
  WalletReportApi walletreportApi = Get.put(WalletReportApi());

  List profilemenuTags = [
    'Booking'.tr,
    'Wishlist',
    'Message',
    'Host your home',
    'Host an experience',
    'Help',
    'Service',
    'About Us',
    'Contact'
  ];

  List notification = [
    'Get 50% off on your first trip, T&C apllied',
    'Go to goa ,and enjoy the crazy summer vacations with your friends.',
    'Get best hotels, and food in Amsterdam.',
    'Reach more places and get cashback upto 20%.',
    'Do instant and easy flight booking. and get relax.'
  ];

  List langImage = [
    'assets/langcount/L-English.png',
    'assets/langcount/L-Spanish.png',
    'assets/langcount/L-Arabic.png',
    'assets/langcount/L-Hindi-Gujarati.png',
    'assets/langcount/L-Hindi-Gujarati.png',
    'assets/langcount/L-Afrikaans.png',
    'assets/langcount/L-Bengali.png',
    'assets/langcount/L-Indonesion.png',
  ];

  int conditional = 0;
  int selectedlangCode = 0;

  fun() async {
    for(int a= 0 ; a < locale.length;a++){
      if(locale[a]["locale"].toString().compareTo(Get.locale.toString()) == 0){
        setState(() {
          selectedlangCode = a;
        });

      }else{
      }
    }

    // final prefs = await SharedPreferences.getInstance();
    // localeModel = LocaleModel(prefs);
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return Drawer(
        backgroundColor: notifier.whitecolor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20,left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 15),
                        for (int a = logInApi.isloginsucc ? 0 : 5 ; a < menuItemImage.length; a++)
                          Column(children: [
                            InkWell(
                              onTap: () {
                                setState((){
                                  conditional = a;
                                });
                                if(conditional == 6){
                                  pageListApi.cancellationPolicy(context).then((value) {
                                    Get.to(const Pagelist());
                                  });
                                } else if(conditional == 7) {
                                  pageListApi.cancellationPolicy(context).then((value) {
                                    Get.to(const TermCondition());
                                  });
                                } else if(conditional == 8) {
                                  pageListApi.cancellationPolicy(context).then((value) {
                                    Get.to(const Contactus());
                                  });
                                } else if(conditional == 9){
                                  pageListApi.cancellationPolicy(context).then((value) {
                                    Get.to(const CancelPol());
                                  });
                                }else if(conditional == 4){
                                  faqApi.faqfun(context).then((value) {
                                    Get.to(const Faqpage());
                                  });
                                } else if(conditional == 3){
                                  referApi.referandEarn(context).then((value) {
                                    Get.to(const ReferEarn());
                                  });
                                } else if(conditional == 1){
                                  bookingHApi.bookinghistory(context, "Pending").then((value) {
                                    setState(() {
                                      bookingHApi.bookingHData = bookingHistoryModelFromJson(value);
                                    });
                                    bookingHApi.bookinghistory(context, "Completed").then((value) {
                                      setState(() {
                                        bookingHApi.bookingHDataComp =  bookingHistoryModelFromJson(value);
                                      });
                                      bookingHApi.bookinghistory(context, "cancel").then((value) {
                                        setState(() {
                                          bookingHApi.bookingHDataCanc =  bookingHistoryModelFromJson(value);
                                          Get.to(const Mytickets());

                                        });
                                      });
                                    });
                                  });
                                } else if(conditional == 2){
                                  walletreportApi.walletReport(context).then((value) {
                                    Get.to(const WalletScreen());
                                  });
                                } else if(conditional == 0){
                                  Get.to(const ProfileandEdit());
                                } else if(conditional == 5){
                                  setState((){
                                    if(notifier.isDark == false){
                                      notifier.isAvailable(true);
                                    } else {
                                      notifier.isAvailable(false);
                                    }
                                  });
                                  Get.back();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(menuItemImage[a],height: 20, colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                                      const SizedBox(width: 20),
                                      Text(
                                          '${mItems[a]}',
                                          style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, fontSize: 16, color: notifier.blackcolor),
                                          textAlign: TextAlign.start),
                                    ],
                                  ),
                                  a == 5 ? SizedBox(
                                    height: 29,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: FlutterSwitch(
                                        height: 23.0,
                                        width: constraints.maxWidth < 300 ? 40.0 : 45.0,
                                        padding: 4.0,
                                        toggleSize: 16.0,
                                        borderRadius: 15.0,
                                        inactiveToggleColor: notifier.buttoncolor,
                                        activeColor: notifier.buttoncolor,
                                        inactiveColor: notifier.sugestionbutton,
                                        value: notifier.isDark,
                                        onToggle: (bool value) {
                                          setState(() {
                                            notifier.isAvailable(value);
                                          });
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ) : const SizedBox(),
                                ],
                              ),
                            ),

                            SizedBox(height: a == 7 ? 15 : 20),
                          ]),
                        PopupMenuButton(
                          tooltip: '',
                          padding: const EdgeInsets.all(0),
                          offset: Offset(rtl ? -70 : 120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // initialValue: selectedMenu,
                          constraints: const BoxConstraints(
                            maxWidth: 315,
                            maxHeight: 270,
                          ),
                          color: notifier.backgroundColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/Icons/downloadIcon.svg',height: 20,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                              const SizedBox(width: 20,),
                              Text('Download App'.tr,
                                style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, fontSize: 16, color: notifier.blackcolor),),
                            ],
                          ),
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SampleItem2>>[
                            PopupMenuItem<SampleItem2>(
                              enabled: true,
                              value: SampleItem2.itemOne,
                              onTap: () {},
                              child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        Text('Download App'.tr,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                notifier.subgreycolor,
                                                fontFamily:
                                                'gilroysemi')),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: 100,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              SvgPicture.asset(
                                                  'assets/deshboard/support/AppStoreBadge.svg',
                                                  height: 40),
                                              const SizedBox(height: 10),
                                              SvgPicture.asset(
                                                  'assets/deshboard/support/GooglePlayStoreBadge.svg',
                                                  height: 40),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                    const SizedBox(width: 30),
                                    Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text('Scan Code'.tr,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: notifier
                                                      .subgreycolor,
                                                  fontFamily:
                                                  'gilroysemi')),
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            height: 100,
                                            child: Image.asset(
                                                'assets/deshboard/support/qrCode.png',
                                                height: 100),
                                          ),
                                          const SizedBox(height: 20),
                                        ]),
                                    const SizedBox(width: 10),
                                  ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        PopupMenuButton(
                          tooltip: '',
                          padding: const EdgeInsets.all(0),
                          offset: Offset(rtl ? 90 : -100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // initialValue: selectedMenu,
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                            maxHeight: 250,
                          ),
                          color: notifier.whitecolor,
                          child: AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 200),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/Icons/earthIcon.svg",height: 20,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                                const SizedBox(
                                    width: 20),
                                Text('Language'.tr,
                                  style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, fontSize: 16, color: notifier.blackcolor),),
                              ],
                            ),
                          ),
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SampleItem2>>[
                            PopupMenuItem<SampleItem2>(
                              enabled: true,
                              value: SampleItem2.itemOne,
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 25),
                                            for (int a = 0; a < langImage.length; a++)
                                              Column(children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const deshscreen(),));
                                                      selectedlangCode =  a;
                                                      updateLanguage(locale[selectedlangCode]['locale']);
                                                      if (selectedlangCode == 2) {
                                                        rtl = true;
                                                      } else {
                                                        rtl = false;
                                                      }
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(width: 10),
                                                      Image.asset(
                                                        '${langImage[a]}',
                                                        height: 20,
                                                      ),
                                                      const SizedBox(
                                                          width: 20),
                                                      Text(
                                                          '${locale[a]['name']}',
                                                          style: TextStyle(
                                                              fontFamily: 'SofiaLight',
                                                              fontSize: 16,
                                                              color: selectedlangCode == a
                                                                  ? notifier
                                                                  .buttoncolor
                                                                  : notifier
                                                                  .subgreycolor),
                                                          textAlign:
                                                          TextAlign
                                                              .start),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: 20),
                                              ]),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(width: 50),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        logInApi.isloginsucc ? Column(
                          children: [
                            Divider(color: notifier.sugestionbutton),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  String getdata = "";
                                  prefs.setString("loginDataall", getdata);
                                  prefs.setBool("islogin", false);
                                  logInApi.getlocaldata();
                                });
                                homeApi.homepage().then((value) {
                                  Get.to(const Splash());
                                });

                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/Icons/logoutIcon.svg",height: 20,),
                                  const SizedBox(width: 20),
                                  Text("Logout".tr,style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, fontSize: 16, color: notifier.redcolor),
                                      textAlign: TextAlign.start),
                                ],
                              ),
                            ),
                          ],
                        ) : const SizedBox(),
                        SizedBox(height: logInApi.isloginsucc ? 15 : 0),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },);
  }
}
