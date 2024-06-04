// import 'package:flutter/cupertino.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:zigzagbus/apicontroller/buslayoutcontroller.dart';
// import 'package:zigzagbus/apicontroller/facilitylistapi.dart';
// import 'package:zigzagbus/apicontroller/homelistapi.dart';
// import 'package:zigzagbus/apicontroller/citylistcontroller.dart';
// import 'package:zigzagbus/apicontroller/coupenlistapi.dart';
// import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
// import 'package:zigzagbus/apicontroller/operatorapi.dart';
// import 'package:zigzagbus/apicontroller/riviewlistapi.dart';
// import 'package:zigzagbus/apicontroller/searchbuscontroller.dart';
// import 'package:zigzagbus/config.dart';
// import 'package:zigzagbus/deshboard/endofpage.dart';
// import 'package:zigzagbus/helper/drawerCommon.dart';
// import 'package:zigzagbus/helper/helperwidget/seatselection.dart';
// import 'package:zigzagbus/models/searchbusmodel.dart';
// import 'package:zigzagbus/search/search_location.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
//
// import '../apicontroller/pickdroppointcontroller.dart';
// import '../helper/appbar.dart';
// import '../helper/colornotifier.dart';
// import '../mediaquery/mq.dart';
//
// class SearchBuses extends StatefulWidget {
//   const SearchBuses({super.key});
//
//   @override
//   State<SearchBuses> createState() => _SearchBusesState();
// }
//
// class _SearchBusesState extends State<SearchBuses> {
//   late ColorNotifier notifier;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     operatorApi.operatorList();
//     logInApi.getlocaldata();
//     facilitylistApi.facilitylist(context);
//     if (logInApi.userData["user_type"] == "AGENT") {
//       if (searchBusApi.searchBusData!.busData.isNotEmpty) {
//         agentComPer = int.parse(searchBusApi.searchBusData!.busData[0].agentCommission);
//       }
//     }
//
//     for( int a =0; a < searchBusApi.searchBusData!.busData.length; a++){
//       if (searchBusApi.searchBusData!.busData.isNotEmpty) {
//         searchBusApi.isLoading ? CircularProgressIndicator(color: notifier.purplecolor) : seatSelectionOpen.add(false);
//         // seatSelectionOpen.last;
//       }
//     }
//
//     busLayoutApi.getlocledata();
//     cancellationPoilyApi.cancellationPolicy(context).then((value) {
//       return getPageListData();
//     });
//   }
//
//   String check = '';
//   String commission = "";
//   double ticketPrice = 0;
//   int agentComPer = 0;
//   CityListDataApi cityListApi = Get.put(CityListDataApi());
//   SearchBusApi searchBusApi = Get.put(SearchBusApi());
//   PageListApi cancellationPoilyApi = Get.put(PageListApi());
//   BusLayoutApi busLayoutApi = Get.put(BusLayoutApi());
//   LoginApiController logInApi = Get.put(LoginApiController());
//   PickDropController pickdropApi = Get.put(PickDropController());
//   CouponlistApi couponlistApi = Get.put(CouponlistApi());
//   ReviewListApi reviewListApi = Get.put(ReviewListApi());
//   OperatorApi operatorApi = Get.put(OperatorApi());
//   FacilitylistApi facilitylistApi = Get.put(FacilitylistApi());
//
//   String cancellationPolicy = "";
//
//   getPageListData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     cancellationPolicy = prefs.getString("cancelationpolicy")!;
//     print(cancellationPolicy);
//   }
//
//   String busid = "";
//   String sortBy = "";
//   String departure = "";
//   String arrivalTime = "";
//   String busType = "";
//   String facilities = "";
//   String operator = "";
//   int deparValue = 0;
//   List departureTime = ["05:00 - 12:00", "12:00 - 18:00", "18:00 - 24:00", "00:00 - 06:00"];
//
//   List departureType = [
//     "Morning".tr,
//     "Afternoon".tr,
//     "Evening".tr,
//     "Night".tr
//   ];
//   int dropPoint = 0;
//   List<bool> seatSelectionOpen = [];
//
//   bool isExpanded1 = false;
//   bool isExpanded2 = false;
//   bool isExpanded3 = false;
//   bool isExpanded4 = false;
//   bool isExpanded5 = false;
//
//   List amenities = [
//     'Wifi'.tr,
//     'Water Bottle'.tr,
//     'Charging Point'.tr,
//     'Music'.tr,
//     'Medical Kit'.tr,
//     'Live Tracking'.tr
//   ];
//   bool busCheck = false;
//   bool timeCheck = false;
//   bool timeCheck2 = false;
//
//   List departureTimeIcons = [
//     "assets/Icons/filtericon/morning.svg",
//     "assets/Icons/filtericon/afternoon.svg",
//     "assets/Icons/filtericon/evening.svg",
//     "assets/Icons/filtericon/night.svg",
//   ];
//
//   List bustypeIcons = [
//     "assets/Icons/filtericon/seat.svg",
//     "assets/Icons/filtericon/bed.svg",
//     "assets/Icons/filtericon/air-conditioner.svg",
//     "assets/Icons/filtericon/nonac.svg",
//   ];
//
//   List sortedList = [
//     "Price - Low to high".tr,
//     "Best rated first".tr,
//     "Early departure".tr,
//     "Late departure".tr,
//   ];
//   List busTypeList = [
//     "SEATER".tr,
//     "SLEEPER".tr,
//     "AC".tr,
//     "NONAC".tr
//   ];
//   List gridviewList = [];
//   List reviewList = [];
//
//   String pickplace = '';
//   String dropplace = '';
//
//   final GlobalKey<ScaffoldState> buseskey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     notifier = Provider.of<ColorNotifier>(context, listen: true);
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       key: buseskey,
//       backgroundColor: notifier.backgroundColor,
//       endDrawer: const CommonDrawer(),
//       appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(100),
//           child: LocalappBar(
//             gkey: buseskey,
//           )),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return GetBuilder<SearchBusApi>(builder: (searchBusApi) {
//             return searchBusApi.isLoading
//                 ? Center(
//               child:
//               CircularProgressIndicator(color: notifier.purplecolor),
//             )
//                 : SingleChildScrollView(child: searchBus(constraints));
//           });
//         },
//       ),
//     );
//
//   }
//
//   Widget searchBus(constraints) {
//     return Column(
//       children: [
//         constraints.maxWidth < 900
//             ? Container(
//           color: notifier.backgroundColor,
//           child: const SearchLocation(),
//         )
//             : Container(
//           height: 180,
//           color: notifier.backgroundColor,
//           child: const SearchLocation(),
//         ),
//         Container(
//           color:
//           notifier.isDark ? notifier.backgroundColor : notifier.searchgrey,
//           child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: constraints.maxWidth < 900
//                   ? lessScreen(constraints)
//                   : largeScreen(constraints)),
//         ),
//         SizedBox(height: constraints.maxWidth < 1600 ? 24 : 10),
//         Container(
//             color: notifier.whitecolor,
//             child: const Padding(
//               padding: EdgeInsets.all(20),
//               child: endofpage(),
//             )),
//       ],
//     );
//   }
//
//   Widget lessScreen(constraints) {
//     return Column(
//       children: [
//         lessFilters(constraints),
//         const SizedBox(height: 20),
//         ListView.separated(
//             separatorBuilder: (context, index) {
//               return const SizedBox(height: 0);
//             },
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: searchBusApi.searchBusData!.busData.length,
//             itemBuilder: (BuildContext context, int index) {
//               return searchBusApi.searchBusData!.busData.isEmpty
//                   ? Center(
//                   child: Column(
//                     children: [
//                       SvgPicture.asset("assets/nobusfound.svg", height: 100,),
//                       Text("Zigzag fulfilled buses are not available at this time.".tr,
//                         style: TextStyle(
//                             fontFamily: 'SofiaLight',
//                             fontSize: 30,
//                             color: notifier.greycolor),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ))
//                   : Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: InkWell(
//                   child: Container(
//                     margin: const EdgeInsets.only(right: 10),
//                     decoration: BoxDecoration(
//                       color: notifier.whitecolor,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 if (seatSelectionOpen[index] == false) {
//                                   if (pickplace.isEmpty && dropplace.isEmpty) {
//                                     pickplace = pickdropApi.pickdropData!.pickUpStops[0].pickPlace;
//                                     dropplace = pickdropApi.pickdropData!.dropStops[0].dropPlace;
//                                     // pickData["sub_pick_mobile"] =  pickdropApi.pickdropData!.pickUpStops[0].pickMobile;
//                                     // pickData["sub_pick_time"] =  pickdropApi.pickdropData!.pickUpStops[0].pickTime;
//                                     // pickData["sub_pick_address"] =  pickdropApi.pickdropData!.pickUpStops[0].pickAddress;
//                                     // dropData["sub_drop_time"] =   pickdropApi.pickdropData!.dropStops[0].dropTime;
//                                     // dropData["sub_drop_address"] =  pickdropApi.pickdropData!.dropStops[0].dropAddress;
//                                   }
//                                   busid = searchBusApi.searchBusData!.busData[index].busId;
//                                   print(index);
//                                   pickdropApi.pickdropPoint(context);
//                                   busLayoutApi.busLayout(context, searchBusApi.selectedDateAndTime, busid).then((value) {
//                                     print(value);
//                                     for(int a = 0; a < seatSelectionOpen.length; a++){
//                                       if(seatSelectionOpen.contains(true)){
//                                         seatSelectionOpen[a] = false;
//                                         setState((){});
//                                       }
//                                     }
//                                     setState(() {
//                                       seatSelectionOpen[index] = true;
//                                     });
//                                   });
//                                 } else {
//                                   seatSelectionOpen[index] = false;
//                                 }
//                               });
//                             },
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                         height: 50,
//                                         width: 50,
//                                         decoration: BoxDecoration(
//                                             color: const Color(0xff7D2AFF),
//                                             shape: BoxShape.circle,
//                                             image: DecorationImage(
//                                                 image: NetworkImage(
//                                                     "${Config.imageBaseUrl}${searchBusApi.searchBusData?.busData[index].busImg}"),
//                                                 fit: BoxFit.cover))),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           searchBusApi.searchBusData!
//                                               .busData[index].busTitle,
//                                           style: TextStyle(
//                                               fontFamily: 'SofiaLight',
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                               color: notifier.blackcolor,
//                                               letterSpacing: 1),
//                                         ),
//                                         const SizedBox(
//                                           height: 5,
//                                         ),
//                                         Row(
//                                           children: [
//                                             searchBusApi
//                                                 .searchBusData!
//                                                 .busData[index]
//                                                 .busAc ==
//                                                 "0"
//                                                 ? RichText(text: TextSpan(
//                                                 text: "Non AC".tr,
//                                                 style: TextStyle(
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     fontSize: 14,
//                                                     color: notifier.blackcolor
//                                                 ),
//                                                 children: [
//                                                   TextSpan(
//                                                       text: '/ ${searchBusApi.searchBusData!.busData[index].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}',
//                                                       style: TextStyle(
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           fontSize: 14,
//                                                           color: notifier.blackcolor
//                                                       )
//                                                   )
//                                                 ]
//                                             ))
//                                                 : RichText(text: TextSpan(
//                                                 text: "AC".tr,
//                                                 style: TextStyle(
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     fontSize: 14,
//                                                     color: notifier.blackcolor),
//                                                 children: [
//                                                   TextSpan(
//                                                       text: '/ ${searchBusApi.searchBusData!.busData[index].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}',
//                                                       style: TextStyle(
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           fontSize: 14,
//                                                           color: notifier.blackcolor)
//                                                   )
//                                                 ]
//                                             )),
//                                             const SizedBox(width: 6),
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                 color: notifier.lightPurplecolor,
//                                                 borderRadius: BorderRadius.circular(4),),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.all(4),
//                                                 child: RichText(
//                                                   text: TextSpan(
//                                                     text: "${searchBusApi.searchBusData!.busData[index].totlSeat} ",
//                                                     style: TextStyle(
//                                                         fontFamily: 'SofiaLight',
//                                                         fontWeight: FontWeight.w600,
//                                                         color: notifier.purplecolor,
//                                                         fontSize:
//                                                         12),
//                                                     children: [
//                                                       TextSpan(
//                                                           text: "Seats".tr,
//                                                           style: TextStyle(
//                                                               fontFamily: 'SofiaLight',
//                                                               fontWeight: FontWeight.w600,
//                                                               color: notifier.purplecolor,
//                                                               fontSize:
//                                                               12)
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     Column(
//                                       children: [
//                                         Container(
//                                             decoration: BoxDecoration(
//                                               color: notifier.yellowcolor,
//                                               borderRadius: BorderRadius.circular(6),
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(left: 6,right: 6, bottom: 2, top: 2),
//                                               child: Row(
//                                                 children: [
//                                                   Icon(Icons.star_rate_rounded,color: Colors.white,size: 12,),
//                                                   SizedBox(width: 3),
//                                                   Text(searchBusApi.searchBusData!.busData[index].busRate,style: TextStyle(
//                                                     fontFamily: 'SofiaLight',
//                                                     color: Colors.white,
//                                                     fontSize: 10,
//                                                   ),),
//                                                 ],
//                                               ),
//                                             )),
//                                         SizedBox(height: 6),
//                                         Text("${searchBusApi.searchBusData!.currency}${searchBusApi.searchBusData!.busData[index].ticketPrice}",
//                                           style: TextStyle(
//                                               fontFamily: 'SofiaLight',
//                                               color: notifier.purplecolor,
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         SizedBox(height: 5),
//                                         logInApi.userData["user_type"] == "AGENT" ? Row(
//                                           children: [
//                                             Text(
//                                               "${searchBusApi.searchBusData!.currency} ${((agentComPer / 100) * double.parse(searchBusApi.searchBusData!.busData[index].ticketPrice)).toStringAsFixed(2)}",
//                                               style: TextStyle(
//                                                   fontFamily: 'SofiaLight',
//                                                   color: Color(0xff01A452),
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             SizedBox(width: 5),
//                                             SvgPicture.asset(
//                                               "assets/Icons/greenwalleticon.svg",
//                                               height: 14,
//                                             ),
//                                           ],
//                                         ) : SizedBox(),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Flexible(
//                                       child: SizedBox(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                                 searchBusApi
//                                                     .searchBusData!
//                                                     .busData[index]
//                                                     .boardingCity,
//                                                 style: TextStyle(
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     fontWeight:
//                                                     FontWeight.bold,
//                                                     fontSize: 14,
//                                                     color: notifier
//                                                         .blackcolor),
//                                                 overflow:
//                                                 TextOverflow.ellipsis,
//                                                 maxLines: 1),
//                                             const SizedBox(
//                                               height: 8,
//                                             ),
//                                             Text(
//                                                 convertTimeTo12HourFormat(
//                                                     searchBusApi
//                                                         .searchBusData!
//                                                         .busData[index]
//                                                         .busPicktime),
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     color: notifier
//                                                         .blackcolor),
//                                                 overflow:
//                                                 TextOverflow.ellipsis,
//                                                 maxLines: 1),
//                                             const SizedBox(
//                                               height: 8,
//                                             ),
//                                             Text(
//                                                 searchBusApi
//                                                     .selectedDateAndTime
//                                                     .toString()
//                                                     .toString()
//                                                     .split(' ')
//                                                     .first,
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     color: notifier
//                                                         .blackcolor),
//                                                 overflow:
//                                                 TextOverflow.ellipsis,
//                                                 maxLines: 1),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     Column(
//                                       children: [
//                                         Image.asset(
//                                             'assets/Icons/busHorizontalIcon.png',
//                                             height: 60,
//                                             width: 100,
//                                             color: notifier.purplecolor),
//                                         Text(
//                                             searchBusApi
//                                                 .searchBusData!
//                                                 .busData[index]
//                                                 .differencePickDrop,
//                                             style: TextStyle(
//                                                 fontFamily: 'SofiaLight',
//                                                 fontSize: 14,
//                                                 color:
//                                                 notifier.blackcolor)),
//                                       ],
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Flexible(
//                                       child: SizedBox(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.end,
//                                           children: [
//                                             Text(
//                                                 searchBusApi
//                                                     .searchBusData!
//                                                     .busData[index]
//                                                     .dropCity,
//                                                 style: TextStyle(
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     fontWeight:
//                                                     FontWeight.bold,
//                                                     fontSize: 14,
//                                                     color: notifier
//                                                         .blackcolor),
//                                                 overflow:
//                                                 TextOverflow.ellipsis,
//                                                 maxLines: 1),
//                                             const SizedBox(
//                                               height: 8,
//                                             ),
//                                             Text(
//                                                 convertTimeTo12HourFormat(
//                                                     searchBusApi.searchBusData!.busData[index].busDroptime),
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     color: notifier.blackcolor),
//                                                 overflow:
//                                                 TextOverflow.ellipsis,
//                                                 maxLines: 1),
//                                             const SizedBox(
//                                               height: 8,
//                                             ),
//                                             Text(
//                                                 searchBusApi.selectedDateAndTime.toString().split(' ').first,
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     fontFamily: 'SofiaLight',
//                                                     color: notifier.blackcolor),
//                                                 overflow: TextOverflow.ellipsis,
//                                                 maxLines: 1),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Divider(
//                             color: notifier.lightgreycolor,
//                           ),
//                           Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                       onTap: () {
//                                         if (gridviewList
//                                             .contains(index) ==
//                                             true) {
//                                           setState(() {
//                                             gridviewList.remove(index);
//                                           });
//                                         } else {
//                                           setState(() {
//                                             gridviewList.add(index);
//                                             reviewList.remove(index);
//                                           });
//                                         }
//                                       },
//                                       child: Text(
//                                         'Amenities'.tr,
//                                         style: TextStyle(
//                                             color: notifier.purplecolor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12),
//                                       )),
//                                   InkWell(
//                                       onTap: () {
//                                         if (searchBusApi.searchBusData!.busData[index].totalReview != 0) {
//
//                                           if (reviewList.contains(index) == true) {
//                                             setState(() {
//                                               reviewList.remove(index);
//                                             });
//                                           } else {
//                                             reviewListApi.reviewlist(context, searchBusApi.searchBusData!.busData[index].busId).then((value) {
//                                               setState(() {
//                                                 reviewList.add(index);
//                                                 gridviewList.remove(index);
//                                               });
//                                             });
//                                           }
//                                         } else {
//                                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                             content: const Text("No Review!"),
//                                             width: 300,
//                                             elevation: 0,
//                                             behavior: SnackBarBehavior.floating,
//                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                           ));
//                                         }
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 15),
//                                         child: Text(
//                                           'Review'.tr,
//                                           style: TextStyle(
//                                               color: notifier.purplecolor,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12),
//                                         ),
//                                       )),
//                                   InkWell(
//                                       onTap: () {
//                                         Get.bottomSheet(
//                                             isScrollControlled: true,
//                                             StatefulBuilder(builder:
//                                                 (context, setState) {
//                                               return Padding(
//                                                 padding:
//                                                 const EdgeInsets.only(
//                                                     top: 100),
//                                                 child: Container(
//                                                   // height: 200,
//                                                   decoration: BoxDecoration(
//                                                     color: notifier.whitecolor,
//                                                     borderRadius:
//                                                     const BorderRadius
//                                                         .only(
//                                                         topRight: Radius
//                                                             .circular(15),
//                                                         topLeft: Radius
//                                                             .circular(
//                                                             15)),
//                                                   ),
//                                                   child:
//                                                   SingleChildScrollView(
//                                                     scrollDirection:
//                                                     Axis.vertical,
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .center,
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment
//                                                           .center,
//                                                       mainAxisSize:
//                                                       MainAxisSize.min,
//                                                       children: [
//                                                         Padding(
//                                                           padding:
//                                                           const EdgeInsets
//                                                               .only(
//                                                               left: 50,
//                                                               right: 50,
//                                                               top: 50),
//                                                           child: HtmlWidget(
//                                                             cancellationPolicy,
//                                                             textStyle:
//                                                             TextStyle(
//                                                               color: notifier
//                                                                   .blackcolor,
//                                                               fontSize: 20,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         const SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             }));
//                                       },
//                                       child: Text(
//                                         'Cancellation Policy'.tr,
//                                         style: TextStyle(
//                                             color: notifier.purplecolor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 12),
//                                       )),
//                                 ],
//                               ),
//                               gridviewList.contains(index)
//                                   ? Padding(
//                                 padding:
//                                 const EdgeInsets.only(top: 15),
//                                 child: GridView.builder(
//                                   shrinkWrap: true,
//                                   gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     mainAxisExtent: 20,
//                                     mainAxisSpacing: 10,
//                                   ),
//                                   physics:
//                                   const NeverScrollableScrollPhysics(),
//                                   itemCount: searchBusApi
//                                       .searchBusData!
//                                       .busData[index]
//                                       .busFacilities
//                                       .length,
//                                   itemBuilder:
//                                       (BuildContext context,
//                                       int index1) {
//                                     return Padding(
//                                       padding:
//                                       const EdgeInsets.only(
//                                           left: 20),
//                                       child: Row(
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Image.network(
//                                               "${Config.imageBaseUrl}${searchBusApi.searchBusData!.busData[index].busFacilities[index1].facilityimg}"),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Text(
//                                               searchBusApi.searchBusData!.busData[index].busFacilities[index1].facilityname,
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12,
//                                                   color: notifier
//                                                       .blackcolor,
//                                                   fontFamily:
//                                                   'gilroymed')),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               )
//                                   : reviewList.contains(index)
//                                   ? Padding(
//                                 padding:
//                                 const EdgeInsets.only(
//                                     top: 15),
//                                 child: Container(
//                                   color: notifier.whitecolor,
//                                   child: ListView.builder(
//                                     shrinkWrap: true,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: reviewListApi.reviewlistData!.reviewdata.length,
//                                     itemBuilder: (BuildContextcontext, int index1) {
//                                       return Column(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Container(
//                                                       decoration: BoxDecoration(
//                                                           color: notifier.grey03,
//                                                           shape: BoxShape.circle),
//                                                       child:
//                                                       Padding(
//                                                         padding:
//                                                         const EdgeInsets.all(12),
//                                                         child:
//                                                         Text(reviewListApi.reviewlistData!.reviewdata[index].userTitle[0], style: TextStyle(fontFamily: 'SofiaLight', color: notifier.purplecolor, fontSize: 14)),
//                                                       ),
//                                                     ),
//                                                     SizedBox(width: 5),
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                       children: [
//                                                         Text(reviewListApi.reviewlistData!.reviewdata[index].userTitle,
//                                                             style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14)),
//                                                         SizedBox(height: 2),
//                                                         Text(reviewListApi.reviewlistData!.reviewdata[index].reviewDate.toString().split(' ').first,
//                                                             style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackcolor, fontSize: 12)),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Container(
//                                                   decoration:
//                                                   BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius.circular(5),
//                                                     border: Border.all(
//                                                         color:
//                                                         notifier.purplecolor),
//                                                   ),
//                                                   child:
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 2, bottom: 2, right: 6, left: 6),
//                                                     child:
//                                                     Row(
//                                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                                       mainAxisAlignment: MainAxisAlignment.center,
//                                                       children: [
//                                                         Icon(Icons.star_rate_rounded,
//                                                             color: notifier.purplecolor,
//                                                             size: 12),
//                                                         Text(reviewListApi.reviewlistData!.reviewdata[index].userRate,
//                                                             style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, color: notifier.purplecolor, fontSize: 10)),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Text(
//                                                 reviewListApi.reviewlistData!.reviewdata[index].userDesc,
//                                                 style: TextStyle(
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     color: notifier
//                                                         .blackcolor,
//                                                     fontSize:
//                                                     14)),
//                                             SizedBox(
//                                                 height: 10),
//                                           ]);
//                                     },
//                                   ),
//                                 ),
//                               )
//                                   : SizedBox(),
//                               seatSelectionOpen[index]
//                                   ? Divider(color: notifier.lightgreycolor,) : SizedBox(),
//                               seatSelectionOpen[index]
//                                   ? SeatSelection(
//                                 commission: (((agentComPer / 100) * double.parse(searchBusApi.searchBusData!.busData[index].ticketPrice)).toStringAsFixed(2)).toString(),
//                                 index2: index,
//                                 constraints: constraints,
//                               )
//                                   : SizedBox(),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//       ],
//     );
//   }
//
//   Widget lessFilters(constraints) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Sort By-".tr,style: TextStyle(fontFamily: "SofiaLight", fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 16)),
//         SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: notifier.whitecolor,
//             border: Border.all(color: notifier.sugestionbutton),
//           ),
//           child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: sortedList.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           searchBusApi.sortBy = (index + 1).toString();
//                           sortBy = (index + 1).toString();
//                         });
//                         searchBusApi.searchBus(context).then((value) {
//                         });
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Flexible(
//                             child: Text("${sortedList[index]}".tr,
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: notifier.blackcolor,
//                                     fontFamily: 'SofiaLight')),
//                           ),
//                           Radio(
//                             value: sortedList[index],
//                             groupValue: sortBy,
//                             fillColor: MaterialStatePropertyAll( notifier.blackcolor),
//                             activeColor: notifier.purplecolor,
//                             onChanged: (value) {
//                               setState(() {
//                                 searchBusApi.sortBy = (index + 1).toString();
//                                 sortBy = value as String;
//                                 print(value);
//                               });
//                               searchBusApi.searchBus(context).then((value) {
//
//                               });
//                               print(pickplace);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded1
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded1 = value;
//               });
//             },
//             title: Text('Departure Time'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder
//               <SearchBusApi>(builder: (searchBusApi) {
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: departureTime.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                       child: Column(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 searchBusApi.departureTime = (index + 1).toString();
//                                 departure = departure[index];
//                               });
//                               searchBusApi.searchBus(context).then((value) {
//                               });
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     SvgPicture.asset(departureTimeIcons[index],height: 20,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
//                                     const SizedBox(width: 10),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(departureTime[index],
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: notifier.blackcolor,
//                                                 fontFamily: 'SofiaLight')),
//                                         Text("${departureType[index]}".tr,
//                                             style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: notifier.subgreycolor,
//                                                 fontFamily: 'SofiaLight')),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: departureTime[index],
//                                   groupValue: departure,
//                                   fillColor: MaterialStatePropertyAll( notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       searchBusApi.departureTime = (index + 1).toString();
//                                       departure = value as String;
//                                     });
//                                     searchBusApi.searchBus(context).then((value) {
//
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },)
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded2
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded2 = value;
//               });
//             },
//             title: Text('Arrival Time'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder<SearchBusApi>(
//                   builder: (searchBusApi) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: departureTime.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 arrivalTime = departureTime[index];
//                                 searchBusApi.arrivalTime = (index + 1).toString();
//                               });
//                               searchBusApi.searchBus(context);
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     SvgPicture.asset(departureTimeIcons[index],height: 20,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
//                                     const SizedBox(width: 10),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(departureTime[index],
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: notifier.blackcolor,
//                                                 fontFamily: 'SofiaLight')),
//                                         Text("${departureType[index]}".tr,
//                                             style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: notifier.subgreycolor,
//                                                 fontFamily: 'SofiaLight')),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: departureTime[index],
//                                   groupValue: arrivalTime,
//                                   fillColor: MaterialStatePropertyAll( notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       arrivalTime = value as String;
//                                       searchBusApi.arrivalTime = (index + 1).toString();
//                                     });
//                                     searchBusApi.searchBus(context);
//                                     print(pickplace);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded3
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded3 = value;
//               });
//             },
//             title: Text('Bus Type'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder<SearchBusApi>(
//                   builder: (searchBusApi) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: busTypeList.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 busType = busTypeList[index];
//                                 searchBusApi.arrivalTime = (index + 1).toString();
//                               });
//                               searchBusApi.searchBus(context);
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(bustypeIcons[index],height: 22,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
//                                     const SizedBox(width: 10),
//                                     Text("${busTypeList[index]}".tr,
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                             color: notifier.blackcolor,
//                                             fontFamily: 'SofiaLight')),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: busTypeList[index],
//                                   groupValue: busType,
//                                   fillColor: MaterialStatePropertyAll( notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       busType = value as String;
//                                       searchBusApi.busType = (index + 1).toString();
//                                     });
//                                     searchBusApi.searchBus(context);
//                                     print(pickplace);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded4
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded4 = value;
//               });
//             },
//             title: Text('Bus Facilities'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder<SearchBusApi>(
//                   builder: (searchBusApi) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: facilitylistApi.facilityData!.facilitylist.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 busType = amenities[index];
//                                 searchBusApi.facilityList = (index + 1).toString();
//                                 facilitylistApi.facilitylist(context);
//                               });
//                               searchBusApi.searchBus(context);
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Image.network(Config.imageBaseUrl + facilitylistApi.facilityData!.facilitylist[index].img,height: 22,color: notifier.blackcolor,),
//                                     const SizedBox(width: 10),
//                                     Text("${facilitylistApi.facilityData!.facilitylist[index].title}".tr,
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                             color: notifier.blackcolor,
//                                             fontFamily: 'SofiaLight')),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: facilitylistApi.facilityData!.facilitylist[index],
//                                   groupValue: facilities,
//                                   fillColor: MaterialStatePropertyAll( notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       facilities = value as String;
//                                       searchBusApi.facilityList = (index + 1).toString();
//                                     });
//                                     searchBusApi.searchBus(context);
//                                     print(pickplace);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded5
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded5 = value;
//               });
//
//             },
//             title: Text('Bus Operator'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder<SearchBusApi>(
//                   builder: (searchBusApi) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: operatorApi.operatorData!.operatorlist.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 operator = operatorApi.operatorData!.operatorlist[index].title;
//                                 searchBusApi.facilityList = (index + 1).toString();
//                               });
//                               searchBusApi.searchBus(context);
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(operatorApi.operatorData!.operatorlist[index].title,
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: notifier.blackcolor,
//                                         fontFamily: 'SofiaLight')),
//                                 Radio(
//                                   value: operatorApi.operatorData!.operatorlist[index].title,
//                                   groupValue: operator,
//                                   fillColor: MaterialStatePropertyAll( notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       operator = value as String;
//                                       searchBusApi.operatorList = (index + 1).toString();
//                                     });
//                                     searchBusApi.searchBus(context);
//                                     print(pickplace);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget largeScreen(constraints) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             constraints.maxWidth < 1200 ? const SizedBox() : const Spacer(),
//             Expanded(
//               flex: constraints.maxWidth < 1350 ? 3 : 2,
//               child: largeFilter(constraints),
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               flex: constraints.maxWidth < 1350 ? 8 : 4,
//               child: Container(
//                 child: searchBusApi.isLoading ? CircularProgressIndicator(color: notifier.purplecolor) : (searchBusApi.searchBusData!.busData.isEmpty)
//                     ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset("assets/nobusfound.svg", height: 300,),
//                         Text("Zigzag fulfilled buses are not available at this time.".tr,
//                           style: TextStyle(
//                               fontFamily: 'SofiaLight',
//                               fontSize: 30,
//                               color: notifier.greycolor),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ))
//                     : ListView.separated(
//                     separatorBuilder: (context, index) {
//                       return const SizedBox(height: 0);
//                     },
//                     shrinkWrap: true,
//                     scrollDirection: Axis.vertical,
//                     itemCount: searchBusApi.searchBusData!.busData.length,
//                     itemBuilder: (BuildContext context, int index2) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10),
//                         child: Container(
//                           margin: const EdgeInsets.only(right: 10),
//                           decoration: BoxDecoration(
//                             color: notifier.whitecolor,
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(15),
//                             child: Column(
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       if (seatSelectionOpen[index2] == false) {
//
//                                         ticketPrice = double.parse(searchBusApi.searchBusData!.busData[index2].ticketPrice);
//
//                                         busid = searchBusApi.searchBusData!.busData[index2].busId;
//                                         print(index2);
//                                         pickdropApi.pickdropPoint(context);
//                                         busLayoutApi.busLayout(
//                                             context,
//                                             searchBusApi
//                                                 .selectedDateAndTime,
//                                             busid)
//                                             .then((value) {
//                                           print(value);
//                                           setState(() {
//
//                                             for(int a =0 ;a < seatSelectionOpen.length;a++){
//                                               if(seatSelectionOpen.contains(true)){
//                                                 seatSelectionOpen[a] = false;
//                                                 setState((){});
//                                               }
//                                             }
//                                             seatSelectionOpen[index2] = true;
//                                           });
//                                         });
//                                       } else {
//                                         seatSelectionOpen[index2] = false;
//                                       }
//                                     });
//                                   },
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                               height: 50,
//                                               width: 50,
//                                               decoration: BoxDecoration(
//                                                   color: const Color(
//                                                       0xff7D2AFF),
//                                                   shape: BoxShape.circle,
//                                                   image: DecorationImage(
//                                                       image: NetworkImage(
//                                                           "${Config.imageBaseUrl}${searchBusApi.searchBusData!.busData[index2].busImg}"),
//                                                       fit: BoxFit.cover))),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 searchBusApi
//                                                     .searchBusData!
//                                                     .busData[index2]
//                                                     .busTitle,
//                                                 style: TextStyle(
//                                                     fontFamily:
//                                                     'SofiaLight',
//                                                     fontSize: 18,
//                                                     fontWeight:
//                                                     FontWeight.bold,
//                                                     color:
//                                                     notifier.blackcolor,
//                                                     letterSpacing: 1),
//                                               ),
//                                               const SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                                 children: [
//                                                   searchBusApi
//                                                       .searchBusData!
//                                                       .busData[
//                                                   index2]
//                                                       .busAc ==
//                                                       "0"
//                                                       ? RichText(text: TextSpan(
//                                                       text: "Non AC".tr,
//                                                       style: TextStyle(
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           fontSize: 14,
//                                                           color: notifier.blackcolor),
//                                                       children: [
//                                                         TextSpan(
//                                                             text: '/ ${searchBusApi.searchBusData!.busData[index2].isSleeper == "1" ? 'Sleeper'.tr
//                                                                 : "Seater".tr}'.tr,
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                 'SofiaLight',
//                                                                 fontSize: 14,
//                                                                 color: notifier.blackcolor)
//                                                         )
//                                                       ]
//                                                   ))
//                                                       : RichText(text: TextSpan(
//                                                       text: "AC".tr,
//                                                       style: TextStyle(
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           fontSize: 14,
//                                                           color: notifier.blackcolor),
//                                                       children: [
//                                                         TextSpan(
//                                                             text: '/ ${searchBusApi.searchBusData!.busData[index2].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}'.tr,
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                 'SofiaLight',
//                                                                 fontSize: 14,
//                                                                 color: notifier.blackcolor)
//                                                         )
//                                                       ]
//                                                   )),
//                                                   const SizedBox(width: 6),
//                                                   Container(
//                                                     alignment: Alignment.center,
//                                                     decoration: BoxDecoration(
//                                                       color: notifier.xlightPurplecolor,
//                                                       borderRadius: BorderRadius.circular(4),
//                                                     ),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.all(4),
//                                                       child: RichText(
//                                                         text: TextSpan(
//                                                           text: "${searchBusApi.searchBusData!.busData[index2].totlSeat} ",
//                                                           style: TextStyle(
//                                                               fontFamily: 'SofiaLight',
//                                                               fontWeight: FontWeight.w600,
//                                                               color: notifier.purplecolor,
//                                                               fontSize:
//                                                               12),
//                                                           children: [
//                                                             TextSpan(
//                                                                 text: "Seats".tr,
//                                                                 style: TextStyle(
//                                                                     fontFamily: 'SofiaLight',
//                                                                     fontWeight: FontWeight.w600,
//                                                                     color: notifier.purplecolor,
//                                                                     fontSize:
//                                                                     12)
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           const Spacer(),
//                                           Column(
//                                             children: [
//                                               Container(
//                                                   decoration: BoxDecoration(
//                                                     color: notifier.yellowcolor,
//                                                     borderRadius: BorderRadius.circular(6),
//                                                   ),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.only(left: 6,right: 6, bottom: 2, top: 2),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(Icons.star_rate_rounded,color: Colors.white,size: 12,),
//                                                         SizedBox(width: 3),
//                                                         Text(searchBusApi.searchBusData!.busData[index2].busRate,style: TextStyle(
//                                                           fontFamily: 'SofiaLight',
//                                                           color: Colors.white,
//                                                           fontSize: 10,
//                                                         ),),
//                                                       ],
//                                                     ),
//                                                   )),
//                                               SizedBox(height: 6),
//                                               Text("${searchBusApi.searchBusData!.currency}${searchBusApi.searchBusData!.busData[index2].ticketPrice}",
//                                                 style: TextStyle(
//                                                     fontFamily: 'SofiaLight',
//                                                     color: notifier.purplecolor,
//                                                     fontSize: 18,
//                                                     fontWeight: FontWeight.bold),
//                                               ),
//                                               SizedBox(height: 6),
//                                               logInApi.userData["user_type"] == "AGENT" ? Row(
//                                                 children: [
//                                                   Text(
//                                                     "${searchBusApi.searchBusData!.currency} ${((agentComPer / 100) * double.parse(searchBusApi.searchBusData!.busData[index2].ticketPrice)).toStringAsFixed(2)}",
//                                                     style: TextStyle(
//                                                         fontFamily: 'SofiaLight',
//                                                         color: Color(0xff01A452),
//                                                         fontSize: 14,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                   SizedBox(width: 5),
//                                                   SvgPicture.asset(
//                                                     "assets/Icons/greenwalleticon.svg",
//                                                     height: 14,
//                                                   ),
//                                                 ],
//                                               ) : SizedBox(),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         height: 20,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Flexible(
//                                             child: SizedBox(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment
//                                                     .start,
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                       searchBusApi
//                                                           .searchBusData!
//                                                           .busData[index2]
//                                                           .boardingCity,
//                                                       style: TextStyle(
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .bold,
//                                                           fontSize: 14,
//                                                           color: notifier
//                                                               .blackcolor),
//                                                       overflow: TextOverflow
//                                                           .ellipsis,
//                                                       maxLines: 1),
//                                                   const SizedBox(
//                                                     height: 8,
//                                                   ),
//                                                   Text(
//                                                       convertTimeTo12HourFormat(searchBusApi.searchBusData!.busData[index2].busPicktime),
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           fontWeight: FontWeight.w600,
//                                                           color: notifier
//                                                               .purplecolor),
//                                                       overflow: TextOverflow
//                                                           .ellipsis,
//                                                       maxLines: 1),
//                                                   const SizedBox(
//                                                     height: 8,
//                                                   ),
//                                                   Text(
//                                                       searchBusApi.selectedDateAndTime.toString().split(' ').first,
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           color: notifier
//                                                               .blackcolor),
//                                                       overflow: TextOverflow
//                                                           .ellipsis,
//                                                       maxLines: 1),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Column(
//                                             children: [
//                                               Image.asset(
//                                                   'assets/Icons/busHorizontalIcon.png',
//                                                   height: 60,
//                                                   width: 100,
//                                                   color:
//                                                   notifier.purplecolor),
//                                               Text(searchBusApi.searchBusData!.busData[index2].differencePickDrop,
//                                                   style: TextStyle(
//                                                       fontFamily:
//                                                       'SofiaLight',
//                                                       fontSize: 14,
//                                                       color: notifier
//                                                           .blackcolor)),
//                                             ],
//                                           ),
//                                           const SizedBox(width: 10),
//                                           Flexible(
//                                             child: SizedBox(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                                 children: [
//                                                   Text(
//                                                       searchBusApi
//                                                           .searchBusData!
//                                                           .busData[index2]
//                                                           .dropCity,
//                                                       style: TextStyle(
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .bold,
//                                                           fontSize: 14,
//                                                           color: notifier
//                                                               .blackcolor),
//                                                       overflow: TextOverflow
//                                                           .ellipsis,
//                                                       maxLines: 1),
//                                                   const SizedBox(
//                                                     height: 8,
//                                                   ),
//                                                   Text(
//                                                       convertTimeTo12HourFormat(
//                                                           searchBusApi.searchBusData!.busData[index2].busDroptime),
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight.w600,
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           color: notifier
//                                                               .purplecolor),
//                                                       overflow: TextOverflow
//                                                           .ellipsis,
//                                                       maxLines: 1),
//                                                   const SizedBox(
//                                                     height: 8,
//                                                   ),
//                                                   Text(
//                                                       searchBusApi
//                                                           .selectedDateAndTime
//                                                           .toString()
//                                                           .split(' ')
//                                                           .first,
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontFamily:
//                                                           'SofiaLight',
//                                                           color: notifier
//                                                               .blackcolor),
//                                                       overflow: TextOverflow
//                                                           .ellipsis,
//                                                       maxLines: 1),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Divider(
//                                   color: notifier.lightgreycolor,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     InkWell(
//                                         onTap: () {
//                                           if (gridviewList.contains(index2) == true) {
//                                             setState(() {
//                                               gridviewList.remove(index2);
//                                             });
//                                           } else {
//                                             setState(() {
//                                               gridviewList.add(index2);
//                                               reviewList.remove(index2);
//                                             });
//                                           }
//                                         },
//                                         child: Text(
//                                           'Amenities'.tr,
//                                           style: TextStyle(
//                                               fontFamily: 'SofiaLight',
//                                               color: notifier.purplecolor,
//                                               fontWeight:
//                                               FontWeight.bold,
//                                               fontSize: 14),
//                                         )),
//                                     InkWell(
//                                         onTap: () {
//                                           if (searchBusApi.searchBusData!.busData[index2].totalReview != 0) {
//
//                                             if (reviewList.contains(index2) == true) {
//                                               setState(() {
//                                                 reviewList.remove(index2);
//                                               });
//                                             } else {
//                                               reviewListApi.reviewlist(context, searchBusApi.searchBusData!.busData[index2].busId).then((value) {
//                                                 setState(() {
//                                                   reviewList.add(index2);
//                                                   gridviewList.remove(index2);
//                                                 });
//                                               });
//                                             }
//                                           } else {
//                                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                               content: const Text("No Review!"),
//                                               width: 300,
//                                               elevation: 0,
//                                               behavior: SnackBarBehavior.floating,
//                                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                             ));
//                                           }
//                                         },
//                                         child: Padding(
//                                           padding:
//                                           const EdgeInsets.only(
//                                               left: 15),
//                                           child: Text(
//                                             'Review'.tr,
//                                             style: TextStyle(
//                                                 fontFamily:
//                                                 'SofiaLight',
//                                                 color: notifier
//                                                     .purplecolor,
//                                                 fontWeight:
//                                                 FontWeight.bold,
//                                                 fontSize: 14),
//                                           ),
//                                         )),
//                                     InkWell(
//                                         onTap: () {
//                                           Get.bottomSheet(
//                                               isScrollControlled: false,
//                                               StatefulBuilder(builder: (context, setState) {
//                                                 return Padding(
//                                                   padding: const EdgeInsets.only(top: 100),
//                                                   child: Container(
//                                                     // height: 200,
//                                                     decoration: BoxDecoration(
//                                                       color: notifier.whitecolor,
//                                                       borderRadius:
//                                                       const BorderRadius.only(
//                                                           topRight: Radius.circular(15),
//                                                           topLeft: Radius.circular(15)),
//                                                     ),
//                                                     child:
//                                                     SingleChildScrollView(
//                                                       scrollDirection:
//                                                       Axis.vertical,
//                                                       child: Column(mainAxisAlignment: MainAxisAlignment.center,
//                                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                                         mainAxisSize: MainAxisSize.min,
//                                                         children: [
//                                                           Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                                 left:
//                                                                 50,
//                                                                 right:
//                                                                 50,
//                                                                 top:
//                                                                 50),
//                                                             child:
//                                                             HtmlWidget(
//                                                               cancellationPolicy,
//                                                               textStyle:
//                                                               TextStyle(
//                                                                 color: notifier
//                                                                     .blackcolor,
//                                                                 fontSize:
//                                                                 20,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           // Text(cancellationPolicy,style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: notifier.blackcolor)),
//                                                           const SizedBox(
//                                                             height: 20,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               }));
//                                         },
//                                         child: Text(
//                                           'Cancellation Policy'.tr,
//                                           style: TextStyle(
//                                               fontFamily: 'SofiaLight',
//                                               color:
//                                               notifier.purplecolor,
//                                               fontWeight:
//                                               FontWeight.bold,
//                                               fontSize: 14),
//                                         )),
//                                   ],
//                                 ),
//                                 gridviewList.contains(index2)
//                                     ? Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 15),
//                                   child: GridView.builder(
//                                     shrinkWrap: true,
//                                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 2,
//                                       mainAxisExtent: 20,
//                                       mainAxisSpacing: 10,
//                                     ),
//                                     physics:
//                                     const NeverScrollableScrollPhysics(),
//                                     itemCount: searchBusApi
//                                         .searchBusData!
//                                         .busData[index2]
//                                         .busFacilities
//                                         .length,
//                                     itemBuilder:
//                                         (BuildContext context,
//                                         int index1) {
//                                       return Padding(
//                                         padding:
//                                         const EdgeInsets.only(
//                                             left: 20),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment
//                                               .center,
//                                           children: [
//                                             Image.network(
//                                                 "${Config.imageBaseUrl}${searchBusApi.searchBusData!.busData[index2].busFacilities[index1].facilityimg}"),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             Text(
//                                                 searchBusApi
//                                                     .searchBusData!
//                                                     .busData[
//                                                 index2]
//                                                     .busFacilities[
//                                                 index1]
//                                                     .facilityname,
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                     FontWeight
//                                                         .bold,
//                                                     fontSize: 12,
//                                                     color: notifier
//                                                         .blackcolor,
//                                                     fontFamily:
//                                                     'SofiaLight')),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 )
//                                     : reviewList.contains(index2)
//                                     ? Padding(
//                                   padding:
//                                   const EdgeInsets.only(
//                                       top: 15),
//                                   child: Container(
//                                     color: notifier.whitecolor,
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       itemCount: reviewListApi.reviewlistData!.reviewdata.length,
//                                       itemBuilder: (BuildContextcontext, int index1) {
//                                         return Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Container(
//                                                         decoration: BoxDecoration(
//                                                             color: notifier.grey03,
//                                                             shape: BoxShape.circle),
//                                                         child:
//                                                         Padding(
//                                                           padding:
//                                                           const EdgeInsets.all(12),
//                                                           child:
//                                                           Text(reviewListApi.reviewlistData!.reviewdata[index2].userTitle[0], style: TextStyle(fontFamily: 'SofiaLight', color: notifier.purplecolor, fontSize: 14)),
//                                                         ),
//                                                       ),
//                                                       SizedBox(width: 5),
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                         CrossAxisAlignment.start,
//                                                         children: [
//                                                           Text(reviewListApi.reviewlistData!.reviewdata[index2].userTitle,
//                                                               style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14)),
//                                                           SizedBox(height: 2),
//                                                           Text(reviewListApi.reviewlistData!.reviewdata[index2].reviewDate.toString().split(' ').first,
//                                                               style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackcolor, fontSize: 12)),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Container(
//                                                     decoration:
//                                                     BoxDecoration(
//                                                       borderRadius:
//                                                       BorderRadius.circular(5),
//                                                       border: Border.all(
//                                                           color:
//                                                           notifier.purplecolor),
//                                                     ),
//                                                     child:
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(top: 2, bottom: 2, right: 6, left: 6),
//                                                       child:
//                                                       Row(
//                                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           Icon(Icons.star_rate_rounded,
//                                                               color: notifier.purplecolor,
//                                                               size: 12),
//                                                           Text(reviewListApi.reviewlistData!.reviewdata[index2].userRate,
//                                                               style: TextStyle(fontFamily: 'SofiaLight', fontWeight: FontWeight.w600, color: notifier.purplecolor, fontSize: 10)),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Text(
//                                                   reviewListApi.reviewlistData!.reviewdata[index2].userDesc,
//                                                   style: TextStyle(
//                                                       fontFamily:
//                                                       'SofiaLight',
//                                                       color: notifier
//                                                           .blackcolor,
//                                                       fontSize:
//                                                       14)),
//                                               SizedBox(
//                                                   height: 10),
//                                             ]);
//                                       },
//                                     ),
//                                   ),
//                                 )
//                                     : const SizedBox(),
//                                 SizedBox(height: 10,),
//                                 seatSelectionOpen[index2]
//                                     ? SeatSelection(
//                                     commission: (((agentComPer / 100) * double.parse(searchBusApi.searchBusData!.busData[index2].ticketPrice)).toStringAsFixed(2)).toString(),
//                                     index2: index2,
//                                     constraints: constraints)
//                                     : const SizedBox(),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//               ),
//             ),
//             constraints.maxWidth < 1200 ? const SizedBox() : const Spacer(),
//           ],
//         );
//       },
//     );
//   }
//
//   String convertTimeTo12HourFormat(String time24Hour) {
//     // Parse the input time in 24-hour format
//     final inputFormat = DateFormat('HH:mm:ss');
//     final inputTime = inputFormat.parse(time24Hour);
//
//     // Format the time in 12-hour format
//     final outputFormat = DateFormat('h:mm a');
//     final formattedTime = outputFormat.format(inputTime);
//
//     return formattedTime;
//   }
//
//   Widget largeFilter(constraints) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: notifier.whitecolor,
//             border: Border.all(color: notifier.sugestionbutton),
//           ),
//           child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Sort By-".tr,style: TextStyle(fontFamily: "SofiaLight", fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 16)),
//                   SizedBox(height: 10),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: sortedList.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
//                         child: InkWell(
//                           onTap: () {
//                             setState(() {
//                               searchBusApi.sortBy = (index + 1).toString();
//                               sortBy = sortedList[index];
//                             });
//                             searchBusApi.searchBus(context).then((value) {
//                             });
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Flexible(
//                                 child: Text("${sortedList[index]}".tr,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: notifier.blackcolor,
//                                         fontFamily: 'SofiaLight')),
//                               ),
//                               Radio(
//                                 value: sortedList[index],
//                                 groupValue: sortBy,
//                                 fillColor: MaterialStatePropertyAll(notifier.blackcolor),
//                                 activeColor: notifier.purplecolor,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     searchBusApi.sortBy = (index + 1).toString();
//                                     sortBy = value as String;
//                                     print(value);
//                                   });
//                                   searchBusApi.searchBus(context).then((value) {
//                                   });
//                                   print(pickplace);
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               )),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded1
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded1 = value;
//               });
//             },
//             title: Text('Departure Time'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder
//               <SearchBusApi>(builder: (searchBusApi) {
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: departureTime.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                       child: Column(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 searchBusApi.departureTime = (index + 1).toString();
//                                 departure = departureTime[index];
//                               });
//                               searchBusApi.searchBus(context).then((value) {
//                               });
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     SvgPicture.asset(departureTimeIcons[index],height: 20,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
//                                     const SizedBox(width: 10),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(departureTime[index],
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: notifier.blackcolor,
//                                                 fontFamily: 'SofiaLight')),
//                                         Text("${departureType[index]}".tr,
//                                             style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: notifier.subgreycolor,
//                                                 fontFamily: 'SofiaLight')),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: departureTime[index],
//                                   groupValue: departure,
//                                   fillColor: MaterialStatePropertyAll(notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       searchBusApi.departureTime = (index + 1).toString();
//                                       departure = value as String;
//                                     });
//                                     searchBusApi.searchBus(context).then((value) {
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },)
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded2
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded2 = value;
//               });
//             },
//             title: Text('Arrival Time'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder<SearchBusApi>(
//                   builder: (searchBusApi) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: departureTime.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 arrivalTime = departureTime[index];
//                                 searchBusApi.arrivalTime = (index + 1).toString();
//                               });
//                               searchBusApi.searchBus(context);
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     SvgPicture.asset(departureTimeIcons[index],height: 20,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
//                                     const SizedBox(width: 10),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(departureTime[index],
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: notifier.blackcolor,
//                                                 fontFamily: 'SofiaLight')),
//                                         Text("${departureType[index]}".tr,
//                                             style: TextStyle(
//                                                 fontSize: 10,
//                                                 color: notifier.subgreycolor,
//                                                 fontFamily: 'SofiaLight')),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: departureTime[index],
//                                   groupValue: arrivalTime,
//                                   fillColor: MaterialStatePropertyAll(notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       searchBusApi.departureTime = (index + 1).toString();
//                                       departure = value as String;
//                                     });
//                                     searchBusApi.searchBus(context).then((value) {
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded3
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded3 = value;
//               });
//             },
//             title: Text('Bus Type'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder<SearchBusApi>(
//                   builder: (searchBusApi) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: busTypeList.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 busType = busTypeList[index];
//                                 searchBusApi.busType = (index + 1).toString();
//                               });
//                               searchBusApi.searchBus(context);
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(bustypeIcons[index],height: 22,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
//                                     const SizedBox(width: 10),
//                                     Text("${busTypeList[index]}".tr,
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                             color: notifier.blackcolor,
//                                             fontFamily: 'SofiaLight')),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: busTypeList[index],
//                                   groupValue: busType,
//                                   fillColor: MaterialStatePropertyAll(notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       busType = value as String;
//                                       searchBusApi.busType = (index + 1).toString();
//                                     });
//                                     searchBusApi.searchBus(context);
//                                     print(pickplace);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded4
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded4 = value;
//                 facilitylistApi.facilitylist(context);
//               });
//             },
//             title: Text('Bus Facilities'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder<SearchBusApi>(
//                   builder: (searchBusApi) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: facilitylistApi.facilityData!.facilitylist.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 busType = facilitylistApi.facilityData!.facilitylist[index].title;
//                                 searchBusApi.facilityList = (index + 1).toString();
//                               });
//                               searchBusApi.searchBus(context);
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Image.network(Config.imageBaseUrl + facilitylistApi.facilityData!.facilitylist[index].img,height: 22,color: notifier.blackcolor),
//                                     const SizedBox(width: 10),
//                                     Text("${facilitylistApi.facilityData!.facilitylist[index].title}".tr,
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                             color: notifier.blackcolor,
//                                             fontFamily: 'SofiaLight')),
//                                   ],
//                                 ),
//                                 Radio(
//                                   value: facilitylistApi.facilityData!.facilitylist[index].title,
//                                   groupValue: facilities,
//                                   fillColor: MaterialStatePropertyAll(notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       facilities = value as String;
//                                       searchBusApi.facilityList = (index + 1).toString();
//                                     });
//                                     searchBusApi.searchBus(context);
//                                     print(pickplace);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: notifier.whitecolor),
//           child: ExpansionTile(
//             trailing: isExpanded5
//                 ? Icon(Icons.remove_rounded, color: notifier.purplecolor)
//                 : Icon(Icons.add_rounded, color: notifier.purplecolor),
//             onExpansionChanged: (value) {
//               setState(() {
//                 isExpanded5 = value;
//               });
//
//             },
//             title: Text('Bus Operator'.tr,
//                 style: TextStyle(
//                     fontFamily: 'SofiaLight',
//                     color: notifier.blackcolor,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 1,
//                     fontSize: 14)),
//             children: [
//               GetBuilder<SearchBusApi>(
//                   builder: (searchBusApi) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: operatorApi.operatorData!.operatorlist.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 10, bottom: 10, right: 8),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 operator = operatorApi.operatorData!.operatorlist[index].title;
//                                 searchBusApi.facilityList = (index + 1).toString();
//                               });
//                               searchBusApi.searchBus(context);
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(operatorApi.operatorData!.operatorlist[index].title,
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: notifier.blackcolor,
//                                         fontFamily: 'SofiaLight')),
//                                 Radio(
//                                   value: operatorApi.operatorData!.operatorlist[index].title,
//                                   groupValue: operator,
//                                   fillColor: MaterialStatePropertyAll(notifier.blackcolor),
//                                   activeColor: notifier.purplecolor,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       operator = value as String;
//                                       searchBusApi.operatorList = (index + 1).toString();
//                                     });
//                                     searchBusApi.searchBus(context);
//                                     print(pickplace);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
