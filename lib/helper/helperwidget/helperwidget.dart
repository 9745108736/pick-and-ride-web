// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_typing_uninitialized_variables


import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:zigzagbus/apicontroller/pickdroppointcontroller.dart';
import 'package:zigzagbus/search/searchbus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../apicontroller/citylistcontroller.dart';
import '../../apicontroller/loginapicontroller.dart';
import '../../apicontroller/searchbuscontroller.dart';
import '../../mediaquery/mq.dart';
import '../colornotifier.dart';
import '../logindialog.dart';

class help extends StatefulWidget {
  const help({super.key});

  @override
  State<help> createState() => _helpState();
}

class _helpState extends State<help> {
  late ColorNotifier notifier;
  LoginApiController logInApi = Get.put(LoginApiController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cityListApi.cityList(context);
    getCitylistData();
    logInApi.getlocaldata();
    // if (searchBusApi.boardingId!.isNotEmpty && searchBusApi.dropId!.isNotEmpty) {
    //   suggestionTextFiledFrom.text = searchBusApi.boardingPoint!;
    //   suggestionTextFiledTo.text = searchBusApi.dropPoint!;
    //   // id = searchBusApi.boardingId!;
    //   // id2 = searchBusApi.dropId!;
    //   // print("{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{}$id");
    //   setState(() {});
    // }
  }

  CityListDataApi cityListApi = Get.put(CityListDataApi());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  PickDropController pickdropApi = Get.put(PickDropController());

  int tabHover = 0;

  void _onselectionChanged(DateRangePickerSelectionChangedArgs args) {}
  DateRangePickerController dateSelecter = DateRangePickerController();

  bool searchHover2 = false;

  String bordingId= "";
  String dropId= "";

  TextEditingController suggestionTextFiledFrom = TextEditingController();

  TextEditingController suggestionTextFiledTo = TextEditingController();

  var now = DateTime.now();

  late Map cityListMap;
  List cityList = [];

  var userData;


