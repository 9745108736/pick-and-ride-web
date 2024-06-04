// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigzagbus/apicontroller/coupenlistapi.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/apicontroller/searchbuscontroller.dart';
import 'package:zigzagbus/apicontroller/ticketdetailsapi.dart';
import 'package:zigzagbus/apicontroller/walletreportapi.dart';
import 'package:zigzagbus/deshboard/deshboard.dart';
import 'package:zigzagbus/deshboard/endofpage.dart';
import 'package:zigzagbus/helper/helperwidget/paymentplatforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../apicontroller/bookinghistory.dart';
import '../apicontroller/bookticketapi.dart';
import '../apicontroller/paygetvayapi.dart';
import '../config.dart';
import '../deshboard/heading.dart';
import '../deshboard/myticket.dart';
import '../mediaquery/mq.dart';
import '../models/bookinghmodel.dart';
import '../razorpaymodel.dart';
import 'appbar.dart';
import 'colornotifier.dart';
import 'drawerCommon.dart';

class PaymentPage extends StatefulWidget {
  final String contactEmail;
  final String contactNumber;
  final String contactName;
  final List detailName;
  final List detailAge;
  final List gender;
  final double totalprice;
  final String dropPlace;
  final String pickPlace;
  final int index2;
  final List seatnumber;
  final List dataName;
  final List dataAge;
  final Map pickData;
  final Map dropData;
  final String commission;
  const PaymentPage({super.key, required this.contactEmail, required this.contactNumber, required this.contactName, required this.detailName, required this.detailAge, required this.gender, required this.totalprice, required this.dropPlace, required this.pickPlace, required this.index2, required this.seatnumber, required this.dataName, required this.dataAge, required this.pickData, required this.dropData, required this.commission});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late ColorNotifier notifier;


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    razorPayClass.initiateRazorPay(
        handlePaymentSuccess: handlePaymentSuccess,
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet);
    walletReportApi.walletReport(context);
    couponlistApi.couponList(context, widget.index2);
    gethome();
    fun12();
    payGetwayApi.payGetway(context);
  }

  CouponlistApi couponlistApi = Get.put(CouponlistApi());

  double taxnumber = 0;
  double tax = 0;
  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  HomeApiController homeApi = Get.put(HomeApiController());
  PayGetwayApi payGetwayApi = Get.put(PayGetwayApi());
  BookTicketApi bookTicketApi = Get.put(BookTicketApi());
  WalletReportApi walletReportApi = Get.put(WalletReportApi());
  BookingHistoryApi bookingHApi = Get.put(BookingHistoryApi());
  TicketDetailsApi ticketDetailsApi = Get.put(TicketDetailsApi());
  LoginApiController logInApi = Get.put(LoginApiController());

  bool loading = true;
  bool couponApply = false;
  List isReademore = [];
  bool walletSwitch = false;
  final GlobalKey<ScaffoldState> paymentDroverKey = GlobalKey();

  List passengerData = [];

  bool couponApplied = false;

  double couponVal = 0;
  int paymethod = 0;
  // double walletAmt = 0;
  // double walletMain = 0;

  double actualWalletAmt = 0;
  
  fun12(){
    setState(() {
      for(int a=0; a<widget.detailName.length; a++){
        passengerData.add({
          "name"    : "${widget.dataName[a]}",
          "age"     : "${widget.dataAge[a]}",
          "seat_no" : "${widget.seatnumber[a]}",
          "gender"  : widget.gender[a].toString().split("-").first
        });
      }
    });

  }

  var gethomeData;
  gethome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      gethomeData = json.decode(prefs.getString("homedata")!);

      setState(() {
        taxnumber = double.parse(gethomeData["tax"]);
        math();
      });
    });
  }

  // double totalPrice = 0;


  double walletMain = 0;
  double totalPayment = 0;
  double walletValue = 0;


  math(){
    setState(() {
      tax = taxnumber / 100 * widget.totalprice;
      totalPayment = tax + widget.totalprice;


    });
  }
  // WalletReportApi walletReportApi = Get.put(WalletReportApi());
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: paymentDroverKey,
      endDrawer: LayoutBuilder(builder: (context, constraints) {
        return constraints.maxWidth < 600 ? const CommonDrawer() : PaymentPlatform(mainAmt: totalPayment,walletAmt: walletValue.toString(),commision: widget.commission,taxAmt: tax.toString(),passengerData: passengerData,couponAmt: couponVal.toString(),pickData: widget.pickData,dropData: widget.dropData,amount: widget.totalprice,dataAge: widget.dataAge,dataName: widget.dataName,seatnumber: widget.seatnumber,index2: widget.index2,dropPlace: widget.dropPlace,pickPlace: widget.pickPlace,contactEmail: widget.contactEmail,contactName: widget.contactName, contactNumber: widget.contactNumber, detailAge: widget.dataAge, detailName: widget.detailName, gender: widget.gender,);
      },),
      backgroundColor: notifier.lightgreycolor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: LocalappBar(gkey: paymentDroverKey,),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(child: constraints.maxHeight < 1195 ? paymentDetails(constraints) : SizedBox(height: Get.height,child: paymentDetails(constraints)));
      },),
    );
  }
  Widget paymentDetails(constraints){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            HeadingPage(pageTitle: "Search Bus".tr, nTitle: "Fill Details".tr, currentTitle: "Payment & Other Details".tr,),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(
                  right: constraints.maxWidth < 600 ? 10 : constraints.maxWidth < 1000 ? 20 : 0,
                left: constraints.maxWidth < 600 ? 10 : constraints.maxWidth < 1000 ? 20 : 0,
              ),
              child: constraints.maxWidth < 750 ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: notifier.whitecolor,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
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
                                                  fit: BoxFit.cover))
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(searchBusApi.searchBusData!.busData[widget.index2].busTitle,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 18,fontWeight: FontWeight.bold,color: notifier.blackcolor,letterSpacing: 1
                                          ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              searchBusApi
                                                  .searchBusData!
                                                  .busData[widget.index2]
                                                  .busAc ==
                                                  "0"
                                                  ? RichText(text: TextSpan(
                                                  text: "Non AC".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'SofiaLight',
                                                      fontSize: 14,
                                                      color: notifier.blackcolor),
                                                  children: [
                                                    TextSpan(
                                                        text: '/ ${searchBusApi.searchBusData!.busData[widget.index2].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                            'SofiaLight',
                                                            fontSize: 14,
                                                            color: notifier.blackcolor)
                                                    )
                                                  ]
                                              ))
                                                  : RichText(text: TextSpan(
                                                  text: "AC".tr,
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'SofiaLight',
                                                      fontSize: 14,
                                                      color: notifier.blackcolor),
                                                  children: [
                                                    TextSpan(
                                                        text: '/ ${searchBusApi.searchBusData!.busData[widget.index2].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                            'SofiaLight',
                                                            fontSize: 14,
                                                            color: notifier.blackcolor)
                                                    )
                                                  ]
                                              )),
                                              const SizedBox(width: 6),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: notifier.xlightPurplecolor,
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
                                  Text('${searchBusApi.searchBusData!.currency} ${widget.totalprice.toStringAsFixed(2)}',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 18,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(searchBusApi.searchBusData!.busData[widget.index2].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                      const SizedBox(height: 8,),
                                      Text(convertTimeTo12HourFormat(searchBusApi.searchBusData!.busData[widget.index2].busPicktime),style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.purplecolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                                      const SizedBox(height: 8,),
                                      Text(searchBusApi.selectedDateAndTime.toString().split(' ').first,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                    ],
                                  ),
                                  const SizedBox(width: 10,),
                                  Column(
                                    children: [
                                      Image.asset('assets/Icons/busHorizontalIcon.png',height: 60,width: 100,color: notifier.purplecolor),
                                      Text(searchBusApi.searchBusData!.busData[widget.index2].differencePickDrop,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(searchBusApi.searchBusData!.busData[widget.index2].dropCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                      const SizedBox(height: 8,),
                                      Text(convertTimeTo12HourFormat(searchBusApi.searchBusData!.busData[widget.index2].busDroptime),style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                      const SizedBox(height: 8,),
                                      Text(searchBusApi.selectedDateAndTime.toString().split(' ').first,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  contactDetails(constraints),
                  const SizedBox(height: 10,),
                  passangerDetails(constraints),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: () {
                      if(couponApply == false){
                        if (couponlistApi.couponListData!.result == "false") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No Coupon Available!'.tr),width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),));
                        } else {
                          setState(() {
                            couponApply = true;
                            if(walletSwitch == true){
                              walletSwitch = false;
                              if(couponApplied == true){
                                totalPayment = tax + widget.totalprice - couponVal;
                              } else {
                                totalPayment = tax + widget.totalprice;
                              }
                            }
                          });
                        }
                      }else{
                        setState(() {
                          couponApply = false;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: notifier.whitecolor,
                          borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10,top: 14,bottom: 14),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                                    const SizedBox(width: 10),
                                    SvgPicture.asset('assets/Icons/offerIcon.svg',height: 20),
                                    const SizedBox(width: 10),
                                    Text('Apply Coupon',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontWeight: FontWeight.w600,fontSize: 16)),
                                  ],
                                ),
                                Icon(Icons.keyboard_arrow_right_rounded,size: 20,color: notifier.purplecolor,),
                              ],
                            ),
                            couponApply ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: couponlistApi.couponListData!.result == "false" ? const SizedBox() : aaplyCoupon(constraints),
                            ) : const SizedBox(),
                            couponApplied ? Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Coupon Applied!",style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontWeight: FontWeight.w600,fontSize: 16)),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          walletSwitch = false;
                                          walletMain -= couponVal;
                                          couponApplied = false;
                                          couponApply = false;
                                          totalPayment = widget.totalprice + tax;
                                        });
                                      },
                                      child: const Text("Remove",style: TextStyle(fontFamily: 'SofiaLight',color: Colors.red,fontWeight: FontWeight.w600,fontSize: 16))),
                                ],
                              ),
                            ) : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  walletDetails(constraints),
                  const SizedBox(height: 10),
                  priceDetails(constraints),
                  const SizedBox(height: 10),
                  payDetails(constraints),
                ],
              ) : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                  Expanded(
                    flex: constraints.maxWidth < 1200 ? 4 : 3,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: notifier.whitecolor,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
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
                                                    fit: BoxFit.cover))
                                        ),
                                        const SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(searchBusApi.searchBusData!.busData[widget.index2].busTitle,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 18,fontWeight: FontWeight.bold,color: notifier.blackcolor,letterSpacing: 1
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                searchBusApi
                                                    .searchBusData!
                                                    .busData[widget.index2]
                                                    .busAc ==
                                                    "0"
                                                    ? RichText(text: TextSpan(
                                                    text: "Non AC".tr,
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'SofiaLight',
                                                        fontSize: 14,
                                                        color: notifier.blackcolor),
                                                    children: [
                                                      TextSpan(
                                                          text: '/ ${searchBusApi.searchBusData!.busData[widget.index2].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'SofiaLight',
                                                              fontSize: 14,
                                                              color: notifier.blackcolor)
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
                                                          text: '/ ${searchBusApi.searchBusData!.busData[widget.index2].isSleeper == "1" ? 'Sleeper'.tr : "Seater".tr}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                              'SofiaLight',
                                                              fontSize: 14,
                                                              color: notifier.blackcolor)
                                                      )
                                                    ]
                                                )),
                                                const SizedBox(width: 6),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: notifier.xlightPurplecolor,
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
                                    Text('${searchBusApi.searchBusData!.currency} ${widget.totalprice.toStringAsFixed(2)}',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 18,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(searchBusApi.searchBusData!.busData[widget.index2].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                        const SizedBox(height: 8,),
                                        Text(convertTimeTo12HourFormat(searchBusApi.searchBusData!.busData[widget.index2].busPicktime),style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.purplecolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                                        const SizedBox(height: 8,),
                                        Text(searchBusApi.selectedDateAndTime.toString().split(' ').first,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                      ],
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      children: [
                                        Image.asset('assets/Icons/busHorizontalIcon.png',height: 60,width: 100,color: notifier.purplecolor),
                                        Text(searchBusApi.searchBusData!.busData[widget.index2].differencePickDrop,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(searchBusApi.searchBusData!.busData[widget.index2].dropCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                        const SizedBox(height: 8,),
                                        Text(convertTimeTo12HourFormat(searchBusApi.searchBusData!.busData[widget.index2].busDroptime),style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                        const SizedBox(height: 8,),
                                        Text(searchBusApi.selectedDateAndTime.toString().split(' ').first,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        contactDetails(constraints),
                        const SizedBox(height: 10,),
                        passangerDetails(constraints),
                      ],
                    ),
                  ),
                 const SizedBox(width: 10),
                 Expanded(
                   flex: constraints.maxWidth < 1200 ? 4 : 2,
                   child: Column(
                     children: [
                       Container(
                         decoration: BoxDecoration(
                           color: notifier.whitecolor,
                           borderRadius: BorderRadius.circular(18),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(right: 10,top: 14,bottom: 14),
                           child: Column(
                             children: [
                               InkWell(
                                 onTap: () {
                                   if(couponApply == false){
                                     if (couponlistApi.couponListData!.result == "false") {
                                       ScaffoldMessenger.of(context).showSnackBar(
                                           SnackBar(content: Text('No Coupon Available!'.tr),width: 400,behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),));
                                     } else {
                                       setState(() {
                                         couponApply = true;
                                         if(walletSwitch == true){
                                           walletSwitch = false;
                                           if(couponApplied == true){
                                             totalPayment = tax + widget.totalprice - couponVal;
                                           } else {
                                             totalPayment = tax + widget.totalprice;
                                           }
                                         }
                                       });
                                     }
                                   }else{
                                     setState(() {
                                       couponApply = false;
                                     });
                                   }
                                 },
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(
                                       children: [
                                         SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                                         const SizedBox(width: 10),
                                         SvgPicture.asset('assets/Icons/offerIcon.svg',height: 20),
                                         const SizedBox(width: 10),
                                         Text('Apply Coupon'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontWeight: FontWeight.w600,fontSize: 16)),
                                       ],
                                     ),
                                     Icon(Icons.keyboard_arrow_right_rounded,size: 20,color: notifier.purplecolor,)
                                   ],
                                 ),
                               ),
                               couponApply ? Padding(
                                 padding: const EdgeInsets.all(10),
                                 child: aaplyCoupon(constraints),
                               ) : const SizedBox(),
                               couponApplied ? Padding(
                                 padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text("Coupon Applied!".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontWeight: FontWeight.w600,fontSize: 16)),
                                     InkWell(
                                       onTap: () {
                                         setState(() {
                                           walletSwitch = false;
                                           walletMain -= couponVal;
                                           couponApplied = false;
                                           totalPayment = widget.totalprice + tax;
                                         });
                                       },
                                     child: Text("Remove".tr,style: const TextStyle(fontFamily: 'SofiaLight',color: Colors.red,fontWeight: FontWeight.w600,fontSize: 16))),
                                   ],
                                 ),
                               ) : const SizedBox(),
                             ],
                           ),
                         ),
                       ),
                       const SizedBox(height: 10),
                       walletReportApi.walletreportData!.wallet == "0" ? const SizedBox() : walletDetails(constraints),
                       const SizedBox(height: 10),
                       priceDetails(constraints),
                       const SizedBox(height: 10),
                       payDetails(constraints),
                     ],
                   ),
                 ),
                 constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 50,),
          ],
        ),
        constraints.maxHeight < 1195 ? const SizedBox() : const Spacer(),
        Container(
          color: notifier.whitecolor,
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: endofpage(),
            )),
      ],
    );
  }
  Widget contactDetails(constraints){
    return Container(
      decoration: BoxDecoration(
        color: notifier.whitecolor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          Row(
            children: [
              SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
              const SizedBox(width: 10,),
              Text('Contact Details'.tr,style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor)),
            ],
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Full Name'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),),
                    Text(widget.contactName,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),),
                    Text(widget.contactEmail,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Phone Number'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),),
                    Text(widget.contactNumber,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget passangerDetails(constraints){
       return Container(
         decoration: BoxDecoration(
           color: notifier.whitecolor,
           borderRadius: BorderRadius.circular(20),
         ),
         child: Column(
           children: [
             const SizedBox(height: 10,),
             Row(
               children: [
                 SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                 const SizedBox(width: 10,),
                 Text('Passanger(S)'.tr,style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor,)),
               ],
             ),
             const SizedBox(height: 10,),
             Padding(
                 padding: const EdgeInsets.all(10),
                 child: Table(
                   columnWidths: <int, TableColumnWidth>{
                     0: FixedColumnWidth(constraints.maxWidth < 400 ? constraints.maxWidth / 2 : constraints.maxWidth < 710 ? constraints.maxWidth / 1.5 : constraints.maxWidth / 5),
                     // 1: FixedColumnWidth(40),
                     // 2: FixedColumnWidth(40),
                     // 3: FixedColumnWidth(40),
                   },
                   children: <TableRow>[
                     TableRow(
                       children: <Widget>[
                         Text('Name'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),),
                         Center(child: Text('Age'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),),),
                         Center(child: Text('Seat'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),),),
                       ],
                     ),
                     for( int a = 0; a < widget.dataName.length; a++) TableRow(
                         children: <Widget>[
                           Text('${widget.dataName[a]}(${widget.gender[a].toString().split("-").first})',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),),
                           Center(child: Text("${widget.dataAge[a]}",style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),)),
                           Center(child: Text(widget.seatnumber[a],style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),)),
                         ]
                     ),
                   ],
                 ),
               ),
           ],
         ),
       );
  }
  Widget walletDetails(constraints){
    return Container(
      decoration: BoxDecoration(
        color: notifier.whitecolor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10,bottom: 10,top: 12),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                        const SizedBox(width: 10),
                        SvgPicture.asset('assets/Icons/blackWalletIcon.svg',height: 18, colorFilter:  ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn)),
                        const SizedBox(width: 10),
                        Text('Pay from Wallet'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontWeight: FontWeight.w600,fontSize: 16),overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    FlutterSwitch(
                      height: 22.0,
                      width: constraints.maxWidth < 300 ? 40.0 : 35.0,
                      padding: 1.0,
                      toggleSize: 18.0,
                      borderRadius: 15.0,
                      inactiveToggleColor: notifier.whitecolor,
                      activeColor: notifier.purplecolor,
                      inactiveColor: notifier.sugestionbutton,
                      value: walletSwitch,
                      onToggle: (bool value) {
                        setState(() {
                          walletSwitch = value;
                          walletMain = double.parse(walletReportApi.walletreportData!.wallet);

                          if(walletSwitch) {
                            if (totalPayment > walletMain) {
                              walletValue = walletMain;
                              totalPayment -= walletValue;
                              walletMain = 0;
                            } else {
                              walletValue = totalPayment;
                              totalPayment -= totalPayment;

                              double good = double.parse(walletReportApi.walletreportData!.wallet);
                              walletMain = (good - walletValue);
                            }
                          }else{
                            couponApplied = false;
                            // isOnlyWallet = false;
                            walletValue = 0;
                            walletMain = double.parse(walletReportApi.walletreportData!.wallet);
                            totalPayment = tax + widget.totalprice;

                          }

                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GetBuilder<WalletReportApi>(builder: (walletReportApi) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 16,),
                          SvgPicture.asset('assets/Icons/blueWalletIcon.svg',height: 20),
                          const SizedBox(width: 10),
                          Text('My Wallet'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontWeight: FontWeight.w600,fontSize: 16)),
                        ],
                      ),
                      walletReportApi.walletreportData == null ? const CircularProgressIndicator() :
                      walletSwitch ? (Text('${searchBusApi.searchBusData!.currency}${walletMain.toStringAsFixed(2)}',style: TextStyle(fontSize: 16,color: notifier.purplecolor,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,)) )
                      : Text('${searchBusApi.searchBusData!.currency}${double.parse(walletReportApi.walletreportData!.wallet).toStringAsFixed(2)}',style: TextStyle(fontSize: 16,color: notifier.purplecolor,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,)),
                    ],
                  );
                },)
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget priceDetails(constraints){
    return Container(
      decoration: BoxDecoration(
        color: notifier.whitecolor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
              const SizedBox(width: 10),
              Text('Price Details'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontWeight: FontWeight.w600,fontSize: 16)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),),
                    Text('${searchBusApi.searchBusData!.currency} ${widget.totalprice.toStringAsFixed(2)}',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 12,fontWeight: FontWeight.w600),),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(text: TextSpan(
                        text: "Tax".tr,
                      style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),
                        children: [
                          TextSpan(
                              text: "($taxnumber%)",
                            style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),
                          )
                        ]
                    )),
                    Text('${searchBusApi.searchBusData!.currency}${(tax).toStringAsFixed(2)}',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 12,fontWeight: FontWeight.w600),),
                  ],
                ),
                SizedBox(height:  walletSwitch ? 10 : 0),
                walletSwitch ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Wallet'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),),
                    Text('${searchBusApi.searchBusData!.currency}${walletValue.toStringAsFixed(2)}',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 12,fontWeight: FontWeight.w600),),
                  ],
                ) : const SizedBox(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),),
                    couponApplied ? Text('${searchBusApi.searchBusData!.currency}${couponVal.toStringAsFixed(2)}',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.lightgreencolor,fontSize: 12,fontWeight: FontWeight.w600),)
                    : Text('${searchBusApi.searchBusData!.currency}0.00',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.lightgreencolor,fontSize: 12,fontWeight: FontWeight.w600),),
                  ],
                ),
                Divider(color: notifier.sugestionbutton,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Price'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,),),
                    Text('${searchBusApi.searchBusData!.currency}${(totalPayment).toStringAsFixed(2)}',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 12,fontWeight: FontWeight.w600),),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget payDetails(constraints){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: notifier.whitecolor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: "Total Payment".tr,
                    style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 16),
                    children: [
                      TextSpan(
                        text: ":-",
                          style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 16),
                      )
                    ]
                  ),
                ),
                const SizedBox(width: 5,),
                Text('${searchBusApi.searchBusData!.currency}${(totalPayment).toStringAsFixed(2)}',style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.blackcolor,fontSize: 16),),
              ],
            ),
            GetBuilder<BookTicketApi>(
              builder: (bookTicketApi) {
                return ElevatedButton(
                  style: ButtonStyle(
                    elevation: const MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                    onPressed: () {
                      double mainAmt = totalPayment + walletValue;
                      String payMethodId = "5";
                      String payMentId = "No Id";
                      constraints.maxWidth < 600 ? (totalPayment == 0 ?
                          bookTicketApi.bookTicket( widget.index2, walletValue.toString(), widget.pickPlace, widget.dropPlace, widget.totalprice.toString(), couponVal.toString(), payMentId, payMethodId, widget.pickData, widget.dropData, passengerData, tax.toStringAsFixed(2).toString(), widget.seatnumber, widget.commission, mainAmt.toStringAsFixed(2).toString(),widget.contactName, widget.contactNumber, widget.contactEmail).then((value) {
                            value == "true" ?
                            showDialog(
                              barrierDismissible: false,
                              context: context, builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: SizedBox(
                                    width: 300,
                                    height: 370,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Lottie.asset("assets/lottie/ticket-confirm.json",height: 150,width: 150),
                                            Text("Booking Confirmed!".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22),overflow: TextOverflow.ellipsis),
                                            const SizedBox(height: 14,),
                                            Text("Congratulation! your bus ticket is confirmed. For more details check the My Booking tab.".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                  elevation: const MaterialStatePropertyAll(0),
                                                ),
                                                onPressed: () {
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
                                                          homeApi.homepage().then((value) {
                                                            Get.to(const Mytickets());
                                                          });
                                                        });
                                                      });
                                                    });
                                                  });
                                                }, child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text("View Transaction".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.whitecolor,fontSize: 14)),
                                            )),
                                            const SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                homeApi.homepage().then((value) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return const deshscreen();
                                                  },));
                                                });
                                              },
                                              child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },)
                                : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(bookTicketApi.bookTicketData!.responseMsg), elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          })
                          : walletReportApi.walletReport(context).then((value) {
                               showModalBottomSheet(
                                 backgroundColor: notifier.backgroundColor,
                                 shape: const RoundedRectangleBorder(
                                     borderRadius: BorderRadius.only(
                                         topRight: Radius.circular(20),
                                         topLeft: Radius.circular(20))),
                                 context: context,
                                 builder: (context) {
                            return paymentBottom();
                          },);
                      })
                      ) : totalPayment == 0 ? (
                          bookTicketApi.bookTicket( widget.index2, walletValue.toString(), widget.pickPlace, widget.dropPlace, widget.totalprice.toString(), couponVal.toString(), payMentId, payMethodId, widget.pickData, widget.dropData, passengerData, tax.toStringAsFixed(2).toString(), widget.seatnumber, widget.commission, mainAmt.toStringAsFixed(2).toString(),widget.contactName, widget.contactNumber, widget.contactEmail).then((value) {
                            value == "true" ?
                            showDialog(
                              barrierDismissible: false,
                              context: context, builder: (context) {
                              return Dialog(
                                backgroundColor: notifier.backgroundColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(30),
                                  child: SizedBox(
                                    width: 300,
                                    height: 370,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Lottie.asset("assets/lottie/ticket-confirm.json",height: 150,width: 150),
                                            Text("Booking Confirmed!".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22)),
                                            const SizedBox(height: 14,),
                                            Text("Congratulation! your bus ticket is confirmed. For more details check the My Booking tab.".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),textAlign: TextAlign.center,),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                  elevation: const MaterialStatePropertyAll(0),
                                                ),
                                                onPressed: () {
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
                                                          homeApi.homepage().then((value) {
                                                            Get.to(const Mytickets());
                                                          });
                                                        });
                                                      });
                                                    });
                                                  });

                                                }, child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text("View Transaction".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.whitecolor,fontSize: 14)),
                                            )),
                                            const SizedBox(height: 10),
                                            InkWell(
                                              onTap: () {
                                                homeApi.homepage().then((value) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return const deshscreen();
                                                  },));
                                                });
                                              },
                                              child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },)
                                : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(bookTicketApi.bookTicketData!.responseMsg), elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }))
                          : paymentDroverKey.currentState!.openEndDrawer();
                    }, child: Text('PROCEED'.tr,style: const TextStyle(fontSize: 12,color: Colors.white,fontFamily: 'SofiaLight')));
              }
            )
          ],
        ),
      ),
    );
  }

  Widget aaplyCoupon(constraints){
    return ListView.builder(
      itemCount: couponlistApi.couponListData!.couponlist.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(Config.imageBaseUrl + couponlistApi.couponListData!.couponlist[index].couponImg,height: 50),
              const SizedBox(width: 10,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(couponlistApi.couponListData!.couponlist[index].couponTitle,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600)),
                    Text(couponlistApi.couponListData!.couponlist[index].couponSubtitle,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 12,fontWeight: FontWeight.w600)),
                    Column(
                      children: [
                         ReadMoreText(
                           couponlistApi.couponListData!.couponlist[index].cDesc,
                           trimLines: 1,
                           colorClickableText: Colors.pink,
                           trimMode: TrimMode.Line,
                           trimCollapsedText: 'Show more',
                           trimExpandedText: 'Show less',
                           style: TextStyle(fontFamily: 'SofiaLight',height: 1.2,color: notifier.blackcolor,fontSize: 10),
                           lessStyle: TextStyle(fontFamily: 'SofiaLight',height: 1.2,fontWeight: FontWeight.w600,color: notifier.blackcolor,fontSize: 10),
                           moreStyle: TextStyle(fontFamily: 'SofiaLight',height: 1.2,fontWeight: FontWeight.w600,color: notifier.blackcolor,fontSize: 10),
                         ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/Icons/clockIcon.svg',height: 14, colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn),),
                                        const SizedBox(width: 5),
                                        Text('Valid Until'.tr,style: TextStyle(fontSize: 10,fontFamily: 'SofiaLight',color: notifier.blackcolor,)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18),
                                      child: Text(couponlistApi.couponListData!.couponlist[index].expireDate.toString().split(' ').first,style: TextStyle(fontSize: 10,fontFamily: 'SofiaLight',color: notifier.blackcolor,)),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/Icons/blackWalletIcon.svg',height: 12, colorFilter:  ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn)),
                                        const SizedBox(width: 5),
                                        Text('Min Amount'.tr,style: TextStyle(fontSize: 10,fontFamily: 'SofiaLight',color: notifier.blackcolor,)),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text("${searchBusApi.searchBusData!.currency} ${couponlistApi.couponListData!.couponlist[index].minAmt}",style: TextStyle(fontSize: 10,fontFamily: 'SofiaLight',color: notifier.blackcolor,)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(double.parse(couponlistApi.couponListData!.couponlist[index].minAmt) > widget.totalprice ? notifier.lightPurplecolor : notifier.purplecolor),
                                elevation: const MaterialStatePropertyAll(0),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                                onPressed: () {
                                  if(double.parse(couponlistApi.couponListData!.couponlist[index].minAmt) > widget.totalprice) {
                                    setState(() {
                                      couponApply = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: const Text("Not Apply!"),
                                      width: 400,
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                      );
                                  } else if(couponApplied == false) {
                                  setState(() {

                                    if(walletSwitch == true){
                                      walletSwitch = false;
                                    }
                                    couponApplied = true;
                                    couponApply = false;
                                    couponVal = double.parse(couponlistApi.couponListData!.couponlist[index].couponVal);
                                    totalPayment = widget.totalprice - couponVal + tax;
                                    walletMain = couponVal - totalPayment;

                                  });
                                } else {
                                    setState(() {
                                      couponApply = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: const Text("Already Applied!"),
                                        width: 400,
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                                    );
                                  }
                            }, child: Text('Apply'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'SofiaLight',color: double.parse(couponlistApi.couponListData!.couponlist[index].minAmt) >= widget.totalprice ? (notifier.isDark ? Colors.white : notifier.blackcolor) : Colors.white,fontSize: 14)))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      );
    },);
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

  Widget paymentBottom(){
    return GetBuilder<WalletReportApi>(
      builder: (walletReportApi) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: StatefulBuilder(builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 40, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Payment Method'.tr,
                        style: TextStyle(
                            fontSize: 16,
                            color: notifier.purplecolor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SofiaLight'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: payGetwayApi.paygetwayData!.paymentdata.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10, bottom: 10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (paymethod == index) {
                                    paymethod = index;
                                  } else {
                                    paymethod = index;
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: paymethod == index
                                          ? notifier.purplecolor
                                          : notifier.sugestionbutton),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: notifier.lightgreycolor,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: notifier.sugestionbutton),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.network(
                                              Config.imageBaseUrl +
                                                  payGetwayApi.paygetwayData!
                                                      .paymentdata[index].img,
                                              height: 30),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              payGetwayApi.paygetwayData!
                                                  .paymentdata[index].title,
                                              style: TextStyle(
                                                  fontFamily: 'SofiaLight',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: notifier.blackcolor),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              payGetwayApi.paygetwayData!
                                                  .paymentdata[index].subtitle,
                                              style: TextStyle(
                                                  fontFamily: 'SofiaLight',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: notifier.blackcolor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: RadioListTile(
                                          value: index,
                                          activeColor: notifier.purplecolor,
                                          groupValue: paymethod,
                                          onChanged: (value) {
                                            setState(() {
                                              paymethod = value!;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(0),
                        backgroundColor:
                        MaterialStatePropertyAll(notifier.purplecolor),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                      onPressed: () {
                        // Get.back();

                        razorPayClass.openCheckout(
                            key: payGetwayApi
                                .paygetwayData!.paymentdata[paymethod].id,
                            amount: totalPayment.toString(),
                            number: logInApi.userData["mobile"],
                            name: logInApi.userData["name"],
                            email: logInApi.userData["email"]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Continue'.tr,
                          style: TextStyle(
                            fontFamily: 'SofiaLight',
                            fontWeight: FontWeight.w600,
                            color: notifier.whitecolor,
                            fontSize: 16,
                          ),
                        ),
                      )),
                ),
              ),
            )
          ],
        );
      }
    );
  }

  RazorPayClass razorPayClass = RazorPayClass();
  void handlePaymentSuccess(PaymentSuccessResponse response) {
    loading = false;

   double mainAmt = totalPayment + walletValue;
    String payMethodId = payGetwayApi.paygetwayData!.paymentdata[0].id;
    String orderId = response.paymentId.toString();

    bookTicketApi.bookTicket(
      // context,
        widget.index2,
        walletValue.toStringAsFixed(2).toString(),
        widget.pickPlace,
        widget.dropPlace,
        totalPayment.toStringAsFixed(2).toString(),
        couponVal.toStringAsFixed(2).toString(),
        orderId,
        payMethodId,
        widget.pickData,
        widget.dropData,
        passengerData,
        tax.toString(),
        widget.seatnumber,
        widget.commission,
        mainAmt.toStringAsFixed(2).toString(),
        widget.contactName,
        widget.contactNumber,
        widget.contactEmail
    ).then((value) {

      value == "true" ? showDialog(
        barrierDismissible: false,
        context: context, builder: (context) {
        return Dialog(
          backgroundColor: notifier.backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
          ),
          // insetPadding: EdgeInsets.all(180),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: 300,
              height: 370,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Lottie.asset("assets/lottie/ticket-confirm.json",height: 150,width: 150),
                      Text("Booking Confirmed!".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22)),
                      const SizedBox(height: 14,),
                      Text("Congratulation! your bus ticket is confirmed. For more details check the My Booking tab.".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),maxLines: 2,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            elevation: const MaterialStatePropertyAll(0),
                          ),
                          onPressed: () {
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
                                    homeApi.homepage().then((value) {
                                      Get.to(const Mytickets());
                                    });
                                  });
                                });
                              });
                            });

                          }, child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("View Transaction".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.whitecolor,fontSize: 14)),
                      )),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          homeApi.homepage().then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const deshscreen();
                            },));
                          });

                        },
                        child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },)
          : ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookTicketApi.bookTicketData!.responseMsg), elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}
