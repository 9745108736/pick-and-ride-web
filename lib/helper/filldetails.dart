import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/apicontroller/bookticketapi.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/apicontroller/searchbuscontroller.dart';
import 'package:zigzagbus/apicontroller/walletreportapi.dart';
import 'package:zigzagbus/deshboard/heading.dart';
import 'package:zigzagbus/helper/paymentdetails.dart';

import '../config.dart';
import '../deshboard/endofpage.dart';
import '../mediaquery/mq.dart';
import 'appbar.dart';
import 'colornotifier.dart';
import 'drawerCommon.dart';

class PassangerDetails extends StatefulWidget {
  final List seatnumber;
  final String pickplace;
  final String dropplace;
  final int index2;
  final double total;
  final Map pickData;
  final Map dropData;
  final String commission;
  const PassangerDetails({super.key, required this.seatnumber, required this.pickplace, required this.dropplace, required this.index2, required this.total, required this.pickData, required this.dropData, required this.commission});

  @override
  State<PassangerDetails> createState() => _PassangerDetailsState();
}

class _PassangerDetailsState extends State<PassangerDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int a = 0; a < widget.seatnumber.length; a++) {
      dynamicName.add(DynamicWidget());
      dynamicAge.add(DynamicWidget1());
    }
  }

  late ColorNotifier notifier;

  BookTicketApi bookTicketApi = Get.put(BookTicketApi());
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  HomeApiController homeApi = Get.put(HomeApiController());
  WalletReportApi walletReportApi = Get.put(WalletReportApi());

  List<DynamicWidget> dynamicName = [];
  List<DynamicWidget1> dynamicAge = [];

  List male = [];
  List female = [];
  List maleFemale = [];
  List isReademore = [];

  TextEditingController contDetailName = TextEditingController();
  TextEditingController contDetailEmail = TextEditingController();
  TextEditingController contDetailMobile = TextEditingController();

  List<String> dataName = [];

  submitDataName() {
    dataName = [];

    for (int a=0; a < dynamicName.length; a++) {
      if(dynamicName[a].controller.text.isNotEmpty){
        dataName.add(dynamicName[a].controller.text);
      }
    }

    setState(() {});
  }

  List<String> dataAge = [];

  submitDataAge() {
    dataAge = [];
    for (int a=0; a < dynamicAge.length ; a++) {
      if(dynamicAge[a].controller1.text.isNotEmpty){
        dataAge.add(dynamicAge[a].controller1.text);
      }
    }

    setState(() {});
  }

  final GlobalKey<ScaffoldState> detailsKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.isDark ? notifier.backgroundColor : notifier.searchgrey,
      key: detailsKey,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: LocalappBar(gkey: detailsKey,),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
              child: constraints.maxHeight < 1270 ? detailsWidget(constraints) : SizedBox(
                  height: Get.height,
                  child: detailsWidget(constraints)));
        },),
    );
  }
  Widget detailsWidget(constraints){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
              HeadingPage(pageTitle: "Search Bus".tr, nTitle: "Fill Details".tr, currentTitle: ""),
            const SizedBox(height: 10,),
            Padding(
              padding:  EdgeInsets.only(top: constraints.maxWidth < 800 ? 0 : 40 , right: constraints.maxWidth < 800 ? 10 : 0,left: constraints.maxWidth < 800 ? 10 : 0, bottom: constraints.maxWidth < 800 ? 10 : 0),
              child: Row(
                children: [
                  constraints.maxWidth < 800 ? const SizedBox() : const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: notifier.grey04,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: const Color(0xff7D2AFF),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "${Config.imageBaseUrl}${searchBusApi.searchBusData!.busData[widget.index2].busImg}"),
                                                fit: BoxFit.cover)),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(searchBusApi.searchBusData!.busData[widget.index2].busTitle,style: const TextStyle(fontFamily: 'SofiaLight',fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black,letterSpacing: 1
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            searchBusApi.searchBusData!.busData[widget.index2].busAc ==
                                                "0"
                                                ? RichText(text: TextSpan(
                                              text: "Non AC".tr,
                                            style: const TextStyle(
                                                fontFamily:
                                                'SofiaLight',
                                                fontSize: 14,
                                                color: Colors.black),
                                              children: [
                                                TextSpan(
                                                  text: '/ ${searchBusApi.searchBusData!.busData[widget.index2].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}'.tr,
                                                    style: const TextStyle(
                                                        fontFamily:
                                                        'SofiaLight',
                                                        fontSize: 14,
                                                        color: Colors.black)
                                                )
                                              ]
                                            ))
                                                : RichText(text: TextSpan(
                                                text: "AC".tr,
                                                style: const TextStyle(
                                                    fontFamily:
                                                    'SofiaLight',
                                                    fontSize: 14,
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text:  '/ ${searchBusApi.searchBusData!.busData[widget.index2].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}'.tr,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                          'SofiaLight',
                                                          fontSize: 14,
                                                          color: Colors.black)
                                                  )
                                                ]
                                            )),
                                            const SizedBox(width: 6),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: notifier.lightPurplecolor,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: "${searchBusApi.searchBusData!.busData[widget.index2].totlSeat} ",
                                                    style: TextStyle(
                                                        fontFamily: 'SofiaLight',
                                                        fontWeight: FontWeight.w600,
                                                        color: notifier.purplecolor,
                                                        fontSize:
                                                        12),
                                                    children: [
                                                      TextSpan(
                                                          text: "Seats".tr,
                                                          style: TextStyle(
                                                              fontFamily: 'SofiaLight',
                                                              fontWeight: FontWeight.w600,
                                                              color: notifier.purplecolor,
                                                              fontSize:
                                                              12)
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: notifier.whitecolor,
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(constraints.maxWidth < 800 ? 10 : 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: constraints.maxWidth < 800 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment: constraints.maxWidth < 800 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                            children: [
                                              Text(widget.pickplace,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.blackcolor,fontSize: 14),),
                                              Text(searchBusApi.searchBusData!.busData[widget.index2].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.blackcolor,fontSize: 14),),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(convertTimeTo12HourFormat(widget.pickData["sub_pick_time"]),style: TextStyle(fontFamily: 'SofiaLight',color: notifier.subgreycolor,fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    SvgPicture.asset('assets/deshboard/detailsScreen.svg',height: 100,),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: constraints.maxWidth < 800 ? CrossAxisAlignment.end : CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment: constraints.maxWidth < 800 ? CrossAxisAlignment.end : CrossAxisAlignment.center,
                                            children: [
                                              Text(widget.dropplace,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.blackcolor,fontSize: 14),textAlign: TextAlign.end),
                                              Text(searchBusApi.searchBusData!.busData[widget.index2].dropCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.blackcolor,fontSize: 14),textAlign: TextAlign.end),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(convertTimeTo12HourFormat(widget.dropData["sub_drop_time"]),style: TextStyle(fontFamily: 'SofiaLight',color: notifier.subgreycolor,fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        constraints.maxWidth < 1000 ? Column(
                          children: [
                            passangerDetails(constraints),
                            const SizedBox(height: 10),
                            contactDetails(constraints),
                          ],
                        ) : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            passangerDetails(constraints),
                            const SizedBox(width: 20),
                            contactDetails(constraints),
                          ],
                        ),
                      ],
                    ),
                  ),
                  constraints.maxWidth < 800 ? const SizedBox() : const Spacer(),
                ],
              ),
            ),
            SizedBox(height: constraints.maxWidth < 800 ? 50 : 100),
          ],
        ),
        Container(
            color: notifier.whitecolor,
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: endofpage(),
            )),
      ],
    );
  }
  Widget passangerDetails(constraints){
    return constraints.maxWidth < 1000 ? Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: notifier.whitecolor,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10,top: 20 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                  const SizedBox(width: 10,),
                  Text('Passenger Details'.tr,style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
              child: ListView.builder(
                itemCount: dynamicName.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                      children: [
                        Flexible(
                          flex: constraints.maxWidth < 1100 ? 2 : 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                    text: "Passanger".tr,
                                    style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                                    children: [
                                      TextSpan(
                                          text: " ${index+1} | ",
                                          style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                                          children: [
                                            TextSpan(
                                                text: "Seat ".tr,
                                                style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                                                children: [
                                                  TextSpan(
                                                    text: "${widget.seatnumber[index]}",
                                                    style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                                                  ),
                                                ]
                                            )
                                          ]
                                      )
                                    ]
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 40,
                                child: dynamicName[index],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth < 1100 ? 10 : 20,),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text('Age'.tr, style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 40,
                                child: dynamicAge[index],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth < 1100 ? 10 : 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text('Gender'.tr, style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (maleFemale.contains("MALE-$index") == true) {
                                        maleFemale.remove("MALE-$index");
                                      } else {
                                        maleFemale.remove("FEMALE-$index");
                                        maleFemale.add("MALE-$index");
                                      }
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: maleFemale.contains("MALE-$index") ? notifier.purplecolor : notifier.grey04,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5, bottom: 5,right: 10,left: 10),
                                        child: SvgPicture.asset('assets/deshboard/maleIcon.svg',height: 30,),
                                      )
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (maleFemale.contains("FEMALE-$index") == true) {
                                        maleFemale.remove("FEMALE-$index");
                                      } else {
                                        maleFemale.remove("MALE-$index");
                                        maleFemale.add("FEMALE-$index");
                                      }
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: maleFemale.contains("FEMALE-$index") ? notifier.purplecolor : notifier.grey04,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5, bottom: 5,right: 10,left: 10),
                                        child: SvgPicture.asset('assets/deshboard/femaleIcon.svg',height: 30,),
                                      )
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ]
                  );
                },),
            ),
          ],
        )
    ) :
    Expanded(
      flex: 3,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: notifier.whitecolor,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10,top: 20 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                    const SizedBox(width: 10,),
                    Text('Passenger Details'.tr,style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                child: ListView.builder(
                  itemCount: dynamicName.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          flex: constraints.maxWidth < 1100 ? 2 : 3,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                    text: "Passanger".tr,
                                    style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                                    children: [
                                      TextSpan(
                                          text: " ${index+1} | ",
                                          style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                                          children: [
                                            TextSpan(
                                                text: "Seat".tr,
                                                style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                                                children: [
                                                  TextSpan(
                                                    text: " ${widget.seatnumber[index]}",
                                                    style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),
                                                  ),
                                                ]
                                            )
                                          ]
                                      )
                                    ]
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 40,
                                child: dynamicName[index],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth < 1100 ? 10 : 20,),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text('Age'.tr, style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),),
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 40,
                                child: dynamicAge[index],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth < 1100 ? 10 : 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text('Gender'.tr, style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {

                                      if (maleFemale.contains("MALE-$index") == true) {
                                        maleFemale.remove("MALE-$index");
                                      } else {
                                        maleFemale.remove("FEMALE-$index");
                                        maleFemale.add("MALE-$index");
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: maleFemale.contains("MALE-$index") ? notifier.purplecolor : notifier.grey04,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5, bottom: 5,right: 10,left: 10),
                                      child: SvgPicture.asset('assets/deshboard/maleIcon.svg',height: 30,),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    setState(() {

                                      if (maleFemale.contains("FEMALE-$index") == true) {
                                        maleFemale.remove("FEMALE-$index");
                                      } else {
                                        maleFemale.remove("MALE-$index");
                                        maleFemale.add("FEMALE-$index");
                                      }
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:  maleFemale.contains("FEMALE-$index") ? notifier.purplecolor : notifier.grey04,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5, bottom: 5,right: 10,left: 10),
                                        child: SvgPicture.asset('assets/deshboard/femaleIcon.svg',height: 30,),
                                      )
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ]
                    );
                },),
              ),
            ],
          )
      ),
    );
  }
  Widget contactDetails(constraints){
    return constraints.maxWidth < 1000 ? Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: notifier.whitecolor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10,bottom: 10,top: 20 ),
            child: Row(
              children: [
                SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                const SizedBox(width: 10,),
                Text('Contact Details'.tr,style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 10,top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name'.tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                const SizedBox(height: 5,),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: contDetailName,
                    keyboardType: TextInputType.name,
                    style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                    decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                      hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
                Text('Email Id',style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                const SizedBox(height: 5,),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: contDetailEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email Id'.tr,
                      hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
                Text('Mobile Details'.tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                const SizedBox(height: 5,),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: contDetailMobile,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Enter Your Mobile Number'.tr,
                      hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                       ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                Container(
                  decoration: BoxDecoration(
                    color: notifier.whitecolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(text: TextSpan(
                            text: 'Amount : '.tr,
                            style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: '${searchBusApi.searchBusData!.currency}${widget.total}',
                                style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14,fontWeight: FontWeight.w600),
                              ),
                            ]
                        )),
                        Text('(Exclusive of Texes)'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 10),),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          width: width / 1,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                  elevation: const MaterialStatePropertyAll(0),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                      ),
                                  ),
                              ),
                              onPressed: () {

                                submitDataAge();
                                submitDataName();
                                homeApi.homepage();


                                if(dynamicName.isNotEmpty && dynamicAge.isNotEmpty){
                                  if (widget.seatnumber.length == maleFemale.length && dataName.length == widget.seatnumber.length && dataAge.length == widget.seatnumber.length && dataAge.isNotEmpty) {
                                    if (contDetailMobile.text.isNotEmpty && contDetailEmail.text.isNotEmpty && contDetailName.text.isNotEmpty &&  maleFemale.isNotEmpty && dataName.isNotEmpty && dataAge.isNotEmpty) {

                                      walletReportApi.walletReport(context).then((value) {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return PaymentPage(commission: widget.commission,pickData: widget.pickData,dropData: widget.dropData,dataAge: dataAge,dataName: dataName,seatnumber: widget.seatnumber,index2: widget.index2,dropPlace: widget.dropplace,pickPlace: widget.pickplace,totalprice: widget.total,gender: maleFemale,contactEmail: contDetailEmail.text, contactNumber: contDetailMobile.text,contactName: contDetailName.text,detailAge: dynamicAge,detailName: dynamicName,);
                                        },));
                                      });

                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Please fill all details'.tr), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Please fill all details'.tr), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please select gender'.tr), width: 400, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  );
                                }
                              }, child: Text('Proceed'.tr,style: const TextStyle(fontFamily: 'SofiaLight',color: Colors.white,fontSize: 14),)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ) : Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: notifier.whitecolor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10,bottom: 10,top: 20 ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                  const SizedBox(width: 10,),
                  Text('Contact Details'.tr,style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10,left: 10,top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name'.tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                  const SizedBox(height: 5,),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: contDetailName,
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        hintText: 'Enter Your Name'.tr,
                        contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10),
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
                  Text('Email Id'.tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                  const SizedBox(height: 5,),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: contDetailEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email Id'.tr,
                        contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10),
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text('Contact Details'.tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                  const SizedBox(height: 5,),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: contDetailMobile,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                     
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10),
                        hintText: 'Enter Your Mobile Number'.tr,
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Container(
                    decoration: BoxDecoration(
                      color: notifier.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(
                            text: 'Amount : '.tr,
                            style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                text: ' ${searchBusApi.searchBusData!.currency}${widget.total}',
                                style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14,fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                          const SizedBox(height: 2),
                          Text('(Exclusive of Texes)'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 10),),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 40,
                            width: width / 1,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                elevation: const MaterialStatePropertyAll(0),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                                onPressed: () {

                                submitDataAge();
                                submitDataName();
                                homeApi.homepage();


                                if(dynamicName.isNotEmpty && dynamicAge.isNotEmpty){
                                  if (widget.seatnumber.length == maleFemale.length && dataName.length == widget.seatnumber.length && dataAge.length == widget.seatnumber.length && dataAge.isNotEmpty) {
                                  if (contDetailMobile.text.isNotEmpty && contDetailEmail.text.isNotEmpty && contDetailName.text.isNotEmpty &&  maleFemale.isNotEmpty && dataName.isNotEmpty && dataAge.isNotEmpty) {

                                    walletReportApi.walletReport(context).then((value) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return PaymentPage(commission: widget.commission,pickData: widget.pickData,dropData: widget.dropData,dataAge: dataAge,dataName: dataName,seatnumber: widget.seatnumber,index2: widget.index2,dropPlace: widget.dropplace,pickPlace: widget.pickplace,totalprice: widget.total,gender: maleFemale,contactEmail: contDetailEmail.text, contactNumber: contDetailMobile.text,contactName: contDetailName.text,detailAge: dynamicAge,detailName: dynamicName,);
                                      },));
                                    });

                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: notifier.blackcolor,
                                        content: Text('Please fill all details'.tr,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackwhitecolor, fontSize: 16, fontWeight: FontWeight.w600),), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                    );
                                  }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: notifier.blackcolor,
                                        content: Text('Please fill all details'.tr,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackwhitecolor, fontSize: 16, fontWeight: FontWeight.w600),), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: notifier.blackcolor,
                                      content: Text('Please select gender'.tr,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackwhitecolor, fontSize: 16, fontWeight: FontWeight.w600),), width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                  );
                                }
                            }, child: Text('Proceed'.tr,style: const TextStyle(fontFamily: 'SofiaLight',color: Colors.white,fontSize: 14),)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

ColorNotifier notifier = ColorNotifier();

class DynamicWidget extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  DynamicWidget({super.key});


  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return TextFormField(
      style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 0.1),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10),
        hintText: 'Enter Full Name'.tr,
        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
        ),
      ),
    );
  }
}

class DynamicWidget1 extends StatelessWidget {
  final TextEditingController controller1 = TextEditingController();

  DynamicWidget1({super.key});


  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return TextFormField(
      style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight'),
      controller: controller1,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,

      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '';
        }
        return null;
      },
      maxLength: 3,

      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        counterText: "",
        errorStyle: const TextStyle(fontSize: 0.1),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 10),
        hintText: 'Enter Age'.tr,
        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
        ),
      ),
    );
  }
}