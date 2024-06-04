
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/config.dart';

import '../apicontroller/homeapi.dart';
import '../helper/colornotifier.dart';
import '../mediaquery/mq.dart';

class BannerP extends StatefulWidget {
  const BannerP({super.key});

  @override
  State<BannerP> createState() => _BannerPState();
}

class _BannerPState extends State<BannerP> {
  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeApi.homepage();
  }

  HomeApiController homeApi = Get.put(HomeApiController());
  ScrollController sugcon = ScrollController();

  int a = 4;
  bool isHover = false;
  bool isHover2 = false;

  int cpage = 0;

  var homeData;

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return bannerPage(constraints);
      },
    );
  }

  Widget bannerPage(constraints) {
    return Column(
      children: [
        // Heading
        Padding(
          padding: EdgeInsets.only(
              left: constraints.maxWidth < 500 ? 10 : 0,
              right: constraints.maxWidth < 500 ? 10 : 0),
          child: Column(
            children: [
              Text("Enjoy the travel experience with us".tr,
                  style: TextStyle(
                      fontFamily: 'SofiaLight',
                      fontWeight: FontWeight.w700,
                      fontSize: constraints.maxWidth < 550 ? 24 : 45,
                      color: notifier.blackcolor),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
              const SizedBox(height: 5),
              Text(
                "Book your adventure, pack your bags and let the exploration begin.".tr,
                style: TextStyle(
                    fontFamily: 'SofiaLight',
                    fontWeight: FontWeight.w600,
                    fontSize: constraints.maxWidth < 700 ? 15 : 20,
                    color: notifier.greycolor),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(
          height: constraints.maxWidth < 550 ? 15 : constraints.maxWidth / 30,
        ),

        // Banners
        constraints.maxWidth < 600
            ? SizedBox(
          height: 240,
              width: width/1,
              child: CarouselSlider(
                  items: [
                      for (int a = 0; a < homeApi.homeData!.banner.length; a++)
                        Padding(
                          padding: const EdgeInsets.only(right: 6, left: 12),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(right: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                Config.imageBaseUrl + homeApi.homeData!.banner[a].img,
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                    ],
                  options: CarouselOptions(
                    viewportFraction: 0.99,
                    initialPage: 0,
                    onPageChanged: (index, reason) {
                      cpage = index;
                      setState(() {});
                    },
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(seconds: 2),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0,
                    scrollDirection: Axis.horizontal,
                  )),
            )
            : Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: constraints.maxWidth / 1.258,
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: sugcon,
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return ListView.builder(
                              shrinkWrap: true,
                              controller: sugcon,
                              scrollDirection: Axis.horizontal,
                              itemCount: homeApi.homeData!.banner.length,
                              itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                EdgeInsets.only(right: index == 5 ? 0 : 20),
                                child: Image.network(Config.imageBaseUrl + homeApi.homeData!.banner[index].img,
                                    height: constraints.maxWidth < 750
                                        ? 110
                                        : constraints.maxWidth < 1000
                                        ? 130
                                        : 200),
                              );
                            },);
                          },
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: constraints.maxWidth < 1000
                        ? constraints.maxWidth / 13.5
                        : constraints.maxWidth < 1200
                            ? constraints.maxWidth / 12
                            : constraints.maxWidth / 11.5,
                    child: InkWell(
                      onTap: () {
                        sugcon.animateTo(double.parse("${a}00"),
                            curve: const FlippedCurve(Easing.legacy),
                            duration: const Duration(seconds: 1));
                        setState(() {
                          a = a - 4;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: notifier.whitecolor,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: notifier.isDark ? SvgPicture.asset(
                            'assets/Icons/leftArrowIconDark.svg',
                            width: 20) : SvgPicture.asset(
                            'assets/Icons/leftArrowIcon.svg',
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: constraints.maxWidth < 1000
                        ? constraints.maxWidth / 12.5
                        : constraints.maxWidth < 1200
                            ? constraints.maxWidth / 12
                            : constraints.maxWidth / 10.8,
                    child: InkWell(
                      onTap: () {
                        sugcon.animateTo(double.parse("${a}00"),
                            curve: const FlippedCurve(Easing.legacy),
                            duration: const Duration(seconds: 1));
                        setState(() {
                          a = a + 4;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: notifier.whitecolor,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: notifier.isDark ? SvgPicture.asset(
                              'assets/Icons/rightArrowIconDark.svg',
                              width: 20) : SvgPicture.asset(
                              'assets/Icons/rightArrowIcon.svg',
                              width: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}