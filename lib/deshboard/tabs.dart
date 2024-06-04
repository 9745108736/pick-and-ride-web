
import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../apicontroller/agentdatacontroller.dart';
import '../apicontroller/citylistcontroller.dart';
import '../apicontroller/loginapicontroller.dart';
import '../apicontroller/mobilecheckcontroller.dart';
import '../apicontroller/pickdroppointcontroller.dart';
import '../apicontroller/searchbuscontroller.dart';
import '../apicontroller/signupapi.dart';
import '../helper/colornotifier.dart';
import '../helper/logindialog.dart';
import '../mediaquery/mq.dart';
import '../search/searchbus.dart';

class Tabsbar extends StatefulWidget {
  const Tabsbar({super.key});

  @override
  State<Tabsbar> createState() => _TabsbarState();
}

class _TabsbarState extends State<Tabsbar> {

  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cityListApi.cityList(context);

      logInApi.getlocaldata();

    // print(islogin);
    agentLogin.agentLogin(context);
  }

  CityListDataApi cityListApi = Get.put(CityListDataApi());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  SignUpApi signUpApi = Get.put(SignUpApi());
  AgentDataController agentLogin = Get.put(AgentDataController());
  LoginApiController logInApi = Get.put(LoginApiController());
  MobileCkeckController mobileCheckApi = Get.put(MobileCkeckController());
  PickDropController pickdropApi = Get.put(PickDropController());
  // String id = "";
  // String id2 = "";

  TextEditingController suggestionTextFiledFrom = TextEditingController();

  TextEditingController suggestionTextFiledTo = TextEditingController();

  bool searchHover2 = false;

  String bordingId= "";
  String dropId= "";

  DateRangePickerController dateSelecter = DateRangePickerController();
  var now = DateTime.now();

  late List<String> autoCompleteField;

  late Map cityListMap;
  List cityList = [];

  bool? islogin;


  int cpage = 0;
  int tabIndex = 0;

  getCitylistData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cityListMap = jsonDecode(prefs.getString("citylistdata") ?? "");

    cityList = cityListMap["citylist"];
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.only(left: constraints.maxWidth > 1600
            ? 100 : 50,right: constraints.maxWidth > 1600
            ? 100 :50),
        child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: notifier.whitecolor,
                  borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: notifier.isDark ? Colors.transparent : notifier.lightgreycolor,
                    spreadRadius: 8,
                    blurStyle: BlurStyle.outer,
                    offset: const Offset(0, 15),
                    blurRadius: 30,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: constraints.maxWidth < 1300 ? constraints.maxWidth / 52 : 50),
                child: flightTab(constraints),
              ),
            )
        ),
      );
    },);
  }

  Widget flightTab(constraints) {
    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: notifier.xlightPurplecolor,
                              ),
                              child: SvgPicture.asset('assets/Icons/location.svg',
                                  height: constraints.maxWidth > 1600 ? 16 : 12),
                            ),
                            const SizedBox(width: 10),
                            Text('From City'.tr,
                              style: TextStyle(
                                  fontFamily: 'SofiaLight',
                                  fontWeight: FontWeight.w600,
                                  color: notifier.blackcolor,
                                  fontSize: constraints.maxWidth > 1600
                                      ? 18
                                      : 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Spacer(),
                            Expanded(
                                flex: 10,
                                child: boardingTextField(constraints)),
                            const Spacer(flex: 4,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: 100,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      VerticalDivider(
                        color: notifier.lightPurplecolor,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              fun();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: notifier.xlightPurplecolor,
                              border:
                              Border.all(color: notifier.lightPurplecolor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: SvgPicture.asset(
                                  'assets/Icons/tabs/exchangeIcon.svg',
                                  height: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: constraints.maxWidth > 1600 ? 18 : 10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: notifier.xlightPurplecolor,
                            ),
                            child: SvgPicture.asset('assets/Icons/location.svg',
                                height: constraints.maxWidth > 1600 ? 16 : 12),
                          ),
                          const SizedBox(width: 10),
                          Text('To City'.tr,
                            style: TextStyle(
                                fontFamily: 'SofiaLight',
                                fontWeight: FontWeight.w600,
                                color: notifier.blackcolor,
                                fontSize: constraints.maxWidth > 1600
                                    ? 18
                                    : 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Spacer(),
                          Expanded(
                              flex: 10,
                              child: dropTextField(constraints)),
                          const Spacer(flex: 4,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  height: 100,
                  child: VerticalDivider(
                    color: notifier.lightPurplecolor,
                  )),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell(
                    onTap: () {
                      selectDateAndTime(context);
                    },
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: notifier.xlightPurplecolor,
                              ),
                              child: SvgPicture.asset(
                                  'assets/Icons/calendar.svg',
                                  height:
                                  constraints.maxWidth > 1600 ? 16 : 12),
                            ),
                            const SizedBox(width: 10),
                            Text('Date'.tr,
                                style: TextStyle(
                                    fontFamily: 'SofiaLight',
                                    fontWeight: FontWeight.w600,
                                    color: notifier.blackcolor,
                                    fontSize: constraints.maxWidth > 1600
                                        ? 18
                                        : 16)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: notifier.lightPurplecolor
                              )
                            )
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  "${DateFormat('yyyy').format(searchBusApi.selectedDateAndTime)}-${DateFormat('MM').format(searchBusApi.selectedDateAndTime)}-${DateFormat('dd').format(searchBusApi.selectedDateAndTime)}",
                                  style: TextStyle(
                                      fontFamily: 'SofiaLight',
                                      fontWeight: FontWeight.w600,
                                      color: notifier.blackcolor,
                                      fontSize: constraints.maxWidth < 1100
                                          ? 16
                                          : constraints.maxWidth > 1600
                                          ? 18
                                          : 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: constraints.maxWidth < 1000 ? 5 : 20),
        GetBuilder<SearchBusApi>(builder: (searchBusApi) {
          return GetBuilder<LoginApiController>(builder: (logInApi) {
            return InkWell(
              onTap: () async {

                if(logInApi.isloginsucc == false){
                  showDialog(context: context, builder: (context)  {

                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      insetPadding: const EdgeInsets.all(20),
                      child: const LoginDialog(),
                    );
                  },).then((value) {
                    setState(() {
                      logInApi.getlocaldata();
                      searchBusApi.boardingId = null;
                      searchBusApi.dropId = null;
                    });
                  });
                } else if (searchBusApi.boardingId != null  && searchBusApi.dropId != null) {

                  if (searchBusApi.boardingId! != searchBusApi.dropId!) {

                    searchBusApi.searchBus(context).then((value) {

                      if (searchBusApi.searchBusData!.busData.isNotEmpty) {
                        pickdropApi.pickdropPoint(context);
                      }
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const SearchBuses();
                        },
                      )).then((value) {
                        suggestionTextFiledFrom.text = searchBusApi.boardingPoint!;
                        suggestionTextFiledTo.text = searchBusApi.dropPoint!;
                        // id = searchBusApi.boardingId!;
                        // id2 = searchBusApi.dropId!;
                        setState(() {

                        });
                      });
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: notifier.blackcolor,
                        content: Text("Please enter the different Boarding & Drop Point".tr,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackwhitecolor, fontSize: 16, fontWeight: FontWeight.w600),), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: notifier.blackcolor,
                      content: Text("Please enter the Boarding / Drop Point".tr,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackwhitecolor, fontSize: 16, fontWeight: FontWeight.w600),), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                  );
                }
              },
              onHover: (value) {
                setState(() {
                  searchHover2 = value;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: notifier.purplecolor),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: constraints.maxWidth < 1100 ? 10 : 15,
                      bottom: constraints.maxWidth < 1100 ? 10 : 15,
                      left: constraints.maxWidth < 1100 ? 10 : 25,
                      right: constraints.maxWidth < 1100 ? 10 : 25),
                  child: Text(
                    'Search'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'SofiaLight',
                        fontWeight: FontWeight.w600,
                        fontSize: constraints.maxWidth < 1100 ? 16 : 20),
                  ),
                ),
              ),
            );
          },);
        },)
      ],
    );
  }

  void fun() {
    setState(() {
      var temp2 = bordingId;
      bordingId = dropId;
      dropId = temp2;

      var tempId = searchBusApi.boardingId!;
      searchBusApi.boardingId = searchBusApi.dropId;
      searchBusApi.dropId = tempId;

      var point = searchBusApi.boardingPoint;
      searchBusApi.boardingPoint = searchBusApi.dropPoint;
      searchBusApi.dropPoint = point;

      var temp = suggestionTextFiledFrom.text;
      suggestionTextFiledFrom.text = suggestionTextFiledTo.text;
      suggestionTextFiledTo.text = temp;
    });
  }

  Future<void> selectDateAndTime(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: searchBusApi.selectedDateAndTime,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff7D2AFF),
              onPrimary: Colors.white,
              onSurface: Color(0xff7D2AFF),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                // primary: Colors.black,
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != searchBusApi.selectedDateAndTime) {
      setState(() {
        searchBusApi.selectedDateAndTime = pickedDate;
      });
    }
  }

  String currentText = "";


  GlobalKey<AutoCompleteTextFieldState<dynamic>> key = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<dynamic>> key1 = GlobalKey();

  Widget dropTextField(constraints){
    Widget searchChild(f) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: Text(f["title"].toString(), style: TextStyle(
          color: notifier.blackcolor,
          fontFamily: 'SofiaLight',
          fontWeight: FontWeight.w600,
          fontSize: constraints.maxWidth < 1100
              ? 12
              : constraints.maxWidth > 1600
              ? 16
              : 14)),
    );
    return SizedBox(
      height: 30,
      child: SearchField(
        controller: suggestionTextFiledTo,
        marginColor: notifier.whitecolor,
        itemHeight: 30,
        onTap: (){
          getCitylistData();
        },
        searchStyle: TextStyle(
            color: notifier.blackcolor,
            fontFamily: 'SofiaLight',
            fontWeight: FontWeight.w600,
            fontSize: constraints.maxWidth < 1100 ? 12 : constraints.maxWidth > 1600 ? 16 : 14),
        searchInputDecoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 10,left: 5),
          hintText: 'To'.tr,
          hintStyle: TextStyle(
              color: notifier.blackcolor,
              fontFamily: 'SofiaLight',
              fontWeight: FontWeight.w600,
              fontSize: constraints.maxWidth < 1100 ? 12 : constraints.maxWidth > 1600 ? 16 : 14),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: notifier.lightPurplecolor)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: notifier.lightPurplecolor)),
        ),
        suggestionsDecoration: SuggestionDecoration(
          color: notifier.whitecolor
        ),
        suggestions: cityList.map((e) {
          return SearchFieldListItem(e["title"],item: e, child: searchChild(e));
        },).toList(),
        focusNode: focus2,
        onSuggestionTap: (SearchFieldListItem x) {
          setState(() {
            searchBusApi.dropId = x.item["id"];
            searchBusApi.dropPoint = x.item["title"];
          });
          focus2.unfocus();
        },
      ),
    );
  }



  Widget boardingTextField(constraints){
    Widget searchChild(f) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: Text(f["title"].toString(), style: TextStyle(
          color: notifier.blackcolor,
          fontFamily: 'SofiaLight',
          fontWeight: FontWeight.w600,
          fontSize: constraints.maxWidth < 1100
              ? 12
              : constraints.maxWidth > 1600
              ? 16
              : 14)),
    );
    return SizedBox(
      height: 30,
      child: SearchField(
        controller: suggestionTextFiledFrom,
          onTap: () {
            getCitylistData();
          },
          marginColor: notifier.whitecolor,
          itemHeight: 30,
          searchStyle: TextStyle(
              color: notifier.blackcolor,
              fontFamily: 'SofiaLight',
              fontWeight: FontWeight.w600,
              fontSize: constraints.maxWidth < 1100 ? 12 : constraints.maxWidth > 1600 ? 16 : 14),
          searchInputDecoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 10, left: 5),
            hintText: 'From'.tr,
            hintStyle: TextStyle(
                color: notifier.blackcolor,
                fontFamily: 'SofiaLight',
                fontWeight: FontWeight.w600,
                fontSize: constraints.maxWidth < 1100 ? 12 : constraints.maxWidth > 1600 ? 16 : 14),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: notifier.lightPurplecolor)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: notifier.lightPurplecolor)),
          ),
        suggestionsDecoration: SuggestionDecoration(
          color: notifier.whitecolor
        ),
          suggestions: cityList.map((e) {
            return SearchFieldListItem(e["title"],item: e, child: searchChild(e));
          },).toList(),
        focusNode: focus,
        onSuggestionTap: (SearchFieldListItem x) {
          setState(() {
            searchBusApi.boardingId = x.item["id"];
            searchBusApi.boardingPoint = x.item["title"];
          });
          focus.unfocus();
        },
      ),
    );
  }
  final focus = FocusNode();
  final focus2 = FocusNode();
}
