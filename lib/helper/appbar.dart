
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigzagbus/apicontroller/bookinghistory.dart';
import 'package:zigzagbus/apicontroller/homelistapi.dart';
import 'package:zigzagbus/apicontroller/referapi.dart';
import 'package:zigzagbus/apicontroller/walletapi.dart';
import 'package:zigzagbus/apicontroller/walletreportapi.dart';
import 'package:zigzagbus/deshboard/faq.dart';
import 'package:zigzagbus/deshboard/myticket.dart';
import 'package:zigzagbus/deshboard/pagelist.dart';
import 'package:zigzagbus/deshboard/profile.dart';
import 'package:zigzagbus/deshboard/referandearn.dart';
import 'package:zigzagbus/deshboard/wallet.dart';
import 'package:zigzagbus/helper/signindialog.dart';
import 'package:zigzagbus/splash.dart';
import '../apicontroller/agentdatacontroller.dart';
import '../apicontroller/faqapi.dart';
import '../apicontroller/loginapicontroller.dart';
import '../apicontroller/mobilecheckcontroller.dart';
import '../apicontroller/searchbuscontroller.dart';
import '../apicontroller/signupapi.dart';
import '../deshboard/deshboard.dart';
import '../mediaquery/mq.dart';
import '../models/bookinghmodel.dart';
import 'colornotifier.dart';
import 'logindialog.dart';

class LocalappBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> gkey;
  const LocalappBar({super.key, required this.gkey});

  @override
  State<LocalappBar> createState() => _LocalappBarState();
}

