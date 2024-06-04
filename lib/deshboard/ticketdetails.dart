import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/apicontroller/bookinghistory.dart';
import 'package:zigzagbus/apicontroller/cancelbookingapi.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/apicontroller/postreviewapi.dart';
import 'package:zigzagbus/apicontroller/ticketdetailsapi.dart';
import 'package:zigzagbus/deshboard/heading.dart';
import 'package:zigzagbus/helper/pdfviewer.dart';

import '../config.dart';
import '../helper/appbar.dart';
import '../helper/colornotifier.dart';
import '../helper/drawerCommon.dart';
import '../mediaquery/mq.dart';
import 'deshboard.dart';

class TicketDetails extends StatefulWidget {
  final bool isUpcoming;
  final bool isRecent;
  const TicketDetails({super.key, required this.isUpcoming, required this.isRecent});

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {

  late ColorNotifier notifier;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileNumber = ticketDetailsApi.ticketDetailsData!.tickethistory[0].subPickMobile.toString().split(',');
  }

  TextEditingController feedback = TextEditingController();
  double ratingStar = 0;
  List mobileNumber = [];
  TicketDetailsApi ticketDetailsApi = Get.put(TicketDetailsApi());
  BookingHistoryApi bookHApi = Get.put(BookingHistoryApi());
  HomeApiController homeApi = Get.put(HomeApiController());
  PostReviewApi postReviewApi = Get.put(PostReviewApi());
  CancelBookingApi cancelBookingApi = Get.put(CancelBookingApi());
  final GlobalKey<ScaffoldState> ticketKey = GlobalKey();

  TextEditingController rejectResponse = TextEditingController();

  String? imagePath;
  File? capturedFile;

  String netImage = "";

  bool transId = false;

  List reason = [
    "Financing fell through".tr,
    "Inspection issues".tr,
    "Change in financial situation".tr,
    "Title issues".tr,
    "Seller changes their mind".tr,
    "Competing offer".tr,
    "Personal reasons".tr,
    "Others".tr
  ];



