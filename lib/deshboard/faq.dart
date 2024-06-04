import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/apicontroller/faqapi.dart';
import 'package:zigzagbus/deshboard/heading.dart';

import '../helper/appbar.dart';
import '../helper/colornotifier.dart';
import '../helper/drawerCommon.dart';
import '../helper/filldetails.dart';
import '../mediaquery/mq.dart';
import 'endofpage.dart';

class Faqpage extends StatefulWidget {
  const Faqpage({super.key});


  @override
  State<Faqpage> createState() => _FaqpageState();
}

class _FaqpageState extends State<Faqpage> {

  FaqApi faqApi = Get.put(FaqApi());

  final GlobalKey<ScaffoldState> faqkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      key: faqkey,
      backgroundColor: notifier.backgroundColor,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: LocalappBar(
            gkey: faqkey,
          )),
      body:  LayoutBuilder(
        builder: (context, constraints) {
          return faq(constraints);
        }
      ),
    );
  }
  Widget faq(constraints){
    return SingleChildScrollView(
      child: constraints.maxHeight < 1100 ? faqList(constraints) : SizedBox(
        height: Get.height,
        child: faqList(constraints),
      ),
    );
  }
  Widget faqList(constraints){
    return Column(
      children: [
        const SizedBox(height: 10,),
        HeadingPage(pageTitle: "Home".tr,nTitle: "FAQ",currentTitle: "",),
        const SizedBox(height: 10,),
        Row(
          children: [
            constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 20 : 0, right: constraints.maxWidth < 1000 ? 20 : 0, bottom: 20),
                child: ListView.builder(
                  itemCount: faqApi.faqData!.faqData.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          iconColor: notifier.blackcolor,
                          collapsedIconColor: notifier.blackcolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          backgroundColor: notifier.isDark ? notifier.whitecolor : notifier.searchgrey,
                          collapsedBackgroundColor: notifier.isDark ? notifier.whitecolor : notifier.searchgrey,
                          title: Text(faqApi.faqData!.faqData[index].question,style: TextStyle(fontSize: 16, color: notifier.blackcolor, fontWeight: FontWeight.w600, fontFamily: 'SofiaLight'),),
                          expandedAlignment: Alignment.centerLeft,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10, right: rtl ? 16 : constraints.maxWidth < 800 ? 50 : 200, left: 16),
                              child: Text(faqApi.faqData!.faqData[index].answer,style: TextStyle(fontFamily: 'SofiaLight', color: notifier.blackcolor, fontSize: 14),textAlign: TextAlign.start,),
                            )
                          ],
                        ),
                        const SizedBox(height: 14,),
                      ],
                    );
                  },),
              ),
            ),
            constraints.maxWidth < 1000 ? const SizedBox() : const Spacer()
          ],
        ),
        const SizedBox(height: 20),
        constraints.maxHeight < 1100 ? const SizedBox() :  const Spacer(),
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