  getlocledata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userData  = jsonDecode(prefs.getString("loginDataall")!);
    setState(() {

    });
  }

  getCitylistData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    cityListMap = jsonDecode(prefs.getString("citylistdata") ?? "");

    cityList = cityListMap["citylist"];
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return panel(constraints, context);
      },
    );
  }

  Widget panel(constraints, context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Center(
        child: Container(
            decoration: BoxDecoration(
              color: notifier.whitecolor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: notifier.lightgreycolor,
                  spreadRadius: 8,
                  blurStyle: BlurStyle.outer,
                  offset: const Offset(0, 15),
                  blurRadius: 30,
                )
              ],
            ),
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 10, left: 12, right: 12,),
            child: flightTab(constraints),
          ),
        ),
      ),
    );
  }

  void buildDialog(constraints) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              color: notifier.whitecolor,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 300,
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SfDateRangePicker(
                controller: dateSelecter,
                enableMultiView: false,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  todayCellDecoration: BoxDecoration(
                      color: notifier.buttoncolor, shape: BoxShape.circle),
                  textStyle: TextStyle(
                    fontFamily: 'gilroymed',
                    color: notifier.subgreycolor,
                    fontSize: constraints.maxWidth < 550 ? 10 : 14,
                  ),
                  blackoutDateTextStyle: TextStyle(
                    fontFamily: 'gilroymed',
                    color: notifier.blackcolor,
                    fontSize: constraints.maxWidth < 550 ? 10 : 14,
                  ),
                  todayTextStyle: TextStyle(
                    fontFamily: 'gilroymed',
                    fontSize: constraints.maxWidth < 550 ? 10 : 14,
                    color: notifier.blackcolor,
                  ),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                        color: notifier.blackcolor,
                        fontFamily: 'gilroymed',
                        fontSize: constraints.maxWidth < 550 ? 10 : 14),
                  ),
                ),
                onSelectionChanged: _onselectionChanged,
                backgroundColor: notifier.whitecolor,
                view: DateRangePickerView.month,
                startRangeSelectionColor: notifier.blackcolor,
                endRangeSelectionColor: notifier.blackcolor,
                rangeSelectionColor: notifier.sugestionbutton,
                selectionColor: notifier.blackcolor,
                selectionRadius: 50,
                viewSpacing: 30,
                selectionTextStyle: TextStyle(
                    color: notifier.blackwhitecolor,
                    fontFamily: 'gilroymed',
                    fontSize: constraints.maxWidth < 550 ? 10 : 14),
                headerStyle: DateRangePickerHeaderStyle(
                  textStyle: TextStyle(
                      color: notifier.blackcolor,
                      fontFamily: 'gilroysemi',
                      fontSize: constraints.maxWidth < 550 ? 10 : 14),
                ),
                selectionMode: DateRangePickerSelectionMode.range,
                rangeTextStyle: TextStyle(
                    color: notifier.blackcolor,
                    fontFamily: 'gilroymed',
                    fontSize: constraints.maxWidth < 550 ? 10 : 14),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget flightTab(constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notifier.xlightPurplecolor,
                      ),
                      child: SvgPicture.asset('assets/Icons/location.svg',height: constraints.maxWidth > 1600 ? 16 : 8),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('From City'.tr, style: TextStyle(
                              fontFamily: 'SofiaLight',fontWeight: FontWeight.w600 ,color: notifier
                              .blackcolor, fontSize: constraints.maxWidth < 300 ? 8 : constraints.maxWidth < 500 ? 12 : 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // SizedBox(height: 8),
                          boardingTextField(constraints),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notifier.xlightPurplecolor,
                      ),
                      child: SvgPicture.asset('assets/Icons/location.svg',height: constraints.maxWidth > 1600 ? 16 : 8),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('To City'.tr, style: TextStyle(
                              fontFamily: 'SofiaLight',fontWeight: FontWeight.w600, color: notifier
                              .blackcolor, fontSize: constraints.maxWidth < 300 ? 8 : constraints.maxWidth < 500 ? 12 : 14),
                              overflow: TextOverflow.ellipsis
                          ),
                          // SizedBox(height: 8),
                          dropTextField(constraints),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
       rtl ? Positioned(
              left: 10,
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
                    border: Border.all(color: notifier.lightPurplecolor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: SvgPicture.asset('assets/Icons/tabs/exchangeVerticalIcon.svg',height: 14),
                  ),
                ),
              ),
            )
            : Positioned(
              right: 10,
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
                    border: Border.all(color: notifier.lightPurplecolor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: SvgPicture.asset('assets/Icons/tabs/exchangeVerticalIcon.svg',height: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            setState(() {
              selectDateAndTime(context);
            });
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notifier.xlightPurplecolor,
                      ),
                      child: SvgPicture.asset('assets/Icons/calendar.svg',height: constraints.maxWidth > 1600 ? 16 : 12),
                    ),
                    const SizedBox(width: 10),
                    Text('Date'.tr, style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SofiaLight', color: notifier
                        .blackcolor, fontSize: constraints.maxWidth < 300 ? 8 : constraints.maxWidth < 500 ? 12 : 14)),
                  ],
                ),
              ),
              Container(
                height: 30,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: notifier.lightPurplecolor,width: 1))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${DateFormat('yyyy').format(searchBusApi.selectedDateAndTime)}-${DateFormat('MM').format(searchBusApi.selectedDateAndTime)}-${DateFormat('dd').format(searchBusApi.selectedDateAndTime)}",
                      style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.blackcolor,fontSize: constraints.maxWidth < 300 ? 7 : constraints.maxWidth < 500 ? 12 : 14),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded,size: 16,color: notifier.blackcolor)
                  ],
                ),),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        GetBuilder<SearchBusApi>(builder: (searchBusApi) {
          return GetBuilder<LoginApiController>(builder: (logInApi){
            return InkWell(
              onTap: () {
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
                    Fluttertoast.showToast(
                      msg: "Please enter the Boarding / Drop Point".tr,
                    );
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "Please enter the Boarding / Drop Point".tr,
                  );
                }
              },
              // onHover: (value) {
              //   setState(() {
              //     searchHover2 = value;
              //   });
              // },
              child: AnimatedContainer(
                width: width / 1,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: searchHover2
                        ? Colors.indigoAccent.shade700
                        : notifier.purplecolor),
                child: Padding(
                  padding: EdgeInsets.only(top: constraints.maxWidth < 500 ? 10 : 15,bottom: constraints.maxWidth < 500 ? 10 : 15,left: constraints.maxWidth < 500 ? 10 : 25,right: constraints.maxWidth < 500 ? 10 : 25),
                  child: Text('Search'.tr,
                      style: TextStyle(color: Colors.white,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,fontSize: constraints.maxWidth < 500 ? 14 : 18
                      )
                  ),
                ),
              ),
            );
          },);
        },)
      ],
    );
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

  Widget dropTextField(constraints){
    Widget searchChild(f) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: Text(f["title"], style: TextStyle(
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
        onTap: () {
          getCitylistData();
        },
        suggestionItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16)
        ),
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

  final focus = FocusNode();
  final focus2 = FocusNode();

  Widget boardingTextField(constraints){
    Widget searchChild(x) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: Text(x["title"], style: TextStyle(
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
        suggestionItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16)
        ),
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
          contentPadding: const EdgeInsets.only(bottom: 10,left: 5),
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
}