  String selectedReason = "Financing fell through";
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.isDark ? notifier.backgroundColor : notifier.searchgrey,
      key: ticketKey,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: LocalappBar(gkey: ticketKey,),
      ),
      body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  HeadingPage(pageTitle: "Home".tr, nTitle: "My Ticket".tr,currentTitle: "Ticket Details".tr,),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: constraints.maxWidth < 600 ? 10 : constraints.maxWidth < 1000 ? 20 : 0,right: constraints.maxWidth < 600 ? 10 : constraints.maxWidth < 1000 ? 20 : 0 , bottom: 20),
                    child: Container(
                      // color: notifier.lightgreycolor,
                      child: constraints.maxWidth < 710 ? Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                qr(constraints),
                                const SizedBox(height: 10),
                                busDetails(constraints),
                                const SizedBox(height: 10),
                                pickDropDetails(constraints),
                                const SizedBox(height: 10),
                                transDetails(constraints),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Column(
                              children: [
                                passangerDetails(constraints),
                                const SizedBox(height: 10),
                                contactDetails(constraints),
                                const SizedBox(height: 10),
                                priceDetails(constraints),
                                const SizedBox(height: 10),
                                notes(),
                                const SizedBox(height: 10,),
                                (widget.isUpcoming)
                                    ? SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        elevation: const MaterialStatePropertyAll(0),
                                        backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                        padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context, builder: (context) {
                                          return Dialog(
                                            backgroundColor: notifier.whitecolor,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(14)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(30),
                                              child: SizedBox(
                                                width: 300,
                                                height: 220,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Download Your Ticket !".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.bold, fontSize: 24),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
                                                        const SizedBox(height: 40),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 50,
                                                          width: double.infinity,
                                                          child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                                                shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                                elevation: const MaterialStatePropertyAll(0),
                                                              ),
                                                              onPressed: () {
                                                                netImage = "${Config.imageBaseUrl}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].busImg}";
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                  return PdfViewer(currency: homeApi.homeData!.currency, tickethistory: ticketDetailsApi.ticketDetailsData,netImage: netImage,);
                                                                },));
                                                              }, child: Padding(
                                                            padding: const EdgeInsets.all(8),
                                                            child: Text("Download PDF".tr,style: const TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                          )),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                              return const deshscreen();
                                                            },));
                                                          },
                                                          child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },);
                                      }, child: Text("Download Ticket".tr,style: const TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: Colors.white, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis)),
                                ) : (ticketDetailsApi.ticketDetailsData!.tickethistory[0].isRate == "0" && widget.isRecent) ? SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          elevation: const MaterialStatePropertyAll(0),
                                          backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                          padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context, builder: (context) {
                                            return Dialog(
                                              backgroundColor: notifier.whitecolor,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration: BoxDecoration(
                                                                  color: const Color(0xff7D2AFF),
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          "${Config.imageBaseUrl}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].busImg}"),
                                                                      fit: BoxFit.cover))
                                                          ),
                                                          const SizedBox(height: 8,),
                                                          Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].busName,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.bold, fontSize: 16),textAlign: TextAlign.center,),
                                                          const SizedBox(height: 14),
                                                          RatingBar.builder(
                                                            initialRating: 0,
                                                            minRating: 1,
                                                            direction: Axis.horizontal,
                                                            allowHalfRating: true,
                                                            itemCount: 5,
                                                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                            itemBuilder: (context, _) => Icon(
                                                              Icons.star,
                                                              color: notifier.purplecolor,
                                                            ),
                                                            onRatingUpdate: (rating) {
                                                              setState(() {
                                                                ratingStar = rating;
                                                              });
                                                            },
                                                          ),
                                                          const SizedBox(height: 10),
                                                          TextField(
                                                            controller: feedback,
                                                            maxLines: 5,
                                                            style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                                                            decoration: InputDecoration(
                                                              hintText: "Enter your Feedback".tr,
                                                              hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                                borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                                borderSide: BorderSide(color: notifier.purplecolor,width: 1),
                                                              ),
                                                            ),
                                                          ),
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
                                                                String ticketId = ticketDetailsApi.ticketDetailsData!.tickethistory[0].ticketId;
                                                                postReviewApi.postReview(ticketId, ratingStar, feedback.text).then((value) {
                                                                  Get.to(const deshscreen());
                                                                });
                                                              }, child: Padding(
                                                            padding: const EdgeInsets.all(8),
                                                            child: Text("Give Rating".tr,style: const TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                          )),
                                                          const SizedBox(height: 10),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                return const deshscreen();
                                                              },));
                                                            },
                                                            child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },);
                                        }, child: Text("Review".tr,style: const TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: Colors.white, fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis)
                                    )))
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      )
                          : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                          Expanded(
                            flex: constraints.maxWidth < 1150 ? 4 : 3,
                            child: Column(
                              children: [
                                qr(constraints),
                                const SizedBox(height: 10),
                                busDetails(constraints),
                                const SizedBox(height: 10),
                                pickDropDetails(constraints),
                                const SizedBox(height: 10),
                                transDetails(constraints),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            flex: constraints.maxWidth < 1150 ? 4 : 2,
                            child: Column(
                              children: [
                                passangerDetails(constraints),
                                const SizedBox(height: 10),
                                contactDetails(constraints),
                                const SizedBox(height: 10),
                                ticketDetailsApi.ticketDetailsData!.tickethistory[0].driverName.isNotEmpty
                                    && ticketDetailsApi.ticketDetailsData!.tickethistory[0].driverMobile.isNotEmpty
                                    && ticketDetailsApi.ticketDetailsData!.tickethistory[0].busName.isNotEmpty ? driverDetails(constraints) : const SizedBox(),
                                const SizedBox(height: 10),
                                priceDetails(constraints),
                                const SizedBox(height: 10),
                                notes(),
                                const SizedBox(height: 10,),
                                (widget.isUpcoming)
                                    ? SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              elevation: const MaterialStatePropertyAll(0),
                                              backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                              padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context, builder: (context) {
                                                return Dialog(
                                                  backgroundColor: notifier.whitecolor,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(14)
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(30),
                                                    child: SizedBox(
                                                      width: 300,
                                                      height: 220,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text("Download Your Ticket !".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.bold, fontSize: 24),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
                                                              const SizedBox(height: 40),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 50,
                                                                width: double.infinity,
                                                                child: ElevatedButton(
                                                                    style: ButtonStyle(
                                                                      backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                                      elevation: const MaterialStatePropertyAll(0),
                                                                    ),
                                                                    onPressed: () {
                                                                      netImage = "${Config.imageBaseUrl}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].busImg}";
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                        return PdfViewer(currency: homeApi.homeData!.currency, tickethistory: ticketDetailsApi.ticketDetailsData,netImage: netImage,);
                                                                      },));
                                                                    }, child: Padding(
                                                                  padding: const EdgeInsets.all(8),
                                                                  child: Text("Download PDF".tr,style: const TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                                )),
                                                              ),
                                                              const SizedBox(height: 10),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                    return const deshscreen();
                                                                  },));
                                                                },
                                                                child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },);
                                            }, child: Text("Download Ticket".tr,style: const TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: Colors.white, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis)),
                                      ),
                                      const SizedBox(width: 10,),
                                      ticketDetailsApi.ticketDetailsData!.tickethistory[0].cancleShow == 1 ? Expanded(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              elevation: const MaterialStatePropertyAll(0),
                                              backgroundColor: MaterialStatePropertyAll(notifier.whitecolor),
                                              padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                                                    side: BorderSide(color: notifier.purplecolor)
                                              )),
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context, builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Dialog(
                                                      backgroundColor: notifier.whitecolor,
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(14)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(30),
                                                        child: SizedBox(
                                                          height:  selectedReason == "Others" ? 600 : 560,
                                                          width: 500,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text("Select Reason".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.w600, fontSize: 24),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
                                                              const SizedBox(height: 20),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Please select the reason for cancellation:".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.w600, fontSize: 16),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
                                                                  const SizedBox(height: 20),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      ListView.builder(
                                                                        itemCount: reason.length,
                                                                        shrinkWrap: true,
                                                                        itemBuilder: (context, index) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets.only(bottom: 10),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                 child: RadioListTile(
                                                                                   dense: true,
                                                                                   value: reason[index],
                                                                                   fillColor: MaterialStatePropertyAll(notifier.purplecolor),
                                                                                   activeColor: notifier.purplecolor,
                                                                                   // tileColor: notifier.theamcolorelight,
                                                                                   selected: true,
                                                                                   groupValue: selectedReason,
                                                                                   title:  Text(reason[index],
                                                                                     style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16),overflow: TextOverflow.ellipsis,),
                                                                                   onChanged: (value) {
                                                                                     setState(() {});
                                                                                     selectedReason = value as String;
                                                                                     // rejectmsg = cancelList[i]["title"];
                                                                                   },
                                                                                 ),
                                                                               ),
                                                                              const SizedBox(width: 10),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },),
                                                                      selectedReason == "Others" ? Padding(
                                                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                                                        child: SizedBox(
                                                                          height: 40,
                                                                          child: TextField(
                                                                            controller: rejectResponse,
                                                                            style: TextStyle(color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),
                                                                            decoration: InputDecoration(
                                                                              hintText: "Enter reason",
                                                                              hintStyle: TextStyle(color: notifier.subgreycolor, fontSize: 14, fontFamily: "SofiaLight"),
                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: notifier.greycolor)),
                                                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: notifier.greycolor)),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ) : const SizedBox(),
                                                                    ],
                                                                  ),

                                                                ],
                                                              ),
                                                              const SizedBox(height: 20),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        width: double.infinity,
                                                                        child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                              backgroundColor: MaterialStatePropertyAll(Colors.red.withOpacity(0.6)),
                                                                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                                              elevation: const MaterialStatePropertyAll(0),
                                                                            ),
                                                                            onPressed: () {
                                                                              Get.back();
                                                                            }, child: Padding(
                                                                          padding: const EdgeInsets.all(8),
                                                                          child: Text("Cancel".tr,style: const TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                                        )),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                                                      child: SizedBox(
                                                                        height: 40,
                                                                        child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                              backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                                                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                                              elevation: const MaterialStatePropertyAll(0),
                                                                            ),
                                                                            onPressed: () {
                                                                              if(selectedReason == "Others".tr){
                                                                                setState(() {
                                                                                  selectedReason = rejectResponse.text;
                                                                                });
                                                                              }
                                                                              cancelBookingApi.cancelBooking(ticketDetailsApi.ticketDetailsData!.tickethistory[0].subtotal, selectedReason).then((value) {
                                                                               if(cancelBookingApi.loading == false) {
                                                                                  if(value["Result"] == "false"){
                                                                                      Get.to(const deshscreen());
                                                                                   } else {
                                                                                      Fluttertoast.showToast(
                                                                                      toastLength: Toast.LENGTH_LONG,
                                                                                      webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                                                                                      msg: "Something Went Wrong!".tr,
                                                                                      textColor: notifier.blackwhitecolor,
                                                                                    );
                                                                                  }
                                                                                } else {
                                                                                 Fluttertoast.showToast(
                                                                                   toastLength: Toast.LENGTH_LONG,
                                                                                   webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                                                                                   msg: "Something Went Wrong!".tr,
                                                                                   textColor: notifier.blackwhitecolor,
                                                                                 );
                                                                               }
                                                                              });
                                                                            }, child: Padding(
                                                                          padding: const EdgeInsets.all(8),
                                                                          child: Text("Confirm".tr,style: const TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                                        )),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                );
                                              },);
                                            }, child: Text("Cancel Booking".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.purplecolor, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis),
                                        ),
                                      ) : const SizedBox(),
                                    ],
                                  ),
                                ) : (ticketDetailsApi.ticketDetailsData!.tickethistory[0].isRate == "0" && widget.isRecent) ? SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          elevation: const MaterialStatePropertyAll(0),
                                          backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                                          padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context, builder: (context) {
                                            return Dialog(
                                              backgroundColor: notifier.whitecolor,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration: BoxDecoration(
                                                                  color: const Color(0xff7D2AFF),
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          "${Config.imageBaseUrl}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].busImg}"),
                                                                      fit: BoxFit.cover))
                                                          ),
                                                          const SizedBox(height: 8,),
                                                          Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].busName,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.bold, fontSize: 16),textAlign: TextAlign.center,),
                                                          const SizedBox(height: 14),
                                                          RatingBar.builder(
                                                            initialRating: 0,
                                                            minRating: 1,
                                                            direction: Axis.horizontal,
                                                            allowHalfRating: true,
                                                            itemCount: 5,
                                                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                            itemBuilder: (context, _) => Icon(
                                                              Icons.star,
                                                              color: notifier.purplecolor,
                                                            ),
                                                            onRatingUpdate: (rating) {
                                                              setState(() {
                                                                ratingStar = rating;
                                                              });
                                                            },
                                                          ),
                                                          const SizedBox(height: 10),
                                                          TextField(
                                                            controller: feedback,
                                                            maxLines: 5,
                                                            style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                                                            decoration: InputDecoration(
                                                              hintText: "Enter your Feedback".tr,
                                                              hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                                borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                                borderSide: BorderSide(color: notifier.purplecolor,width: 1),
                                                              ),
                                                            ),
                                                          ),
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
                                                                String ticketId = ticketDetailsApi.ticketDetailsData!.tickethistory[0].ticketId;
                                                                postReviewApi.postReview(ticketId, ratingStar, feedback.text).then((value) {
                                                                  Get.to(const deshscreen());
                                                                });
                                                              }, child: Padding(
                                                            padding: const EdgeInsets.all(8),
                                                            child: Text("Give Rating".tr,style: const TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                          )),
                                                          const SizedBox(height: 10),
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                return const deshscreen();
                                                              },));
                                                            },
                                                            child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),overflow: TextOverflow.ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },);
                                        }, child: Text("Review".tr,style: const TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: Colors.white, fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis)
                                    )))
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
  Widget qr(constraints){
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                  const SizedBox(width: 10,),
                  Text('Qr Code'.tr,style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor)),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 10, left: rtl ? 10 : 0),
                child: Row(
                  children: [
                    Text("Ticket ID: ${ticketDetailsApi.ticketDetailsData!.tickethistory[0].ticketId}",style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'SofiaLight',fontSize: 16,color: notifier.blackcolor))
                  ],
                ),
              ),
            ],
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.network(ticketDetailsApi.ticketDetailsData!.tickethistory[0].qrcode,height: 100,),
              )),
        ],
      ),
    );
  }
 Widget busDetails(constraints){
    return Container(
      decoration: BoxDecoration(
          color: notifier.whitecolor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: rtl ? 0 : 10, top: 10, left: rtl ? 10 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                    const SizedBox(width: 10,),
                    Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: const Color(0xff7D2AFF),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "${Config.imageBaseUrl}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].busImg}"),
                                fit: BoxFit.cover))
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].busName,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 16,fontWeight: FontWeight.bold,color: notifier.blackcolor,letterSpacing: 1
                          ),
                        ),
                        Row(
                          children: [
                            ticketDetailsApi.ticketDetailsData!.tickethistory[0].isAc ==
                                "0"
                                ? Text(
                                'Non AC'.tr,
                                style: TextStyle(
                                    fontFamily: 'SofiaLight',
                                    fontSize: 12,
                                    color: notifier.blackcolor))
                                : Text(
                                'AC'.tr,
                                style: TextStyle(
                                    fontFamily: 'SofiaLight',
                                    fontSize: 12,
                                    color: notifier.blackcolor)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Text('${homeApi.homeData!.currency} ${ticketDetailsApi.ticketDetailsData!.tickethistory[0].subtotal}',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 16,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                      const SizedBox(height: 8,),
                      Text(convertTimeTo12HourFormat(ticketDetailsApi.ticketDetailsData!.tickethistory[0].busPicktime),style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.purplecolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Column(
                  children: [
                    Image.asset('assets/Icons/busHorizontalIcon.png',height: 60,width: 100,color: notifier.purplecolor),
                    Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].differencePickDrop,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor)),
                  ],
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].dropCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                      const SizedBox(height: 8,),
                      Text(convertTimeTo12HourFormat(ticketDetailsApi.ticketDetailsData!.tickethistory[0].busDroptime),style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
 }

  Widget pickDropDetails(constraints){
    return Container(
      decoration: BoxDecoration(
          color: notifier.whitecolor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].subPickPlace,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                  Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                  const SizedBox(height: 8,),
                  Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].subPickMobile.toString().split(',').first,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.purplecolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                  SizedBox(height: ticketDetailsApi.ticketDetailsData!.tickethistory[0].subPickMobile.isEmpty ? 0 : 8,),
                  Text(convertTimeTo12HourFormat(ticketDetailsApi.ticketDetailsData!.tickethistory[0].busPicktime),style: TextStyle(fontSize: 12,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                ],
              ),
            ),
            SvgPicture.asset('assets/deshboard/detailsScreen.svg',height: 100,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].subDropPlace, style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                  Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].dropCity, style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                  const SizedBox(height: 8,),
                  SizedBox(height: ticketDetailsApi.ticketDetailsData!.tickethistory[0].subPickMobile.isEmpty ? 0 : 8,),
                  Text(convertTimeTo12HourFormat(ticketDetailsApi.ticketDetailsData!.tickethistory[0].subDropTime),style: TextStyle(fontSize: 12,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
 }

 Widget transDetails(constraints){
    return Container(
      decoration: BoxDecoration(
          color: notifier.whitecolor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                const SizedBox(width: 10,),
                Text("Transaction Details".tr, style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 16,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Booking Date".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                    const SizedBox(height: 8,),
                    Text("Payment Method".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                    const SizedBox(height: 8,),
                    Text("Transaction Id".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                    const SizedBox(height: 8,),
                    Text("Ticket Id".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                  ],
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].bookDate.toString().split(' ').first, style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                      const SizedBox(height: 8,),
                      Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].pMethodName, style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                      const SizedBox(height: 8,),
                      Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].transactionId,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                      const SizedBox(height: 8,),
                      Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].ticketId,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
 }

 Widget passangerDetails(constraints){
    return Container(
      decoration: BoxDecoration(
          color: notifier.whitecolor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                const SizedBox(width: 10,),
                Text("Passanger(S)".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600)),
              ],
            ),
          ),
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
                    Text('Name'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),
                    Center(child: Text('Age'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),),
                    Center(child: Text('Seat'.tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),),
                  ],
                ),
                for( int a = 0; a < ticketDetailsApi.ticketDetailsData!.tickethistory[0].orderProductData.length; a++) TableRow(
                    children: <Widget>[
                      Text('${ticketDetailsApi.ticketDetailsData!.tickethistory[0].orderProductData[a].name}(${ticketDetailsApi.ticketDetailsData!.tickethistory[0].orderProductData[a].gender})',style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),),
                      Center(child: Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].orderProductData[a].age,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),)),
                      Center(child: Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].orderProductData[a].seatNo,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),)),
                    ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
 }
 Widget contactDetails(constraints){
    return Container(
      decoration: BoxDecoration(
          color: notifier.whitecolor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                const SizedBox(width: 10,),
                Text("Contact Details".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Full Name".tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                    const SizedBox(height: 8,),
                    Text("Email".tr,style: TextStyle(fontFamily: 'SofiaLight', fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                    const SizedBox(height: 8,),
                    Text("Phone Number".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                   ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].contactName, style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                    const SizedBox(height: 8,),
                    Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].contactEmail, style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                    const SizedBox(height: 8,),
                    Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].contactMobile,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
 }
 Widget driverDetails(constraints){
   return Container(
     decoration: BoxDecoration(
         color: notifier.whitecolor,
         borderRadius: BorderRadius.circular(20)
     ),
     child: Column(
       children: [
         Padding(
           padding: const EdgeInsets.only(top: 10),
           child: Row(
             children: [
               SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
               const SizedBox(width: 10,),
               Text("Driver Details".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),
             ],
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(10),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Text("Full Name".tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                   const SizedBox(height: 8,),
                   Text("Phone Number".tr,style: TextStyle(fontFamily: 'SofiaLight', fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                   const SizedBox(height: 8,),
                   Text("Bus Number".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                 ],
               ),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].driverName, style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                   const SizedBox(height: 8,),
                   Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].driverMobile, style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                   const SizedBox(height: 8,),
                   Text(ticketDetailsApi.ticketDetailsData!.tickethistory[0].busNo,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                 ],
               ),
             ],
           ),
         ),
       ],
     ),
   );
 }
 Widget priceDetails(constraints){
    return Container(
      decoration: BoxDecoration(
          color: notifier.whitecolor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SvgPicture.asset('assets/deshboard/titleImage.svg',height: 30,),
                const SizedBox(width: 10,),
                Text("Price Details".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Price".tr,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                        const SizedBox(height: 8,),
                        RichText(text: TextSpan(
                          text: "Tax".tr,
                          style: TextStyle(fontFamily: 'SofiaLight', fontSize: 14,color: notifier.blackcolor),
                          children: [
                            TextSpan(
                              text: "(${ticketDetailsApi.ticketDetailsData!.tickethistory[0].tax}%)",
                                style: TextStyle(fontFamily: 'SofiaLight', fontSize: 14,color: notifier.blackcolor)
                            )
                          ]
                        ),),
                        const SizedBox(height: 8,),
                        Text("Discount".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                        const SizedBox(height: 8,),
                        Text("Wallet".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${homeApi.homeData!.currency}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].total}", style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                        const SizedBox(height: 8,),
                        Text("${homeApi.homeData!.currency}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].taxAmt}", style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 14,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                        const SizedBox(height: 8,),
                        Text("${homeApi.homeData!.currency}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].couAmt}",style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.lightgreencolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                        const SizedBox(height: 8,),
                        Text("${homeApi.homeData!.currency}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].wallAmt}",style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.lightgreencolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,maxLines: 1),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Divider(color: notifier.subgreycolor),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Price".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                    Text("${homeApi.homeData!.currency}${ticketDetailsApi.ticketDetailsData!.tickethistory[0].subtotal}",style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
 }
 Widget notes(){
    return Container(
      decoration: BoxDecoration(
          color: notifier.lightPurplecolor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text("The driver's mobile number, name, and bus number will be presented one hour prior to your scheduled bus departure time.".tr,style: TextStyle(fontSize: 14,fontFamily: 'SofiaLight',color: notifier.blackcolor,)),
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