class _LocalappBarState extends State<LocalappBar> {
  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fun();
    // logInApi.getlocaldata();
    // print(islogin);
    agentLogin.agentLogin(context);
    getIndex1();
  }

  List notNumber = ['2', '4', '6', '', '', ''];
  int selectedlang = 0;
  int ind = 0;
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
  List langcontries = ['USD', 'EUR', 'JPY', 'BTC'];
  int selectedlangCode = 0;
  String selectedContr = '';
  String sv = '';
  int inde = 0;


  bool searchHover = false;
  bool searchHover2 = false;
  bool searchHover3 = false;
  bool bHover = false;
  bool langHover = false;

  List notification = [
    'Get 50% off on your first trip, T&C apllied',
    'Go to goa ,and enjoy the crazy summer vacations with your friends.',
    'Get best hotels, and food in Amsterdam.',
    'Reach more places and get cashback upto 20%.',
    'Do instant and easy flight booking. and get relax.'
  ];
  List drawerItem = [];

  SignUpApi signUpApi = Get.put(SignUpApi());
  AgentDataController agentLogin = Get.put(AgentDataController());
  LoginApiController logInApi = Get.put(LoginApiController());
  MobileCkeckController mobileCheckApi = Get.put(MobileCkeckController());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  PageListApi pageListApi = Get.put(PageListApi());
  FaqApi faqApi = Get.put(FaqApi());
  ReferApi referApi = Get.put(ReferApi());
  BookingHistoryApi bookingHApi = Get.put(BookingHistoryApi());
  WalletApi walletApi = Get.put(WalletApi());
  WalletReportApi walletreportApi = Get.put(WalletReportApi());

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
  ];

  final List locale = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Spanish', 'locale': const Locale('sp', 'SPANISH')},
    {'name': 'Arabic', 'locale': const Locale('ar', 'ARABIC')},
    {'name': 'Hindi', 'locale': const Locale('hi', 'HINDI')},
    {'name': 'Gujarati', 'locale': const Locale('gu', 'GUJARATI')},
    {'name': 'Afrikaan', 'locale': const Locale('af', 'AFRIKAAN')},
    {'name': 'Bengali', 'locale': const Locale('be', 'BENGALI')},
    {'name': 'Indonesian', 'locale': const Locale('id', 'INDONESIAN')},
  ];
  int conditional = 0;
  String privacyPolicy = "";
  String termcondition = "";
  getPageListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    privacyPolicy = prefs.getString("policypolicy")!;
    termcondition = prefs.getString("termcondition")!;
  }

  updateLanguage(Locale locale) {
    // Get.back();
    // save("lan1", locale.countryCode);
    // save("lan2", locale.languageCode);
    setState(() {
      Get.updateLocale(locale);
    });
  }

  // LocaleModel? localeModel;

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

  getIndex1() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // selectedlangCode = prefs.getInt("index1")!;
  }
  bool focus = false;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: const Size.fromHeight(500),
      child: SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  color: notifier.whitecolor,
                  height: constraints.maxWidth < 500 ? 70 : 90,
                  alignment: constraints.maxWidth < 500
                      ? Alignment.center
                      : Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        constraints.maxWidth < 850
                            ? const SizedBox()
                            : const Spacer(),
                        Expanded(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(const deshscreen());
                                  setState((){
                                    searchBusApi.boardingId = null;
                                    searchBusApi.dropId = null;
                                    // searchBusApi.selectedDateAndTime = DateFormat('yyyy')-DateFormat('MM')-DateFormat('dd');
                                  });
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/logo/zigzagLogo.svg',
                                        height: constraints.maxWidth < 300
                                            ? 20
                                            : constraints.maxWidth < 500
                                            ? height / 30
                                            : constraints.maxWidth < 1600 ? height / 14
                                            : height / 20),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Zigzag',
                                      style: TextStyle(
                                        fontFamily: 'SofiaLight',
                                        fontWeight: FontWeight.w700,
                                        color: notifier.purplecolor,
                                        fontSize: constraints.maxWidth < 300
                                            ? 20
                                            : constraints.maxWidth < 500
                                            ? height / 50
                                            : height / 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (constraints.maxWidth < 600) InkWell(
                                onTap: () {
                                  widget.gkey.currentState!.openEndDrawer();
                                },
                                child: Row(
                                  children: [
                                    GetBuilder<LoginApiController>(builder: (logInApi) {
                                      return logInApi.isloginsucc ? Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(const ProfileandEdit());
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: notifier.grey04,),
                                              child: Text("${logInApi.userData["name"][0]}",style: TextStyle(fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22,fontFamily: 'SofiaLight')),
                                            ),
                                          ),
                                        ],
                                      )
                                          : Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context, builder: (context) {
                                                return Dialog(
                                                  backgroundColor: notifier.whitecolor,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                    child: const SigninDialog());
                                              },).then((value) {
                                                setState(() {
                                                  logInApi.getlocaldata();
                                                });
                                              });
                                            },
                                            child: Text('Sign up'.tr,
                                                style: TextStyle(
                                                    fontFamily: 'SofiaLight',
                                                    fontSize: 16,
                                                    color: notifier.purplecolor)),
                                          ),
                                          const SizedBox(width: 25),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              elevation:
                                              const MaterialStatePropertyAll(0),
                                              backgroundColor:
                                              MaterialStatePropertyAll(
                                                  notifier.purplecolor),
                                              shape: const MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(22)),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
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
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 9,bottom: 11,left: 8, right: 8),
                                              child: Text('Log in'.tr,
                                                  style: const TextStyle(
                                                      fontFamily: 'SofiaLight',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ],
                                      );
                                    },),
                                    const SizedBox(width: 20),
                                    SvgPicture.asset(
                                        'assets/Icons/tabs/drawerIcon.svg',colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
                                  ],
                                ),
                              ) else Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
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
                                    color: notifier.whitecolor,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/Icons/downloadIcon.svg',height: 20,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                                        const SizedBox(width: 6),
                                        Text('Download App'.tr,
                                          style: TextStyle(fontFamily: 'SofiaLight', fontSize: 16, color: notifier.blackcolor),),
                                      ],
                                    ),
                                    itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<SampleItem2>>[
                                      PopupMenuItem<SampleItem2>(
                                        enabled: true,
                                        value: SampleItem2.itemOne,
                                        onTap: () {},
                                        child: Row(children: [
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
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily:
                                                      'SofiaLight')),
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
                                                        color:
                                                        notifier.subgreycolor,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily:
                                                        'SofiaLight')),
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
                                  const SizedBox(width: 25),
                                  PopupMenuButton(
                                    tooltip: '',
                                    padding: const EdgeInsets.all(0),
                                    offset: Offset(rtl ? -70 : 40, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    // initialValue: selectedMenu,
                                    constraints: const BoxConstraints(
                                      maxWidth: 300,
                                      maxHeight: 400,
                                    ),
                                    color: notifier.whitecolor,
                                    child: AnimatedContainer(
                                      duration:
                                      const Duration(milliseconds: 200),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset("assets/Icons/earthIcon.svg",height: 20,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                                          const SizedBox(width: 6),
                                          Text('Language'.tr,
                                            style: TextStyle(fontFamily: 'SofiaLight', fontSize: 16, color: notifier.blackcolor),),
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
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: SizedBox(
                                              height: 260,
                                                width: 130,
                                                child:  ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: langImage.length,
                                                  itemBuilder: (context, index) {
                                                    return Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {

                                                            setState(() {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const deshscreen(),));
                                                              selectedlangCode =  index;
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
                                                                '${langImage[index]}',
                                                                height: 20,
                                                              ),
                                                              const SizedBox(
                                                                  width: 20),
                                                              Text(
                                                                  '${locale[index]['name']}',
                                                                  style: TextStyle(
                                                                      fontFamily: 'SofiaLight',
                                                                      fontSize: 16,
                                                                      color: selectedlangCode == index
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
                                                        const SizedBox(height: 10),
                                                      ],
                                                    );
                                                  },),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 25),
                                  GetBuilder<LoginApiController>(builder: (logInApi) {
                                    return logInApi.isloginsucc ? Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(const ProfileandEdit());
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: notifier.grey04,),
                                            child: Text("${logInApi.userData["name"][0]}",style: TextStyle(fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22,fontFamily: 'SofiaLight')),
                                          ),
                                        ),
                                      ],
                                    )
                                        : Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context, builder: (context) {
                                              return Dialog(
                                                backgroundColor: notifier.whitecolor,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                  child: const SigninDialog());
                                            },).then((value) {
                                              setState(() {
                                                logInApi.getlocaldata();
                                              });
                                            });
                                          },
                                          child: Text('Sign up'.tr,
                                              style: TextStyle(
                                                  fontFamily: 'SofiaLight',
                                                  fontSize: 16,
                                                  color: notifier.isDark ? notifier.blackcolor : notifier.purplecolor)),
                                        ),
                                        const SizedBox(width: 25),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            elevation:
                                            const MaterialStatePropertyAll(0),
                                            backgroundColor:
                                            MaterialStatePropertyAll(
                                                notifier.purplecolor),
                                            shape: const MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(22)),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
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
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 9,bottom: 11,left: 8, right: 8),
                                            child: Text('Log in'.tr,
                                                style: const TextStyle(
                                                    fontFamily: 'SofiaLight',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    );
                                  },),
                                  const SizedBox(width: 25),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return PopupMenuButton(
                                        tooltip: '',
                                        padding: const EdgeInsets.all(0),
                                        offset: Offset(rtl ? -120 : 100, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        // initialValue: selectedMenu,
                                        constraints: const BoxConstraints(
                                          maxWidth: 300,
                                          maxHeight: 530,
                                        ),
                                        color: notifier.whitecolor,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          child: SvgPicture.asset('assets/Icons/menuIcon.svg',colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
                                        ),
                                        itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<SampleItem2>>[
                                          PopupMenuItem<SampleItem2>(
                                            enabled: true,
                                            value: SampleItem2.itemOne,
                                            onTap: () {
                                              setState((){});
                                            },
                                            child: StatefulBuilder(
                                              builder: (context, setState) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 15),
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
                                                              // Get.to(const deshscreen());
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(menuItemImage[a],height: 20, colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                                                              const SizedBox(width: 20),
                                                              Text(
                                                                  '${mItems[a]}',
                                                                  style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, fontSize: 16, color: notifier.blackcolor),
                                                                  textAlign: TextAlign.start),
                                                              SizedBox(width: a == 5 ? 70 : 50,),
                                                              a == 5 ? SizedBox(
                                                                height: 29,
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
                                                                    Get.to(const deshscreen());
                                                                  },
                                                                ),
                                                              ) : const SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: a == 7 ? 15 : 20),
                                                      ]),
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
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                                ],
                               ),
                            ],
                          ),
                        ),
                        // const Spacer(flex: 2),
                        constraints.maxWidth < 850
                            ? const SizedBox()
                            : const Spacer(),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }
}