// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/apicontroller/ticketdetailsapi.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/deshboard/ticketdetails.dart';

import '../apicontroller/homeapi.dart';
import '../helper/colornotifier.dart';
import '../mediaquery/mq.dart';

class RecentBooking extends StatefulWidget {
  const RecentBooking({super.key});

  @override
  State<RecentBooking> createState() => _RecentBookingState();
}

class _RecentBookingState extends State<RecentBooking> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeApi.homepage();
  }

  late ColorNotifier notifier;

  HomeApiController homeApi = Get.put(HomeApiController());
  TicketDetailsApi ticketDetailsApi = Get.put(TicketDetailsApi());

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return homeApi.homeData!.tickethistory.isNotEmpty ? recent(constraints) : const SizedBox();
    },);
  }
  Widget recent(constraints){
    return Padding(
          padding: EdgeInsets.only(left: constraints.maxWidth < 600 ? 10 : constraints.maxWidth < 900 ? 50 : 140,right: constraints.maxWidth < 600 ? 10 : constraints.maxWidth < 900 ? 50 : 140),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Booking'.tr, style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontWeight: FontWeight.bold,fontSize: 20),),
                  const SizedBox(height: 15,),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 0);
                        },
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: homeApi.homeData!.tickethistory.length,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            onTap: () {
                              ticketDetailsApi.ticketDetails(context, homeApi.homeData!.tickethistory[index].ticketId).then((value) {
                                Get.to(const TicketDetails(isRecent: false, isUpcoming: false,));
                              });
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => Booking_Details(cancel: false,ticket_id: data1!.tickethistory[index].ticketId,isDownload: true),));
                            },
                            child: Container(
                            width: constraints.maxWidth < 600 ? MediaQuery.of(context).size.width*0.65 : constraints.maxWidth < 900 ? MediaQuery.of(context).size.width*0.4 : constraints.maxWidth < 1200 ? MediaQuery.of(context).size.width*0.3 : MediaQuery.of(context).size.width*0.2,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(

                              color: notifier.isDark ? notifier.whitecolor : notifier.containerBGColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff7D2AFF),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(image: NetworkImage(Config.imageBaseUrl + homeApi.homeData!.tickethistory[index].busImg),fit: BoxFit.cover))
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        flex: 6,
                                          child: Text(homeApi.homeData!.tickethistory[index].busName,style: TextStyle(fontFamily: 'SofiaLight',fontSize: constraints.maxWidth < 500 ? 13 : 15,fontWeight: FontWeight.bold,color: notifier.blackcolor),overflow: TextOverflow.ellipsis)),
                                      const Spacer(),
                                      Text("${homeApi.homeData!.currency}${homeApi.homeData!.tickethistory[index].ticketPrice}",style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: constraints.maxWidth < 500 ? 13 : 15,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(homeApi.homeData!.tickethistory[index].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 12,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                              const SizedBox(height: 8,),
                                              Text(convertTimeTo12HourFormat(homeApi.homeData!.tickethistory[index].busPicktime),style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,color: notifier.purplecolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Image.asset('assets/Icons/busHorizontalIcon.png',height: 50,width: 100,color: notifier.purplecolor),
                                          Text(homeApi.homeData!.tickethistory[index].differencePickDrop,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 12,color: notifier.blackcolor)),
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(homeApi.homeData!.tickethistory[index].dropCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 12,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                              const SizedBox(height: 8,),
                                              Text(convertTimeTo12HourFormat(homeApi.homeData!.tickethistory[index].busDroptime),style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,color: notifier.purplecolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                            ],
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
                        }),
                  ),
                ],
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
