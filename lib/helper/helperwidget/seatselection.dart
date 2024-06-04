
import 'package:zigzagbus/apicontroller/buslayoutcontroller.dart';
import 'package:zigzagbus/apicontroller/pickdroppointcontroller.dart';
import 'package:zigzagbus/helper/filldetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../apicontroller/searchbuscontroller.dart';
import '../../apicontroller/walletreportapi.dart';
import '../../mediaquery/mq.dart';
import '../colornotifier.dart';

class SeatSelection extends StatefulWidget {
  final BoxConstraints constraints;
  final int index2;
  final String commission;
  const SeatSelection({super.key, required this.constraints, required this.index2, required this.commission});

  @override
  State<SeatSelection> createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  BusLayoutApi busLayoutApi = Get.put(BusLayoutApi());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  PickDropController pickdropApi = Get.put(PickDropController());
  WalletReportApi walletReportApi = Get.put(WalletReportApi());

  int boardingPoint = 0;
  int dropPoint = 0;

  double total = 0;

  List seat = [
    'assets/seats/booked.png',
    'assets/seats/femalebooked.png',
    'assets/seats/selected.png',
    'assets/seats/empty.png'
  ];
  List seattitle = ['Booked'.tr, 'Female Booked'.tr, 'Selected'.tr, 'Empty'.tr];
  List lowwerselectseat = [];
  List upperselectseat = [];
  bool isloading = true;

  Map pickData = {
    "sub_pick_time" : "",
    "sub_pick_address" : "",
    "sub_pick_mobile" : "",
  };

  Map dropData = {
    "sub_drop_time" : "",
    "sub_drop_address" : ""
  };

