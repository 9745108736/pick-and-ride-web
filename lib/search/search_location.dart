import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:zigzagbus/apicontroller/citylistcontroller.dart';
import 'package:zigzagbus/apicontroller/pickdroppointcontroller.dart';
import 'package:zigzagbus/apicontroller/searchbuscontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:zigzagbus/search/searchbus.dart';

import '../helper/colornotifier.dart';
import '../mediaquery/mq.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // cityListApi.cityList(context);

    getCitylistData();
    suggestionTextFiledFrom.text = searchBusApi.boardingPoint!;
    suggestionTextFiledTo.text = searchBusApi.dropPoint!;
    // id =searchBusApi.boardingId!;
    // id2 =searchBusApi.dropId!;
    setState(() {

    });
  }

  CityListDataApi cityListApi = Get.put(CityListDataApi());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  PickDropController pickdropApi = Get.put(PickDropController());
  // String id = "";
  // String id2 = "";

  bool searchHover2 = false;


  String bordingId = "";
  String dropId = "";


  TextEditingController suggestionTextFiledFrom = TextEditingController();

  TextEditingController suggestionTextFiledTo = TextEditingController();

  DateRangePickerController dateSelecter = DateRangePickerController();
  var now = DateTime.now();

  var selectedDateAndTime = DateTime.now();

  late Map cityListMap;
  List cityList = [];

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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth < 900 ? searchPoint2(constraints) : searchPoint(constraints);
    });
  }

  Widget searchPoint2(constraints){
    return Padding(
        padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: 65,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: notifier.lightPurplecolor,
                        ),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
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
                                    fontSize: constraints.maxWidth < 300 ? 10 : constraints.maxWidth < 500 ? 12 : 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 25 ),
                              Expanded(child: boardingTextField(constraints),)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 65,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: notifier.lightPurplecolor,
                        ),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10,
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
                                    fontSize: constraints.maxWidth < 300 ? 10 : constraints.maxWidth < 500 ? 12 : 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 25 ),
                              Expanded(
                                  child: dropTextField(constraints)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 50,
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
                          'assets/Icons/tabs/exchangeVerticalIcon.svg',
                          height: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 65,
            decoration: BoxDecoration(
                border: Border.all(
                  color: notifier.lightPurplecolor,
                ),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,top: 10,),
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
                              height: constraints.maxWidth > 1600 ? 16 : 12),
                        ),
                        const SizedBox(width: 10),
                        Text('Date'.tr,
                            style: TextStyle(
                                fontFamily: 'SofiaLight',
                                fontWeight: FontWeight.w600,
                                color: notifier.blackcolor,
                                fontSize: constraints.maxWidth < 300 ? 10 : constraints.maxWidth < 500 ? 12 : 16)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 20,
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            "${DateFormat('yyyy').format(searchBusApi.selectedDateAndTime)}-${DateFormat('MM').format(searchBusApi.selectedDateAndTime)}-${DateFormat('dd').format(searchBusApi.selectedDateAndTime)}",
                            style: TextStyle(
                                fontFamily: 'SofiaLight',
                                fontWeight: FontWeight.w600,
                                color: notifier.blackcolor,
                                fontSize: constraints.maxWidth < 300 ? 10 : constraints.maxWidth < 500 ? 10 : 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              if (searchBusApi.boardingId != null  && searchBusApi.dropId != null) {

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
                      content: Text("Please enter the same Boarding & Drop Point".tr,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackwhitecolor, fontSize: 16, fontWeight: FontWeight.w600),), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
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
            child: AnimatedContainer(
              width: width / 1,
              height: 65,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: searchHover2
                      ? Colors.indigoAccent.shade700
                      : notifier.purplecolor),
              child: Text(
                'Search'.tr,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SofiaLight',
                    fontWeight: FontWeight.w600,
                    fontSize: constraints.maxWidth < 1100 ? 16 : 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget searchPoint(constraints) {
    return Padding(
      padding: EdgeInsets.only(left: constraints.maxWidth < 1100 ? 10 : 0,right: constraints.maxWidth < 1100 ? 10 : 0),
      child: Row(
        children: [
          constraints.maxWidth < 1100 ? const SizedBox() : const Spacer(),
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: constraints.maxWidth < 1100 ? 3 :  2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: constraints.maxWidth < 1600 ? 65 : 80,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: notifier.lightPurplecolor,
                                ),
                                borderRadius: BorderRadius.circular(constraints.maxWidth < 1600 ? 20 : 28)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 10
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
                                                  ? 16
                                                  : 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                            flex: constraints.maxWidth > 1600 ? 11 : 9,
                                            child: boardingTextField(constraints)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: constraints.maxWidth < 1600 ? 65 : 80,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: notifier.lightPurplecolor,
                                  ),
                                  borderRadius: BorderRadius.circular(constraints.maxWidth < 1600 ? 20 : 28),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 10,
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
                                              fontSize: constraints.maxWidth < 900
                                                  ? 16
                                                  : constraints.maxWidth > 1600
                                                  ? 16
                                                  : 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                          flex: constraints.maxWidth > 1600 ? 11 : 9,
                                            child: dropTextField(constraints)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: constraints.maxWidth < 1600 ? 65 : 80,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: notifier.lightPurplecolor,
                        ),
                        borderRadius: BorderRadius.circular(constraints.maxWidth < 1600 ? 20 : 28)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,top: 10,),
                      child: InkWell(
                        onTap: () {
                          selectDateAndTime(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        fontSize: constraints.maxWidth < 900
                                            ? 18
                                            : constraints.maxWidth > 1600
                                                ? 16
                                                : 14)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                height: 20,
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Text(
                                      "${DateFormat('yyyy').format(searchBusApi.selectedDateAndTime)}-${DateFormat('MM').format(searchBusApi.selectedDateAndTime)}-${DateFormat('dd').format(searchBusApi.selectedDateAndTime)}",
                                      style: TextStyle(
                                          fontFamily: 'SofiaLight',
                                          fontWeight: FontWeight.w600,
                                          color: notifier.blackcolor,
                                          fontSize: constraints.maxWidth < 1100
                                              ? 16
                                              : constraints.maxWidth > 1600
                                                  ? 16
                                                  : 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: constraints.maxWidth < 1000 ? 5 : 20),
          GetBuilder<PickDropController>(
            builder: (pickdropApi) {
              return Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    if (searchBusApi.boardingId != null  && searchBusApi.dropId != null) {

                      if (searchBusApi.boardingId != searchBusApi.dropId) {

                        searchBusApi.searchBus(context).then((value) {

                          if (searchBusApi.searchBusData!.busData.isNotEmpty) {
                            pickdropApi.pickdropPoint(context).then((value) {

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
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: notifier.blackcolor,
                            content: Text("Please enter the same Boarding & Drop Point".tr,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackwhitecolor, fontSize: 16, fontWeight: FontWeight.w600),), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
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
                    height: 65,
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: searchHover2
                            ? Colors.indigoAccent.shade700
                            : notifier.purplecolor),
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
          constraints.maxWidth < 1100 ? const SizedBox() : const Spacer(),
        ],
      ),
    );
  }

  void fun() {
    setState(() {
      var temp2 = bordingId;
      bordingId = dropId;
      dropId = temp2;

      var point = searchBusApi.boardingPoint;
      searchBusApi.boardingPoint = searchBusApi.dropPoint;
      searchBusApi.dropPoint = point;

      var tempId = searchBusApi.boardingId!;
      searchBusApi.boardingId = searchBusApi.dropId!;
      searchBusApi.dropId = tempId;

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
              : 14)),
    );
    return SizedBox(
      height: 15,
      child: SearchField(
        controller: suggestionTextFiledTo,
        marginColor: notifier.whitecolor,
        offset: const Offset(0, 40),
        searchStyle: TextStyle(
            color: notifier.blackcolor,
            fontFamily: 'SofiaLight',
            fontWeight: FontWeight.w600,
            fontSize: constraints.maxWidth < 1100 ? 12 : 14),
        searchInputDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: constraints.maxWidth < 1600 ? 10 : 0,left: 5),
          hintText: 'To'.tr,
          hintStyle: TextStyle(
              color: notifier.blackcolor,
              fontFamily: 'SofiaLight',
              fontWeight: FontWeight.w600,
              fontSize: constraints.maxWidth < 1100 ? 12 : 14),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
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
      child: Text(x["title"].toString(), style: TextStyle(
          color: notifier.blackcolor,
          fontFamily: 'SofiaLight',
          fontWeight: FontWeight.w600,
          fontSize: constraints.maxWidth < 1100
              ? 12
              : 14)),
    );
    return SizedBox(
      height: 15,
      child: SearchField(
        controller: suggestionTextFiledFrom,
        suggestionItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16)
        ),
        marginColor: notifier.whitecolor,
        offset: const Offset(0, 40),
        searchStyle: TextStyle(
            color: notifier.blackcolor,
            fontFamily: 'SofiaLight',
            fontWeight: FontWeight.w600,
            fontSize: constraints.maxWidth < 1100 ? 12 : 14),
        searchInputDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: constraints.maxWidth < 1600 ? 10 : 0, left: 5),
          hintText: 'From'.tr,
          hintStyle: TextStyle(
              color: notifier.blackcolor,
              fontFamily: 'SofiaLight',
              fontWeight: FontWeight.w600,
              fontSize: constraints.maxWidth < 1100 ? 12 : 14),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
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


