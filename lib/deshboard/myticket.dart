import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/apicontroller/bookinghistory.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/apicontroller/searchbuscontroller.dart';
import 'package:zigzagbus/apicontroller/ticketdetailsapi.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/deshboard/heading.dart';
import 'package:zigzagbus/deshboard/ticketdetails.dart';

import '../helper/appbar.dart';
import '../helper/colornotifier.dart';
import '../helper/drawerCommon.dart';
import '../mediaquery/mq.dart';
import 'endofpage.dart';

class Mytickets extends StatefulWidget {
  const Mytickets({super.key});

  @override
  State<Mytickets> createState() => _MyticketsState();
}

class _MyticketsState extends State<Mytickets> {

  late ColorNotifier notifier;

  BookingHistoryApi bookingHApi = Get.put(BookingHistoryApi());

  SearchBusApi searchBusApi = Get.put(SearchBusApi());
  HomeApiController homeApi = Get.put(HomeApiController());
  TicketDetailsApi ticketDetailsApi = Get.put(TicketDetailsApi());
  final GlobalKey<ScaffoldState> myticketKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.isDark ? notifier.backgroundColor : notifier.searchgrey,
      key: myticketKey,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: LocalappBar(gkey: myticketKey,),
      ),
      body: LayoutBuilder(
        builder: (context, constraints){
          return bookingDetails(constraints);
        }
      ),
    );
  }
  Widget bookingDetails(constraints){
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10,),
            HeadingPage(pageTitle: "Home".tr,nTitle: "My Ticket".tr,currentTitle: "",),
            const SizedBox(height: 20),
            Row(
              children: [
                constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 10 : 0, right: constraints.maxWidth < 1000 ? 10 : 0),
                    child: DefaultTabController(
                        length: 3,
                        initialIndex: 0,
                        child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: notifier.grey03,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(constraints.maxWidth < 550 ? 6 : 10),
                            child: TabBar(
                                indicator: BoxDecoration(
                                  color: notifier.purplecolor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelStyle: TextStyle(fontSize: constraints.maxWidth < 350 ? 8 : constraints.maxWidth < 396 ? 10 : constraints.maxWidth < 450 ? 12 : constraints.maxWidth < 550 ? 14 : 18, color: Colors.white, fontFamily: 'SofiaLight',),
                                unselectedLabelStyle: TextStyle(fontSize: constraints.maxWidth < 350 ? 8 : constraints.maxWidth < 396 ? 10 : constraints.maxWidth < 450 ? 12 : constraints.maxWidth < 550 ? 14 : 18, color: Colors.black, fontFamily: 'SofiaLight',),
                                // labelStyle: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'SofiaLight',),
                                tabs: [
                                  Tab(
                                    text: 'Upcoming Trips'.tr,
                                  ),
                                  Tab(
                                    text: 'Completed Trips'.tr,
                                  ),
                                  Tab(
                                    text: 'Cancel Trips'.tr,
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            height: height / 1.6,
                            child: TabBarView(
                                children: [
                                  bookingHApi.isLoading ? CircularProgressIndicator(color: notifier.purplecolor) : bookingHApi.bookingHData!.tickethistory.isEmpty ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/Icons/nofound.svg",height: 70,),
                                        const SizedBox(height: 10,),
                                        Text("No booking found".tr,style: TextStyle(fontFamily: 'SofiaLight', fontSize: 24, color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                                        const SizedBox(height: 20),
                                        Text("You don't have any booking records!".tr,style: TextStyle(fontFamily: 'SofiaLight', fontSize: 14, color: notifier.greycolor),overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                  )
                                      : ListView.builder(
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: bookingHApi.bookingHData!.tickethistory.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ticketDetailsApi.ticketDetails(context, bookingHApi.bookingHData!.tickethistory[index].ticketId).then((value) {
                                                Get.to(const TicketDetails(isUpcoming: true,isRecent: true,));
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
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
                                                            height: 45,
                                                            width: 45,
                                                            decoration: BoxDecoration(
                                                                color: const Color(0xff7D2AFF),
                                                                shape: BoxShape.circle,
                                                                image: DecorationImage(image: NetworkImage(Config.imageBaseUrl + bookingHApi.bookingHData!.tickethistory[index].busImg),fit: BoxFit.cover))
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        Expanded(
                                                            flex: 6,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(bookingHApi.bookingHData!.tickethistory[index].busName,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 18, fontWeight: FontWeight.bold,color: notifier.blackcolor),overflow: TextOverflow.ellipsis),
                                                                Text(bookingHApi.bookingHData!.tickethistory[index].isAc == "0" ? "Non Ac" : "AC" ,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 15,color: notifier.blackcolor),overflow: TextOverflow.ellipsis),
                                                              ],
                                                            )),
                                                        const Spacer(),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("${homeApi.homeData!.currency}${bookingHApi.bookingHData!.tickethistory[index].subtotal}",style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 16,fontWeight: FontWeight.bold),),
                                                            Text(bookingHApi.bookingHData!.tickethistory[index].bookDate.toString().split(' ').first,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14,fontWeight: FontWeight.bold),),
                                                          ],
                                                        ),
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
                                                                Text(bookingHApi.bookingHData!.tickethistory[index].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 16,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                                const SizedBox(height: 8,),
                                                                Text(convertTimeTo12HourFormat(bookingHApi.bookingHData!.tickethistory[index].busPicktime),style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,color: notifier.purplecolor,fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        Column(
                                                          children: [
                                                            Image.asset('assets/Icons/busHorizontalIcon.png',height: 50,width: 100,color: notifier.purplecolor),
                                                            Text(bookingHApi.bookingHData!.tickethistory[index].differencePickDrop,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 12,color: notifier.blackcolor)),
                                                          ],
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Flexible(
                                                          child: SizedBox(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text(bookingHApi.bookingHData!.tickethistory[index].dropCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 16,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                                const SizedBox(height: 8,),
                                                                Text(convertTimeTo12HourFormat(bookingHApi.bookingHData!.tickethistory[index].busDroptime),style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,color: notifier.purplecolor, fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1),
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
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    },),
                                  bookingHApi.isLoading ? CircularProgressIndicator(color: notifier.purplecolor) : bookingHApi.bookingHDataComp!.tickethistory.isEmpty ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/Icons/nofound.svg",height: 70,),
                                        const SizedBox(height: 10,),
                                        Text("No booking found".tr,style: TextStyle(fontFamily: 'SofiaLight', fontSize: 24, color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                                        const SizedBox(height: 20),
                                        Text("You don't have any previous records!".tr,style: TextStyle(fontFamily: 'SofiaLight', fontSize: 14, color: notifier.greycolor),overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                  )
                                      : ListView.builder(
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: bookingHApi.bookingHDataComp!.tickethistory.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ticketDetailsApi.ticketDetails(context, bookingHApi.bookingHDataComp!.tickethistory[index].ticketId).then((value) {
                                                Get.to(const TicketDetails(isUpcoming: false, isRecent: true,));
                                              });
                                            },
                                            child: Container(
                                              width: double.infinity,
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
                                                            height: 45,
                                                            width: 45,
                                                            decoration: BoxDecoration(
                                                                color: const Color(0xff7D2AFF),
                                                                shape: BoxShape.circle,
                                                                image: DecorationImage(image: NetworkImage(Config.imageBaseUrl + bookingHApi.bookingHDataComp!.tickethistory[index].busImg),fit: BoxFit.cover))
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        Expanded(
                                                            flex: 6,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(bookingHApi.bookingHDataComp!.tickethistory[index].busName,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 18, fontWeight: FontWeight.bold,color: notifier.blackcolor),overflow: TextOverflow.ellipsis),
                                                                Text(bookingHApi.bookingHDataComp!.tickethistory[index].isAc == "0" ? "Non Ac" : "AC" ,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 15,color: notifier.blackcolor),overflow: TextOverflow.ellipsis),
                                                              ],
                                                            )),
                                                        const Spacer(),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("${homeApi.homeData!.currency}${bookingHApi.bookingHDataComp!.tickethistory[index].subtotal}",style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 16,fontWeight: FontWeight.bold),),
                                                            Text(bookingHApi.bookingHDataComp!.tickethistory[index].bookDate.toString().split(' ').first,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14,fontWeight: FontWeight.bold),),
                                                          ],
                                                        ),
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
                                                                Text(bookingHApi.bookingHDataComp!.tickethistory[index].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 16,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                                const SizedBox(height: 8,),
                                                                Text(convertTimeTo12HourFormat(bookingHApi.bookingHDataComp!.tickethistory[index].busPicktime),style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,color: notifier.purplecolor,fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        Column(
                                                          children: [
                                                            Image.asset('assets/Icons/busHorizontalIcon.png',height: 50,width: 100,color: notifier.purplecolor),
                                                            Text(bookingHApi.bookingHDataComp!.tickethistory[index].differencePickDrop,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 12,color: notifier.blackcolor)),
                                                          ],
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Flexible(
                                                          child: SizedBox(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text(bookingHApi.bookingHDataComp!.tickethistory[index].dropCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 16,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                                const SizedBox(height: 8,),
                                                                Text(convertTimeTo12HourFormat(bookingHApi.bookingHDataComp!.tickethistory[index].busDroptime),style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,color: notifier.purplecolor, fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1),
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
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    },),
                                  bookingHApi.isLoading ? CircularProgressIndicator(color: notifier.purplecolor) : bookingHApi.bookingHDataCanc!.tickethistory.isEmpty ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/Icons/nofound.svg",height: 70,),
                                        const SizedBox(height: 10,),
                                        Text("No booking found".tr,style: TextStyle(fontFamily: 'SofiaLight', fontSize: 24, color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                                        const SizedBox(height: 20),
                                        Text("You don't have any cancel booking records!".tr,style: TextStyle(fontFamily: 'SofiaLight', fontSize: 14, color: notifier.greycolor),overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                  )
                                      : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: bookingHApi.bookingHDataCanc!.tickethistory.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
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
                                                          height: 45,
                                                          width: 45,
                                                          decoration: BoxDecoration(
                                                              color: const Color(0xff7D2AFF),
                                                              shape: BoxShape.circle,
                                                              image: DecorationImage(image: NetworkImage(Config.imageBaseUrl + bookingHApi.bookingHDataCanc!.tickethistory[index].busImg),fit: BoxFit.cover))
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Expanded(
                                                          flex: 6,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(bookingHApi.bookingHDataCanc!.tickethistory[index].busName,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 18, fontWeight: FontWeight.bold,color: notifier.blackcolor),overflow: TextOverflow.ellipsis),
                                                              Text(bookingHApi.bookingHDataCanc!.tickethistory[index].isAc == "0" ? "Non Ac" : "AC" ,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 15,color: notifier.blackcolor),overflow: TextOverflow.ellipsis),
                                                            ],
                                                          )),
                                                      const Spacer(),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text("${homeApi.homeData!.currency}${bookingHApi.bookingHDataCanc!.tickethistory[index].subtotal}",style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 16,fontWeight: FontWeight.bold),),
                                                          Text(bookingHApi.bookingHDataCanc!.tickethistory[index].bookDate.toString().split(' ').first,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14,fontWeight: FontWeight.bold),),
                                                        ],
                                                      ),
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
                                                              Text(bookingHApi.bookingHDataCanc!.tickethistory[index].boardingCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 16,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                              const SizedBox(height: 8,),
                                                              Text(convertTimeTo12HourFormat(bookingHApi.bookingHDataCanc!.tickethistory[index].busPicktime),style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,color: notifier.purplecolor,fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Column(
                                                        children: [
                                                          Image.asset('assets/Icons/busHorizontalIcon.png',height: 50,width: 100,color: notifier.purplecolor),
                                                          Text(bookingHApi.bookingHDataCanc!.tickethistory[index].differencePickDrop,style: TextStyle(fontFamily: 'SofiaLight',fontSize: 12,color: notifier.blackcolor)),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Flexible(
                                                        child: SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(bookingHApi.bookingHDataCanc!.tickethistory[index].dropCity,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,fontSize: 16,color: notifier.blackcolor),overflow: TextOverflow.ellipsis,maxLines: 1),
                                                              const SizedBox(height: 8,),
                                                              Text(convertTimeTo12HourFormat(bookingHApi.bookingHDataCanc!.tickethistory[index].busDroptime),style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.bold,color: notifier.purplecolor, fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1),
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
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    },)
                                ]),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                constraints.maxWidth < 1000 ? const SizedBox() : const Spacer()
              ],
            ),
            const SizedBox(height: 20,),
            Container(
                color: notifier.whitecolor,
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: endofpage(),
                )),
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
