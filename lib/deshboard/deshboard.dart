  // ignore_for_file: camel_case_types, non_constant_identifier_names


import 'package:get/get.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/deshboard/recentBooking.dart';
import 'package:zigzagbus/deshboard/tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/appbar.dart';
import '../helper/colornotifier.dart';
import '../helper/drawerCommon.dart';
import '../helper/helperwidget/helperwidget.dart';
import '../mediaquery/mq.dart';
import 'bannerpage.dart';
import 'endofpage.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

enum SampleItem2 { itemOne, itemTwo, itemThree, itemfour }

class deshscreen extends StatefulWidget {
  const deshscreen({super.key});

  @override
  State<deshscreen> createState() => _deshscreenState();
}

class _deshscreenState extends State<deshscreen> {
  late ColorNotifier notifier;
  SampleItem? selectedMenu;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logInApi.getlocaldata().then((value) {
      homeApi.homepage().then((value) {
      });
    });
  }

  LoginApiController logInApi = Get.put(LoginApiController());
  HomeApiController homeApi = Get.put(HomeApiController());

  bool searchHover = false;
  bool searchHover2 = false;
  bool searchHover3 = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      // endDrawerEnableOpenDragGesture: true,
      key: _key,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(500),
          child: LocalappBar(gkey: _key,)
      ),
      backgroundColor: notifier.backgroundColor,
      body: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          return appbarleft(constraints);
        },
      )),
    );
  }

  int tabHover = 0;

  Widget appbarleft(constraints) {
    return SingleChildScrollView(
      child: constraints.maxHeight < 1470 ? deshboard(constraints)
          : SizedBox(
        height: Get.height,
        child: deshboard(constraints),
      ),
    );
  }
  Widget deshboard(constraints){
    return GetBuilder<HomeApiController>(
        builder: (homeApi) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        clipBehavior: Clip.none,
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            constraints.maxWidth < 800
                                ? Container(
                              height: constraints.maxWidth < 450
                                  ? 400 : 500,
                              decoration: BoxDecoration(
                                  color: notifier.purplecolor,
                                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                              ),)
                                : rtl ? Image.asset('assets/deshboard/deshScreenRtl.png', fit: BoxFit.cover)
                                : Image.asset('assets/deshboard/deshScreen.png',
                                fit: BoxFit.cover),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: constraints.maxWidth < 800
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Column(
                                            crossAxisAlignment: constraints.maxWidth < 800
                                                ? CrossAxisAlignment.center : CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                height: constraints.maxWidth < 800
                                                    ? constraints.maxWidth / 6.5
                                                    : constraints.maxWidth / 10,
                                              ),
                                              Text(
                                                'Online Bus Ticket Booking'.tr,
                                                style: TextStyle(
                                                    fontFamily: 'SofiaBold',
                                                    fontSize: constraints.maxWidth < 800
                                                        ? constraints.maxWidth / 12
                                                        : constraints.maxWidth / 30,
                                                    color: Colors.white,
                                                    height: 0.9,
                                                    letterSpacing: 2),
                                                textAlign: constraints.maxWidth < 800
                                                    ? TextAlign.center
                                                    : TextAlign.end,
                                              ),
                                              SizedBox(
                                                height:
                                                constraints.maxWidth < 500 ? 10 : 20,
                                              ),
                                              Text('Embark on a seamless travel  experience with ProZigzagBus'.tr,
                                                style: TextStyle(
                                                    fontFamily: 'SofiaBold',
                                                    fontSize: constraints.maxWidth < 800
                                                        ? constraints.maxWidth / 30
                                                        : constraints.maxWidth / 57,
                                                    color: Colors.white),
                                                textAlign: constraints.maxWidth < 800
                                                    ? TextAlign.center
                                                    : TextAlign.end,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                onHover: (value) {
                                                  setState(() {
                                                    searchHover3 = value;
                                                  });
                                                },
                                                child: AnimatedContainer(
                                                  duration: const Duration(milliseconds: 200),
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        elevation:
                                                        MaterialStateProperty.all(0),
                                                        shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    16))),
                                                        backgroundColor:
                                                        MaterialStateProperty.all(
                                                            Colors.white),
                                                      ),
                                                      onPressed: () {},
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 14, right: 14, top: 6, bottom: 6),
                                                        child: Text(
                                                          'Book Now'.tr,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily: 'SofiaBold',
                                                              color: notifier.purplecolor),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: constraints.maxWidth < 450
                                        ? constraints.maxWidth / 6.8
                                        : constraints.maxWidth < 550
                                        ? constraints.maxWidth / 6.4
                                        : constraints.maxWidth < 700
                                        ? constraints.maxWidth / 10.1
                                        : constraints.maxWidth < 850
                                        ? constraints.maxWidth / 16.6
                                        : constraints.maxWidth < 1010
                                        ? constraints.maxWidth / 25
                                        : constraints.maxWidth < 1150
                                        ? constraints.maxWidth / 22
                                        : constraints.maxWidth < 1300
                                        ? constraints.maxWidth / 22
                                        : constraints.maxWidth < 1600
                                        ? constraints.maxWidth / 16.9
                                        : constraints.maxWidth < 2000
                                        ? constraints.maxWidth / 12
                                        : constraints.maxWidth / 11),
                                Center(
                                  child: constraints.maxWidth < 950
                                      ? const help()
                                      : Padding(
                                    padding: EdgeInsets.only(left: constraints.maxWidth > 1599 ? 200 : 50, right: constraints.maxWidth > 1599 ? 200 : 50),
                                    child: const Tabsbar(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: constraints.maxWidth < 550
                        ? 35
                        : constraints.maxWidth / 25,
                  ),

                  // Recent Booking
                  homeApi.isLoading ? Center(child: CircularProgressIndicator(color: notifier.purplecolor)) : const RecentBooking(),

                  SizedBox(
                    height: constraints.maxWidth < 600 ? 35 : constraints.maxWidth / 30,
                  ),

                  // Banner Page
                  homeApi.isLoading ? Center(child: CircularProgressIndicator(color: notifier.purplecolor)) : const BannerP(),

                  SizedBox(
                    height: constraints.maxWidth < 600 ? 40 : constraints.maxWidth / 20,
                  ),
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
    );
  }
}
