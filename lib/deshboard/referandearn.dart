
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'dart:io' show Platform;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/apicontroller/referapi.dart';
import 'package:zigzagbus/deshboard/heading.dart';

import '../helper/appbar.dart';
import '../helper/colornotifier.dart';
import '../helper/drawerCommon.dart';
import 'endofpage.dart';

class ReferEarn extends StatefulWidget {
  const ReferEarn({super.key});

  @override
  State<ReferEarn> createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {

  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPackage();
    detailsData.add("Friends get \$${referApi.referData!.signupcredit} on their first complete transaction");
    detailsData.add("You get \$${referApi.referData!.refercredit} on your wallet");
  }

  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  ReferApi referApi = Get.put(ReferApi());
  List detailsData = ["Share the referral linkwith your friends.".tr,];
  final GlobalKey<ScaffoldState> referkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      key: referkey,
      backgroundColor: notifier.backgroundColor,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: LocalappBar(
            gkey: referkey,
          )),
      body:  LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: constraints.maxHeight < 1200 ? raE(constraints) : SizedBox(
              height: Get.height,
              child: raE(constraints),
            ),
          );
        }
      ),
    );
  }
  Widget raE(constraints){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 10,),
            HeadingPage(pageTitle: "Home".tr, nTitle: "Refer & Earn".tr,currentTitle: "",),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/lottie/referearn.json",height: 250),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                        text: "Earn".tr,
                        style: TextStyle(fontSize: 20, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                              text: " ${homeApi.homeData!.currency}${referApi.referData!.signupcredit} ",
                              style: TextStyle(fontSize: 20, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(
                                  text: "for each friend you refer".tr,
                                  style: TextStyle(fontSize: 20, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                                )
                              ]
                          )
                        ]
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                      itemCount: detailsData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/Icons/bus.svg",height: 20,),
                                const SizedBox(width: 10,),
                                Text(detailsData[index],style: TextStyle(fontSize: 16, color: notifier.blackcolor, fontFamily: 'SofiaLight',),),
                              ],
                            ),
                            const SizedBox(height: 10,)
                          ],
                        );
                      }
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: referApi.referData!.code),
                          );
                          Fluttertoast.showToast(
                            webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                            msg: "Copied!",
                            textColor: notifier.blackwhitecolor,
                          );
                        },
                        child: Container(
                          width: 200,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xFFe1e9f5),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text(referApi.referData!.code,style: const TextStyle(fontFamily: 'SofiaLihght', color: Colors.black, fontWeight: FontWeight.w600,fontSize: 14)),
                                const Spacer(),
                                SvgPicture.asset('assets/Icons/copyIcon.svg',)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      InkWell(
                        onTap: () async {
                          String msg = 'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code ${homeApi.homeData!.currency}${referApi.referData!.signupcredit}  & Enjoy your shopping !!!\nhttps://play.google.com/store/apps/details?id=$packageName';
                          await Share.share(
                            msg,
                            // subject:  'https://play.google.com/store/apps/details?id=$packageName',
                                // ?
                                // : Platform.isIOS
                                // ? 'https://play.google.com/store/apps/details?id=$packageName'
                                // : "",
                            // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                          );

                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              color: notifier.purplecolor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text("Rafer a Friend".tr, style: const TextStyle(fontFamily: 'SofiaLight', color: Colors.white, fontWeight: FontWeight.w600,fontSize: 14),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
        constraints.maxHeight < 1200 ? const SizedBox() : const Spacer(),
        Container(
            color: notifier.whitecolor,
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: endofpage(),
            )),
      ],
    );
  }
}
