import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zigzagbus/deshboard/heading.dart';

import '../apicontroller/homelistapi.dart';
import '../helper/appbar.dart';
import '../helper/drawerCommon.dart';
import '../helper/filldetails.dart';
import 'endofpage.dart';

class Pagelist extends StatefulWidget {
  const Pagelist({super.key});

  @override
  State<Pagelist> createState() => _PagelistState();
}

class _PagelistState extends State<Pagelist> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageListData();
  }

  PageListApi pageListApi = Get.put(PageListApi());

  String privacyPolicy = "";

  getPageListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      privacyPolicy = prefs.getString("policypolicy")!;
    });
  }

  final GlobalKey<ScaffoldState> pagekey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: pagekey,
      backgroundColor: notifier.backgroundColor,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: LocalappBar(
            gkey: pagekey,
          )),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                HeadingPage(pageTitle: "Home".tr, nTitle: "Privacy Policy".tr,currentTitle: "",),
                const SizedBox(height: 10,),
                constraints.maxWidth < 850 ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: HtmlWidget(
                        privacyPolicy,
                        textStyle:
                        TextStyle(
                          fontFamily: 'SofiaLight',
                          color: notifier.blackcolor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ) :
                Row(
                  children: [
                    constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 20 : 0, right: constraints.maxWidth < 1000 ? 20 : 0, bottom: 20),
                        child: HtmlWidget(
                         privacyPolicy,
                          textStyle:
                          TextStyle(
                            fontFamily: 'SofiaLight',
                            color: notifier.blackcolor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    constraints.maxWidth < 1000 ? const SizedBox() : const Spacer()
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                    color: notifier.whitecolor,
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: endofpage(),
                    )),
              ],
            ),
          );
        }
      ),
    );
  }
}



class TermCondition extends StatefulWidget {
  const TermCondition({super.key});

  @override
  State<TermCondition> createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageListData();
  }
  
  String termcondition = "";

  getPageListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      termcondition = prefs.getString("termcondition")!;
    });
  }
  
  final GlobalKey<ScaffoldState> pagekey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: pagekey,
      backgroundColor: notifier.backgroundColor,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: LocalappBar(
            gkey: pagekey,
          )),
      body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  HeadingPage(pageTitle: "Home".tr, nTitle: "Term & Condition".tr,currentTitle: "",),
                  const SizedBox(height: 10,),
                  constraints.maxWidth < 850 ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        child: HtmlWidget(
                          termcondition,
                          textStyle:
                          TextStyle(
                            fontFamily: 'SofiaLight',
                            color: notifier.blackcolor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 20 : 0, right: constraints.maxWidth < 1000 ? 20 : 0, bottom: 20),
                          child: HtmlWidget(
                           termcondition,
                            textStyle:
                            TextStyle(
                              fontFamily: 'SofiaLight',
                              color: notifier.blackcolor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      color: notifier.whitecolor,
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: endofpage(),
                      )),
                ],
              ),
            );
          }
      ),
    );
  }
}


class Contactus extends StatefulWidget {
  const Contactus({super.key});

  @override
  State<Contactus> createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageListData();
  }
  
  String contactus = "";
  getPageListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      contactus = prefs.getString("contactus")!;
    });
  }
  
  final GlobalKey<ScaffoldState> pagekey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: pagekey,
      backgroundColor: notifier.backgroundColor,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: LocalappBar(
            gkey: pagekey,
          )),
      body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: constraints.maxHeight <735 ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10,),
                      HeadingPage(pageTitle: "Home".tr, nTitle: "Contact Us".tr,currentTitle: "",),
                      const SizedBox(height: 10,),
                      constraints.maxWidth < 850 ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                            child: HtmlWidget(
                              contactus,
                              textStyle:
                              TextStyle(
                                fontFamily: 'SofiaLight',
                                color: notifier.blackcolor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                          : Row(
                        children: [
                          constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 20 : 0, right: constraints.maxWidth < 1000 ? 20 : 0, bottom: 20),
                              child: HtmlWidget(
                                contactus,
                                textStyle:
                                TextStyle(
                                  fontFamily: 'SofiaLight',
                                  color: notifier.blackcolor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          constraints.maxWidth < 1000 ? const SizedBox() : const Spacer()
                        ],
                      ),
                      const SizedBox(
                        height: 20,
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
              )
                  : SizedBox(
                height: Get.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10,),
                        HeadingPage(pageTitle: "Home".tr, nTitle: "Contact Us".tr,currentTitle: "",),
                        const SizedBox(height: 10,),
                        constraints.maxWidth < 850 ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                              child: HtmlWidget(
                                contactus,
                                textStyle:
                                TextStyle(
                                  fontFamily: 'SofiaLight',
                                  color: notifier.blackcolor,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                            : Row(
                          children: [
                            constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 20 : 0, right: constraints.maxWidth < 1000 ? 20 : 0, bottom: 20),
                                child: HtmlWidget(
                                  contactus,
                                  textStyle:
                                  TextStyle(
                                    fontFamily: 'SofiaLight',
                                    color: notifier.blackcolor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            constraints.maxWidth < 1000 ? const SizedBox() : const Spacer()
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    const Spacer(),
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
      ),
    );
  }
}


class CancelPol extends StatefulWidget {
  const CancelPol({super.key});

  @override
  State<CancelPol> createState() => _CancelPolState();
}

class _CancelPolState extends State<CancelPol> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageListData();
  }

  String cancelation = "";

  getPageListData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      cancelation = prefs.getString("cancelationpolicy")!;
    });
  }

  final GlobalKey<ScaffoldState> pagekey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: pagekey,
      backgroundColor: notifier.backgroundColor,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: LocalappBar(
            gkey: pagekey,
          )),
      body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  HeadingPage(pageTitle: "Home".tr, nTitle: "Cancellation Policy".tr,currentTitle: "",),
                  const SizedBox(height: 10,),
                  constraints.maxWidth < 850 ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                        child: HtmlWidget(
                          cancelation,
                          textStyle:
                          TextStyle(
                            fontFamily: 'SofiaLight',
                            color: notifier.blackcolor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 20 : 0, right: constraints.maxWidth < 1000 ? 20 : 0, bottom: 20),
                          child: HtmlWidget(
                            cancelation,
                            textStyle:
                            TextStyle(
                              fontFamily: 'SofiaLight',
                              color: notifier.blackcolor,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      constraints.maxWidth < 1000 ? const SizedBox() : const Spacer()
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      color: notifier.whitecolor,
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: endofpage(),
                      )),
                ],
              ),
            );
          }
      ),
    );
  }
}