  String pickplace = '';
  String dropplace = '';

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return selecter();
  }

  Widget selecter() {
    return widget.constraints.maxWidth < 1000
        ? Column(
            children: [
              GetBuilder<PickDropController>(builder: (pickdropApi){
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: notifier.whitecolor),
                    child: ExpansionTile(
                      trailing: const Icon(Icons.add_rounded,
                          color: Colors.transparent),
                      initiallyExpanded: true,
                      title: Text('Boarding Point'.tr,
                          style: TextStyle(
                              fontFamily: 'SofiaLight',
                              color: notifier.purplecolor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              fontSize: 16)),
                      children: [
                        searchBusApi.searchBusData!.busData.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("No data found!".tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: notifier.blackcolor,
                                  fontFamily: 'SofiaLight')),
                        )
                            : pickdropApi.isloading
                            ? const CircularProgressIndicator()
                            : ListView.builder(
                          shrinkWrap: true,
                          itemCount: pickdropApi.pickdropData!.pickUpStops.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    pickplace = pickdropApi.pickdropData!.pickUpStops[index].pickPlace;
                                    boardingPoint = index;
                                    pickData["sub_pick_mobile"] =  pickdropApi.pickdropData!.pickUpStops[index].pickMobile;
                                    pickData["sub_pick_time"] =  pickdropApi.pickdropData!.pickUpStops[index].pickTime;
                                    pickData["sub_pick_address"] =  pickdropApi.pickdropData!.pickUpStops[index].pickAddress;
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: index,
                                      fillColor: MaterialStatePropertyAll(notifier.blackcolor),
                                      groupValue: boardingPoint,
                                      activeColor: notifier.purplecolor,
                                      onChanged: (value) {
                                        setState(() {
                                          pickplace = pickdropApi.pickdropData!.pickUpStops[index].pickPlace;
                                          boardingPoint = index;
                                          pickData["sub_pick_mobile"] =  pickdropApi.pickdropData!.pickUpStops[index].pickMobile;
                                          pickData["sub_pick_time"] =  pickdropApi.pickdropData!.pickUpStops[index].pickTime;
                                          pickData["sub_pick_address"] =  pickdropApi.pickdropData!.pickUpStops[index].pickAddress;
                                          boardingPoint = value!;
                                        });
                                      },),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(pickdropApi.pickdropData!.pickUpStops[index].pickPlace,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: notifier
                                                      .subgreycolor,
                                                  fontFamily:
                                                  'SofiaLight')),
                                          const SizedBox(height: 5),
                                          Text(convertTimeTo12HourFormat(pickdropApi.pickdropData!.pickUpStops[index].pickTime),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: notifier.blackcolor,
                                                  fontFamily: 'SofiaLight')),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              ),
              GetBuilder<PickDropController>(builder: (pickdropApi){
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: notifier.whitecolor),
                    child: ExpansionTile(
                      trailing: const Icon(Icons.add_rounded,
                          color: Colors.transparent),
                      initiallyExpanded: true,
                      title: Text('Drop Point'.tr,
                          style: TextStyle(
                              fontFamily: 'SofiaLight',
                              color: notifier.purplecolor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              fontSize: 14)),
                      children: [
                        searchBusApi.searchBusData!.busData.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("No data found!".tr,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: notifier.blackcolor,
                                  fontFamily: 'SofiaLight')),
                        )
                            : pickdropApi.isloading
                            ? const CircularProgressIndicator()
                            : ListView.builder(
                          shrinkWrap: true,
                          itemCount: pickdropApi.pickdropData!.dropStops.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    dropplace = pickdropApi.pickdropData!.dropStops[index].dropPlace;
                                    dropPoint = index;
                                    dropData["sub_drop_time"] =   pickdropApi.pickdropData!.dropStops[index].dropTime;
                                    dropData["sub_drop_address"] =  pickdropApi.pickdropData!.dropStops[index].dropAddress;
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: index,
                                      fillColor: MaterialStatePropertyAll(notifier.blackcolor),
                                      groupValue: dropPoint,
                                      activeColor: notifier.purplecolor,
                                      onChanged: (value) {
                                        setState(() {
                                            dropplace = pickdropApi.pickdropData!.dropStops[index].dropPlace;
                                            dropPoint = index;
                                            dropData["sub_drop_time"] =   pickdropApi.pickdropData!.dropStops[index].dropTime;
                                            dropData["sub_drop_address"] =  pickdropApi.pickdropData!.dropStops[index].dropAddress;
                                          dropPoint = value!;
                                        });
                                      },),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(pickdropApi.pickdropData!.dropStops[index].dropPlace,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: notifier.subgreycolor,
                                                  fontFamily: 'SofiaLight')),
                                          const SizedBox(height: 5),
                                          Text(convertTimeTo12HourFormat(pickdropApi.pickdropData!.dropStops[index].dropTime),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: notifier.blackcolor,
                                                  fontFamily: 'SofiaLight')),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              ),
              const SizedBox(height: 10),
              Container(
                color: notifier.isDark ? notifier.backgroundColor : notifier.grey03,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout.isEmpty ? Container(
                          // width: 52 * 4,
                          width: searchBusApi.searchBusData!.busData[0].isSleeper == '1' ? double.parse((50 * busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[0].length).toString()) : double.parse((61 * busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[0].length).toString()),
                          color: notifier.whitecolor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                busLayoutApi.buslayoutData?.busLayoutData[0].driverDirection == "0" ? lowwer() : lowwerRiverse(),
                                Divider(
                                  color: notifier.blackcolor,
                                ),
                                ListView.builder(
                                  itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index1) {
                                    return SizedBox(
                                      height: 80,
                                      width: 100,
                                      child: ListView.builder(
                                        itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[0].length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,

                                        itemBuilder: (context, index) {
                                          return   busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[index1][index].seatNumber ==''
                                              ? const SizedBox(
                                            width: 48,
                                          )
                                              :Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {

                                                  if(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked){

                                                    if(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE'){

                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          backgroundColor: notifier.blackcolor,
                                                          content:  Text('Booked by Female passenger'.tr,style: TextStyle(fontSize: 16, color: notifier.blackwhitecolor),),
                                                          width: 500,
                                                          behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                      );
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          backgroundColor: notifier.blackcolor,
                                                          content:  Text('Booked by Others'.tr,style: TextStyle(fontSize: 16, color: notifier.blackwhitecolor),),
                                                          width: 500,
                                                          behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                      );
                                                    }
                                                  } else {
                                                    if(lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) == true){
                                                      setState(() {
                                                        // bottom -= double.parse(data!.busLayoutData[0].ticketPrice);
                                                        lowwerselectseat.remove(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                      });
                                                    } else {
                                                      if(lowwerselectseat.length + upperselectseat.length == int.parse(busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit)){
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            width: 550,
                                                            backgroundColor: notifier.blackcolor,
                                                            content: RichText(
                                                              text: TextSpan(
                                                                  text: "You can not add more than".tr,
                                                                  style: TextStyle(color: notifier.whitecolor),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: " ${busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit} ",
                                                                        children: [
                                                                          TextSpan(
                                                                            text: "passengers to a single booking with this operator".tr,
                                                                          )
                                                                        ]
                                                                    )
                                                                  ]
                                                              ),
                                                            ), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      } else {
                                                        setState(() {
                                                          lowwerselectseat.add(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                        });
                                                      }
                                                    }
                                                  }

                                                });
                                              },
                                              child: Container(
                                                height: 46,
                                                width: 45,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    image: busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/ladischair.png"),fit: BoxFit.fill)
                                                        : busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/bookedchair.png"),fit: BoxFit.fill)
                                                        : lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selectedchair.png"),fit: BoxFit.fill)
                                                        : const DecorationImage(image: AssetImage("assets/seats/emptychair.png"),fit: BoxFit.fill)
                                                ),
                                                child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ) : Container(
                          // width: 52 * 4,
                          width: double.parse((52 * busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[0].length).toString()),
                          color: notifier.whitecolor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                busLayoutApi.buslayoutData?.busLayoutData[0].driverDirection == "0" ? lowwer() : lowwerRiverse(),
                                Divider(color: notifier.blackcolor,),
                                ListView.builder(
                                  itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index1) {
                                    return SizedBox(
                                      height: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 80 : 60,
                                      child: ListView.builder(
                                        itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[0].length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return  busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[index1][index].seatNumber ==''
                                              ? SizedBox(
                                            width: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 48 : 35,
                                          )
                                              :Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {

                                                  if(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked){

                                                    if(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE'){

                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          backgroundColor: notifier.blackcolor,
                                                          content:  Text('Booked by Female passenger'.tr,style: TextStyle(fontSize: 16, color: notifier.blackwhitecolor),),
                                                          width: 500,
                                                          behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                      );

                                                    } else {

                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          backgroundColor: notifier.blackcolor,
                                                          content:  Text('Booked by Others'.tr,style: TextStyle(fontSize: 16, color: notifier.blackwhitecolor),),
                                                          width: 500,
                                                          behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                      );
                                                    }
                                                  } else {
                                                    if(lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) == true){
                                                      setState(() {
                                                        total -= double.parse(busLayoutApi.buslayoutData!.busLayoutData[0].ticketPrice);
                                                        lowwerselectseat.remove(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                      });
                                                    } else {
                                                      if(lowwerselectseat.length + upperselectseat.length == int.parse(busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit)){
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            width: 550,
                                                            backgroundColor: notifier.blackcolor,
                                                            content: RichText(
                                                              text: TextSpan(
                                                                  text: "You can not add more than".tr,
                                                                  style: TextStyle(color: notifier.whitecolor),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: " ${busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit} ",
                                                                        children: [
                                                                          TextSpan(
                                                                            text: "passengers to a single booking with this operator".tr,
                                                                          )
                                                                        ]
                                                                    )
                                                                  ]
                                                              ),
                                                            ), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      } else {
                                                        setState(() {
                                                          total += double.parse(busLayoutApi.buslayoutData!.busLayoutData[0].ticketPrice);
                                                          lowwerselectseat.add(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                        });
                                                      }
                                                    }
                                                  }
                                                });
                                              },
                                              child: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? Container(
                                                height: 60,
                                                width: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    image: busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/femalebooked.png"),fit: BoxFit.fill)
                                                        : busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/booked.png"),fit: BoxFit.fill)
                                                        : lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selected.png"),fit: BoxFit.fill)
                                                        : const DecorationImage(image: AssetImage("assets/seats/empty.png"),fit: BoxFit.fill)
                                                ),
                                                child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),)
                                                  : Row(
                                                    children: [
                                                      Container(
                                                        height: 45,
                                                        width: 45,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                        image: busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/ladischair.png"),fit: BoxFit.fill)
                                                            : busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/bookedchair.png"),fit: BoxFit.fill)
                                                            : lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selectedchair.png"),fit: BoxFit.fill)
                                                            : const DecorationImage(image: AssetImage("assets/seats/emptychair.png"),fit: BoxFit.fill)
                                                          ),
                                                       child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),
                                                      ),
                                                    ],
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout.isEmpty ? const SizedBox() : Container(
                          // width: 52 * 4,
                          width: double.parse((52 * busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[0].length).toString()),
                          color: notifier.whitecolor,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                busLayoutApi.buslayoutData?.busLayoutData[0].driverDirection == "1" ? upper() : upperRiverse(),
                                Divider(
                                  color: notifier.blackcolor,
                                ),
                                ListView.builder(
                                  itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].upperLayout.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index1) {
                                    return SizedBox(
                                      height: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 80 : 60,
                                      child: ListView.builder(
                                        itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[0].length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5),
                                            child: Container(
                                              child: busLayoutApi.buslayoutData?.busLayoutData[0].upperLayout[index1][index].seatNumber == ''
                                                  ? SizedBox(
                                                width: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 48 : 35,
                                              )
                                                  : InkWell(
                                                onTap: () {
                                                  setState(() {

                                                    if(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].isBooked){

                                                      if(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].gender == 'FEMALE'){

                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            backgroundColor: notifier.blackcolor,
                                                            content:  Text('Booked by Female passenger'.tr,style: TextStyle(fontSize: 16, color: notifier.blackwhitecolor),),
                                                            width: 500,
                                                            behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            backgroundColor: notifier.blackcolor,
                                                            content:  Text('Booked by Others'.tr,style: TextStyle(fontSize: 16, color: notifier.blackwhitecolor),),
                                                            width: 500,
                                                            behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      }
                                                    } else {
                                                      if(upperselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber) == true){
                                                        setState(() {
                                                          total -= double.parse(busLayoutApi.buslayoutData!.busLayoutData[0].ticketPrice);
                                                          upperselectseat.remove(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber);

                                                        });
                                                      } else {
                                                        if(lowwerselectseat.length + upperselectseat.length == int.parse(busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit)){
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              width: 550,
                                                              backgroundColor: notifier.blackcolor,
                                                              content: RichText(
                                                                text: TextSpan(
                                                                    text: "You can not add more than".tr,
                                                                    style: TextStyle(color: notifier.whitecolor),
                                                                    children: [
                                                                      TextSpan(
                                                                          text: " ${busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit} ",
                                                                          children: [
                                                                            TextSpan(
                                                                              text: "passengers to a single booking with this operator".tr,
                                                                            )
                                                                          ]
                                                                      )
                                                                    ]
                                                                ),
                                                              ), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                          );
                                                        } else {
                                                          setState(() {
                                                            total += double.parse(busLayoutApi.buslayoutData!.busLayoutData[0].ticketPrice);
                                                            upperselectseat.add(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber);
                                                          });
                                                        }
                                                      }
                                                    }

                                                  });
                                                },
                                                child: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? Container(
                                                  height: 60,
                                                  width: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      image: busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/femalebooked.png"),fit: BoxFit.fill)
                                                          : busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/booked.png"),fit: BoxFit.fill)
                                                          : upperselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selected.png"),fit: BoxFit.fill)
                                                          : const DecorationImage(image: AssetImage("assets/seats/empty.png"),fit: BoxFit.fill)
                                                  ),
                                                  child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),
                                                )
                                                  : Row(
                                              children: [
                                              Container(
                                              height: 45,
                                                width: 45,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  image: busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/ladischair.png"),fit: BoxFit.fill)
                                                      : busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/bookedchair.png"),fit: BoxFit.fill)
                                                      : upperselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selectedchair.png"),fit: BoxFit.fill,)
                                                      : const DecorationImage(image: AssetImage("assets/seats/emptychair.png"),fit: BoxFit.fill,),
                                                ),
                                                child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),
                                              ),
                                              ],
                                            )
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: notifier.whitecolor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 40,
                        crossAxisCount: widget.constraints.maxWidth < 650 ? 2 : 4),
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Image.asset(seat[index],
                              height: height / 30),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            seattitle[index],
                            style: TextStyle(
                                fontFamily: 'SofiaLight',
                                fontSize: height / 60,
                                fontWeight: FontWeight.w600,
                                color: notifier.blackcolor),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: notifier.whitecolor,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seats'.tr,style: TextStyle(
                              fontFamily: 'SofiaLight',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: notifier.blackcolor,
                            )),
                            lowwerselectseat.isEmpty ? const SizedBox() :Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Lower Seat -'.tr,style: TextStyle(
                                  fontFamily: 'SofiaLight',
                                  fontSize: 14,
                                  color: notifier.blackcolor,
                                )),
                                const SizedBox(width: 10),
                                Text('(${lowwerselectseat.length}) -',style: TextStyle(
                                  fontFamily: 'SofiaLight',
                                  fontSize: 14,
                                  color: notifier.blackcolor,
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(lowwerselectseat.join(', '),style: TextStyle(
                                    fontFamily: 'SofiaLight',
                                    fontSize: 14,
                                    color: notifier.blackcolor,
                                  )),
                                ),
                              ],
                            ),
                            upperselectseat.isEmpty ? const SizedBox() : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Upper Seat -'.tr,style: TextStyle(
                                  fontFamily: 'SofiaLight',
                                  fontSize: 14,
                                  color: notifier.blackcolor,
                                )),
                                const SizedBox(width: 10),
                                Text('(${upperselectseat.length}) -',style: TextStyle(
                                  fontFamily: 'SofiaLight',
                                  fontSize: 14,
                                  color: notifier.blackcolor,
                                )),
                                upperselectseat.isEmpty ? const SizedBox() : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(upperselectseat.join(', '),style: TextStyle(
                                    fontFamily: 'SofiaLight',
                                    fontSize: 14,
                                    color: notifier.blackcolor,
                                  )),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('${searchBusApi.searchBusData!.currency} ${total.toStringAsFixed(2)}',style: TextStyle(
                              fontFamily: 'SofiaLight',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: notifier.blackcolor,
                            )),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: const MaterialStatePropertyAll(0),
                                backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                              ),
                              onPressed: () {

                                if (pickplace.isEmpty && dropplace.isEmpty) {
                                  pickplace = pickdropApi.pickdropData!.pickUpStops[0].pickPlace;
                                  dropplace = pickdropApi.pickdropData!.dropStops[0].dropPlace;
                                  pickData["sub_pick_mobile"] =  pickdropApi.pickdropData!.pickUpStops[0].pickMobile;
                                  pickData["sub_pick_time"] =  pickdropApi.pickdropData!.pickUpStops[0].pickTime;
                                  pickData["sub_pick_address"] =  pickdropApi.pickdropData!.pickUpStops[0].pickAddress;
                                  dropData["sub_drop_time"] =   pickdropApi.pickdropData!.dropStops[0].dropTime;
                                  dropData["sub_drop_address"] =  pickdropApi.pickdropData!.dropStops[0].dropAddress;
                                }

                                if (lowwerselectseat.isNotEmpty || upperselectseat.isNotEmpty) {

                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return PassangerDetails(commission: widget.commission,dropData: dropData,pickData: pickData,seatnumber: upperselectseat + lowwerselectseat,pickplace: pickplace,dropplace: dropplace,index2: widget.index2,total: total,);
                                  },)).then((value) => {walletReportApi.walletReport(context)});

                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: notifier.blackcolor,
                                      content:  Text("Please select seat first!".tr,style: TextStyle(fontSize: 16, color: notifier.blackwhitecolor),),
                                      width: 500,
                                      behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  );
                                }
                              }, child: Text('Procced'.tr,style: const TextStyle(
                              fontFamily: 'SofiaLight',
                              fontSize: 12,
                              color: Colors.white,
                            )),),
                          ],
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(
      decoration: BoxDecoration(
          color: notifier.isDark ? notifier.backgroundColor : notifier.grey03,
          borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        GetBuilder<PickDropController>(builder: (pickdropApi){
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: notifier.whitecolor),
                              child: ExpansionTile(
                                trailing: const Icon(Icons.add_rounded,
                                    color: Colors.transparent),
                                initiallyExpanded: true,
                                title: Text('Boarding Point'.tr,
                                    style: TextStyle(
                                        fontFamily: 'SofiaLight',
                                        color: notifier.purplecolor,
                                        letterSpacing: 1,
                                        fontSize: 16)),
                                children: [
                                 pickdropApi.isloading ? CircularProgressIndicator(color: notifier.purplecolor) : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 30),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: pickdropApi.pickdropData!.pickUpStops.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  pickplace = pickdropApi.pickdropData!.pickUpStops[index].pickPlace;
                                                  boardingPoint = index;
                                                  pickData["sub_pick_mobile"] =  pickdropApi.pickdropData!.pickUpStops[index].pickMobile;
                                                  pickData["sub_pick_time"] =  pickdropApi.pickdropData!.pickUpStops[index].pickTime;
                                                  pickData["sub_pick_address"] =  pickdropApi.pickdropData!.pickUpStops[index].pickAddress;
                                                });
                                              },
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Radio(
                                                    value: index,
                                                    fillColor: MaterialStatePropertyAll(notifier.blackcolor),
                                                    groupValue: boardingPoint,
                                                    activeColor: notifier.purplecolor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        boardingPoint = value!;
                                                        pickplace = pickdropApi.pickdropData!.pickUpStops[index].pickPlace;
                                                        pickData["sub_pick_mobile"] =  pickdropApi.pickdropData!.pickUpStops[index].pickMobile;
                                                        pickData["sub_pick_time"] =  pickdropApi.pickdropData!.pickUpStops[index].pickTime;
                                                        pickData["sub_pick_address"] =  pickdropApi.pickdropData!.pickUpStops[index].pickAddress;
                                                      });
                                                    },),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(pickdropApi.pickdropData!.pickUpStops[index].pickPlace,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: notifier
                                                                    .subgreycolor,
                                                                fontFamily:
                                                                    'SofiaLight')),
                                                        const SizedBox(height: 5),
                                                        Text(convertTimeTo12HourFormat(pickdropApi.pickdropData!.pickUpStops[index].pickTime),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: notifier.blackcolor,
                                                                fontFamily: 'SofiaLight')),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                ],
                              ),
                            );
                          }),
                        const SizedBox(height: 10),
                        GetBuilder<PickDropController>(builder: (pickdropApi){
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: notifier.whitecolor),
                              child: ExpansionTile(
                                trailing: const Icon(Icons.add_rounded,
                                    color: Colors.transparent),
                                initiallyExpanded: true,
                                title: Text('Drop Point'.tr,
                                    style: TextStyle(
                                        fontFamily: 'SofiaLight',
                                        color: notifier.purplecolor,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                        fontSize: 14)),
                                children: [
                                  searchBusApi.searchBusData!.busData.isEmpty
                                      ? Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text("No data found!".tr,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: notifier.blackcolor,
                                            fontFamily: 'SofiaLight')),
                                  )
                                      : pickdropApi.isloading
                                      ? const CircularProgressIndicator()
                                      : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 30),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: pickdropApi.pickdropData!.dropStops.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  dropplace = pickdropApi.pickdropData!.dropStops[index].dropPlace;
                                                  dropPoint = index;
                                                  dropData["sub_drop_time"] =   pickdropApi.pickdropData!.dropStops[index].dropTime;
                                                  dropData["sub_drop_address"] =  pickdropApi.pickdropData!.dropStops[index].dropAddress;
                                                });
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Radio(
                                                    value: index,
                                                    fillColor: MaterialStatePropertyAll(notifier.blackcolor),
                                                    groupValue: dropPoint,
                                                    activeColor: notifier.purplecolor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        dropPoint = value!;
                                                        dropplace = pickdropApi.pickdropData!.dropStops[index].dropPlace;
                                                        dropData["sub_drop_time"] =   pickdropApi.pickdropData!.dropStops[index].dropTime;
                                                        dropData["sub_drop_address"] =  pickdropApi.pickdropData!.dropStops[index].dropAddress;
                                                      });
                                                    },),
                                                  const SizedBox(width: 10),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(pickdropApi.pickdropData!.dropStops[index].dropPlace,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: notifier.subgreycolor,
                                                                fontFamily: 'SofiaLight')),
                                                        const SizedBox(height: 5),
                                                        Text(convertTimeTo12HourFormat(pickdropApi.pickdropData!.dropStops[index].dropTime),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: notifier.blackcolor,
                                                                fontFamily: 'SofiaLight')),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                ],
                              ),
                            );
                          }
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: notifier.whitecolor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: GridView.builder(
                              itemCount: 4,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 40,
                                      crossAxisCount: 1),
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Image.asset(seat[index],
                                        height: 30),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      seattitle[index],
                                      style: TextStyle(
                                          fontFamily: 'SofiaLight',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: notifier.blackcolor),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    children: [
                      Row(
                        children: [
                          busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout.isEmpty ? Container(
                            // width: 52 * 4,
                            width: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? double.parse((50 * busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[0].length).toString()) : double.parse((61 * busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[0].length).toString()),
                            color: notifier.whitecolor,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  busLayoutApi.buslayoutData?.busLayoutData[0].driverDirection == "0" ? lowwer() : lowwerRiverse(),
                                  Divider(
                                    color: notifier.blackcolor,
                                  ),
                                  ListView.builder(
                                    itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index1) {
                                      return SizedBox(
                                        height: 60,
                                        child: ListView.builder(
                                          itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[0].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return   busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[index1][index].seatNumber ==''
                                                ?  SizedBox(
                                              width: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 48 : 35,
                                            )
                                                :Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {

                                                    if(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked){

                                                      if(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE'){

                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content:  Text('Booked by Female passenger'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content:  Text('Booked by Others'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      }
                                                    } else {
                                                      if(lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) == true){
                                                        setState(() {
                                                          // bottom -= double.parse(data!.busLayoutData[0].ticketPrice);
                                                          lowwerselectseat.remove(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                        });
                                                      } else {
                                                        if(lowwerselectseat.length + upperselectseat.length == int.parse(busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit)){
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              width: 550,
                                                              backgroundColor: notifier.blackcolor,
                                                              content: RichText(
                                                                text: TextSpan(
                                                                    text: "You can not add more than".tr,
                                                                    style: TextStyle(color: notifier.whitecolor),
                                                                    children: [
                                                                      TextSpan(
                                                                          text: " ${busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit} ",
                                                                          children: [
                                                                            TextSpan(
                                                                              text: "passengers to a single booking with this operator".tr,
                                                                            )
                                                                          ]
                                                                      )
                                                                    ]
                                                                ),
                                                              ), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                          );
                                                        } else {
                                                          setState(() {
                                                            lowwerselectseat.add(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                          });
                                                        }
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      image: busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/ladischair.png"),fit: BoxFit.fill)
                                                          : busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/bookedchair.png"),fit: BoxFit.fill)
                                                          : lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selectedchair.png"),fit: BoxFit.fill)
                                                          : const DecorationImage(image: AssetImage("assets/seats/emptychair.png"),fit: BoxFit.fill)
                                                  ),
                                                  child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ) : Container(
                            // width: 52 * 4,
                            width: double.parse((52 * busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[0].length).toString()),
                            color: notifier.whitecolor,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  busLayoutApi.buslayoutData?.busLayoutData[0].driverDirection == "0" ? lowwer() : lowwerRiverse(),
                                  Divider(
                                    color: notifier.blackcolor,
                                  ),
                                  ListView.builder(
                                    itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index1) {
                                      return SizedBox(
                                        height: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 80 : 60,
                                        child: ListView.builder(
                                          itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[0].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return   busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[index1][index].seatNumber ==''
                                                ? SizedBox(
                                              width: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 48 : 35,
                                            )
                                                :Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked){

                                                      if(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE'){

                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content:  Text('Booked by Female passenger'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content:  Text('Booked by Others'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                        );
                                                      }
                                                    } else {
                                                      if(lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) == true){
                                                        setState(() {
                                                          total -= double.parse(busLayoutApi.buslayoutData!.busLayoutData[0].ticketPrice);
                                                          // bottom -= double.parse(data!.busLayoutData[0].ticketPrice);
                                                          lowwerselectseat.remove(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                        });
                                                      } else {
                                                        if(lowwerselectseat.length + upperselectseat.length == int.parse(busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit)){
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              width: 550,
                                                              backgroundColor: notifier.blackcolor,
                                                              content: RichText(
                                                              text: TextSpan(
                                                                  text: "You can not add more than".tr,
                                                                  style: TextStyle(color: notifier.whitecolor),
                                                                  children: [
                                                                    TextSpan(
                                                                        text: " ${busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit} ",
                                                                        children: [
                                                                          TextSpan(
                                                                            text: "passengers to a single booking with this operator".tr,
                                                                          )
                                                                        ]
                                                                    )
                                                                  ]
                                                              ),
                                                            ), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                          );
                                                        } else {
                                                          setState(() {
                                                            total += double.parse(busLayoutApi.buslayoutData!.busLayoutData[0].ticketPrice);
                                                            lowwerselectseat.add(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber);
                                                          });
                                                        }
                                                      }
                                                    }
                                                  });
                                                },
                                                child: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? Container(
                                                  height: 60,
                                                  width: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    image: busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/femalebooked.png"),fit: BoxFit.fill)
                                                        : busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/booked.png"),fit: BoxFit.fill)
                                                        : lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selected.png"),fit: BoxFit.fill)
                                                        : const DecorationImage(image: AssetImage("assets/seats/empty.png"),fit: BoxFit.fill),
                                                  ),
                                                  child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),)
                                                    : Row(
                                                      children: [
                                                        Container(
                                                            height: 45,
                                                            width: 45,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                        image: busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/ladischair.png"),fit: BoxFit.fill)
                                                            : busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/bookedchair.png"),fit: BoxFit.fill)
                                                            : lowwerselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selectedchair.png"),fit: BoxFit.fill)
                                                            : const DecorationImage(image: AssetImage("assets/seats/emptychair.png"),fit: BoxFit.fill),
                                                             ),
                                                            child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),
                                                          ),
                                                      ],
                                                    )
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout.isEmpty ? const SizedBox() : Container(
                            // width: 52 * 4,
                            width: double.parse((52 * busLayoutApi.buslayoutData!.busLayoutData[0].lowerLayout[0].length).toString()),
                            color: notifier.whitecolor,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  busLayoutApi.buslayoutData?.busLayoutData[0].driverDirection == "1" ? upper() : upperRiverse(),
                                  Divider(
                                    color: notifier.blackcolor,
                                  ),
                                  ListView.builder(
                                    itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].upperLayout.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index1) {
                                      return SizedBox(
                                        height: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 80 : 60,
                                        child: ListView.builder(
                                          itemCount: busLayoutApi.buslayoutData?.busLayoutData[0].lowerLayout[0].length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: Container(
                                                child: busLayoutApi.buslayoutData?.busLayoutData[0].upperLayout[index1][index].seatNumber == ''
                                                    ? SizedBox(
                                                  width: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? 48 : 35,
                                                )
                                                    : InkWell(
                                                  onTap: () {
                                                    setState(() {

                                                      if(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].isBooked){

                                                        if(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].gender == 'FEMALE'){

                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content:  Text('Booked by Female passenger'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content:  Text('Booked by Others'.tr),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                          );
                                                        }
                                                      } else {
                                                        if(upperselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber) == true){
                                                          setState(() {
                                                            total -= double.parse(busLayoutApi.buslayoutData!.busLayoutData[0].ticketPrice);
                                                            upperselectseat.remove(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber);
                                                          });
                                                        } else {
                                                           if(lowwerselectseat.length + upperselectseat.length == int.parse(busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit)){
                                                             ScaffoldMessenger.of(context).showSnackBar(
                                                               SnackBar(
                                                                 width: 550,
                                                                 backgroundColor: notifier.blackcolor,
                                                                 content: RichText(
                                                                   text: TextSpan(
                                                                       text: "You can not add more than".tr,
                                                                       style: TextStyle(color: notifier.whitecolor),
                                                                       children: [
                                                                         TextSpan(
                                                                             text: " ${busLayoutApi.buslayoutData!.busLayoutData[0].bookLimit} ",
                                                                             children: [
                                                                               TextSpan(
                                                                                 text: "passengers to a single booking with this operator".tr,
                                                                               )
                                                                             ]
                                                                         )
                                                                       ]
                                                                   ),
                                                                 ), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                                             );
                                                           } else {
                                                             setState(() {
                                                               total += double.parse(busLayoutApi.buslayoutData!.busLayoutData[0].ticketPrice);
                                                               upperselectseat.add(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber);
                                                             });
                                                           }
                                                        }
                                                      }
                                                    });
                                                  },
                                                      child: searchBusApi.searchBusData!.busData[widget.index2].isSleeper == '1' ? Container(
                                                        height: 60,
                                                        width: 40,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            image: busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/femalebooked.png"),fit: BoxFit.fill)
                                                                : busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/booked.png"),fit: BoxFit.fill)
                                                                : upperselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selected.png"),fit: BoxFit.fill)
                                                                : const DecorationImage(image: AssetImage("assets/seats/empty.png"),fit: BoxFit.fill)
                                                        ),
                                                        child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),
                                                      )
                                                          : Row(
                                                            children: [
                                                              Container(
                                                                 height: 45,
                                                                 width: 45,
                                                                 alignment: Alignment.center,
                                                                 decoration: BoxDecoration(
                                                              image: busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].gender == 'FEMALE' ? const DecorationImage(image: AssetImage("assets/seats/ladischair.png"),fit: BoxFit.fill)
                                                                  : busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].isBooked ? const DecorationImage(image: AssetImage("assets/seats/bookedchair.png"),fit: BoxFit.fill)
                                                                  : upperselectseat.contains(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber) ? const DecorationImage(image: AssetImage("assets/seats/selectedchair.png"),fit: BoxFit.fill,)
                                                                  : const DecorationImage(image: AssetImage("assets/seats/emptychair.png"),fit: BoxFit.fill,),
                                                                   ),
                                                               child: Text(busLayoutApi.buslayoutData!.busLayoutData[0].upperLayout[index1][index].seatNumber,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.subgreycolor,fontSize: 12)),
                                                                                                                        ),
                                                            ],
                                                          )
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 52*8,
                        decoration: BoxDecoration(
                            color: notifier.whitecolor,
                            borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Seats'.tr,style: TextStyle(
                                      fontFamily: 'SofiaLight',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: notifier.blackcolor,
                                    )),
                                    lowwerselectseat.isEmpty ? const SizedBox() :Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Lower Seat -'.tr,style: TextStyle(
                                          fontFamily: 'SofiaLight',
                                          fontSize: 14,
                                          color: notifier.blackcolor,
                                        )),
                                        const SizedBox(width: 10),
                                        Text('(${lowwerselectseat.length}) -',style: TextStyle(
                                          fontFamily: 'SofiaLight',
                                          fontSize: 14,
                                          color: notifier.blackcolor,
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(lowwerselectseat.join(', '),style: TextStyle(
                                            fontFamily: 'SofiaLight',
                                            fontSize: 14,
                                            color: notifier.blackcolor,
                                          )),
                                        ),
                                      ],
                                    ),
                                    upperselectseat.isEmpty ? const SizedBox() : Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Upper Seat -'.tr,style: TextStyle(
                                          fontFamily: 'SofiaLight',
                                          fontSize: 14,
                                          color: notifier.blackcolor,
                                        )),
                                        const SizedBox(width: 10),
                                        Text('(${upperselectseat.length}) -',style: TextStyle(
                                          fontFamily: 'SofiaLight',
                                          fontSize: 14,
                                          color: notifier.blackcolor,
                                        )),
                                        upperselectseat.isEmpty ? const SizedBox() : Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(upperselectseat.join(', '),style: TextStyle(
                                            fontFamily: 'SofiaLight',
                                            fontSize: 14,
                                            color: notifier.blackcolor,
                                          )),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('${searchBusApi.searchBusData!.currency} ${total.toStringAsFixed(2)}',style: TextStyle(
                                      fontFamily: 'SofiaLight',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: notifier.blackcolor,
                                    )),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(0),
                                        backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                      ),
                                      onPressed: () {
                                        if (pickplace.isEmpty && dropplace.isEmpty) {
                                          pickplace = pickdropApi.pickdropData!.pickUpStops[0].pickPlace;
                                          dropplace = pickdropApi.pickdropData!.dropStops[0].dropPlace;
                                          pickData["sub_pick_mobile"] =  pickdropApi.pickdropData!.pickUpStops[0].pickMobile;
                                          pickData["sub_pick_time"] =  pickdropApi.pickdropData!.pickUpStops[0].pickTime;
                                          pickData["sub_pick_address"] =  pickdropApi.pickdropData!.pickUpStops[0].pickAddress;
                                          dropData["sub_drop_time"] =   pickdropApi.pickdropData!.dropStops[0].dropTime;
                                          dropData["sub_drop_address"] =  pickdropApi.pickdropData!.dropStops[0].dropAddress;
                                        }

                                        if (lowwerselectseat.isNotEmpty || upperselectseat.isNotEmpty) {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                                            return PassangerDetails(commission: widget.commission,dropData: dropData,pickData: pickData,seatnumber: upperselectseat + lowwerselectseat,pickplace: pickplace,dropplace: dropplace,index2: widget.index2,total: total,);
                                          },));
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: const Text("Please first select your seat!"),width: 400,elevation: 0,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                          );
                                        }
                                      }, child: Text('Procced'.tr,style: const TextStyle(
                                      fontFamily: 'SofiaLight',
                                      fontSize: 12,
                                      color: Colors.white,
                                    )),),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),
        );
  }

  Widget lowwer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Lower Berth'.tr,
          style:
              TextStyle(color: notifier.blackcolor, fontFamily: 'SofiaLight'),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const Spacer(),
        Image.asset('assets/seats/steering.png', height: 30),
      ],
    );
  }

  Widget lowwerRiverse() {
    return Row(
      children: [
        Image.asset('assets/seats/steering.png', height: 30),
        const Spacer(),
        Text(
          'Lower Berth'.tr,
          style: TextStyle(color: notifier.blackcolor),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget upper() {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          const Spacer(),
          const SizedBox(
            height: 30,
            width: 30,
          ),
          Text(
            'Upper Berth'.tr,
            style:
                TextStyle(color: notifier.blackcolor, fontFamily: 'SofiaLight'),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget upperRiverse() {
    return Row(
      children: [
        const Spacer(),
        const SizedBox(
          height: 30,
          width: 30,
        ),
        Text(
          'Upper Berth'.tr,
          style: TextStyle(color: notifier.blackcolor),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
  String convertTimeTo12HourFormat(String time24Hour) {
    // Parse the input time in 24-hour format
    final inputFormat = DateFormat('HH:mm:ss');
    final inputTime = inputFormat.parse(time24Hour);

    // Format the time in 12-hour format
    final outputFormat = DateFormat('h:mm a');
    final formattedTime = outputFormat.format(inputTime);

    return formattedTime;
  }
}
