import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/apicontroller/paygetvayapi.dart';
import 'package:zigzagbus/apicontroller/payoutlistapi.dart';
import 'package:zigzagbus/apicontroller/walletapi.dart';
import 'package:zigzagbus/apicontroller/walletreportapi.dart';
import 'package:zigzagbus/deshboard/agentearning.dart';
import 'package:zigzagbus/deshboard/faq.dart';

import '../config.dart';
import '../helper/appbar.dart';
import '../helper/colornotifier.dart';
import '../helper/drawerCommon.dart';
import '../paymentwebview/paypalwebview.dart';
import '../razorpaymodel.dart';
import 'endofpage.dart';
import 'heading.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late ColorNotifier notifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorPayClass.initiateRazorPay(
        handlePaymentSuccess: handlePaymentSuccess,
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet);

  }

  WalletReportApi walletreportApi = Get.put(WalletReportApi());
  HomeApiController homeApi = Get.put(HomeApiController());
  WalletApi walletApi = Get.put(WalletApi());
  PayGetwayApi payGetwayApi = Get.put(PayGetwayApi());
  LoginApiController logInApi = Get.put(LoginApiController());
  final GlobalKey<ScaffoldState> walletKey = GlobalKey();
  PayoutListApi payoutListApi = Get.put(PayoutListApi());

  RazorPayClass razorPayClass = RazorPayClass();
  int paymethod = 0;

  TextEditingController mainAmt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.backgroundColor,
      key: walletKey,
      endDrawer: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600 ? const CommonDrawer() : paymethodDrawer();
        }
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: LocalappBar(gkey: walletKey,),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return wallet(constraints);
      },),
    );
  }
  Widget wallet(constraints){
    return SingleChildScrollView(
      child: constraints.maxHeight < 874 ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 20,),
              HeadingPage(pageTitle: "Home".tr,nTitle: "My Wallet".tr,currentTitle: "",),
              const SizedBox(height: 20),
              Row(
                children: [
                  constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 10 : 0, right: constraints.maxWidth < 1000 ? 10 : 0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: notifier.purplecolor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: constraints.maxWidth < 600 ? 20 : 50,left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Wallet".tr, style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),),
                                        logInApi.userData["user_type"] == "USER" ? InkWell(
                                          onTap: () {
      
                                            Get.to(const Faqpage());
      
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(bottom: 2.0),
                                                child: Text("FAQ", style: TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 14,),),
                                              ),
                                              const SizedBox(width: 5,),
                                              SvgPicture.asset("assets/Icons/questioncircleIcon.svg",height: 20,),
                                            ],
                                          ),
                                        )
                                            : InkWell(
                                          onTap: () {
                                            payoutListApi.payoutList().then((value) {
                                              Get.to(const AgentEarning());
                                            });
      
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 2.0),
                                                child: Text("My Earning".tr, style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 14,),),
                                              ),
                                              const SizedBox(width: 5,),
                                              SvgPicture.asset("assets/Icons/questioncircleIcon.svg",height: 20,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: EdgeInsets.only(left: constraints.maxWidth < 600 ? 20 : constraints.maxWidth < 1000 ? 50 : 100, right: constraints.maxWidth < 600 ? 20 : constraints.maxWidth < 1000 ? 50 : 100),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: notifier.whitecolor,
                                          border: Border.all(color: notifier.sugestionbutton),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: constraints.maxWidth < 600 ? Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Lottie.asset("assets/lottie/wallet.json",height: 50),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("TOTAL WALLET BALANCE".tr,style: TextStyle(fontFamily: "SofiaLight", color: notifier.greycolor, fontSize: 12),),
                                                      Text("${homeApi.homeData!.currency} ${walletreportApi.walletreportData!.wallet}",style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16, fontWeight: FontWeight.w600),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStatePropertyAll(notifier.purplecolor,),
                                                      shape:  MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                                      elevation: const MaterialStatePropertyAll(0)
                                                  ),
                                                  onPressed: () {
                                                    payGetwayApi.payGetway(context).then((value) {
                                                      showModalBottomSheet(
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius.circular(28),
                                                                topLeft: Radius.circular(28))),
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            color: notifier.backgroundColor,
                                                            child: Stack(
                                                              children: [
                                                                SingleChildScrollView(
                                                                  child: StatefulBuilder(builder: (context, setState) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets.only(
                                                                          left: 10, right: 10, bottom: 40, top: 10),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              'Enter Wallet Amount'.tr,
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: notifier.purplecolor,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: 'SofiaLight'),
                                                                              overflow: TextOverflow.ellipsis
                                                                          ),
                                                                          const SizedBox(height: 10),
                                                                          TextField(
                                                                            controller: mainAmt,
                                                                            decoration: InputDecoration(
                                                                              hintText: "Enter Amount".tr,
                                                                              hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                                                                              prefixIcon: Padding(
                                                                                padding: const EdgeInsets.all(10),
                                                                                child: SvgPicture.asset("assets/Icons/wallet.svg",height: 10),
                                                                              ),
                                                                              contentPadding: const EdgeInsets.only(left: 5),
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
                                                                          const SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(
                                                                              'Select Payment Method'.tr,
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: notifier.purplecolor,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: 'SofiaLight'),
                                                                              overflow: TextOverflow.ellipsis
                                                                          ),
                                                                          const SizedBox(height: 10),
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

                                                                            mainAmt.text.isEmpty ?  Fluttertoast.showToast(
                                                                              msg: "Please enter amount first!",
                                                                            ) : razorPayClass.openCheckout(
                                                                                key: payGetwayApi.paygetwayData!.paymentdata[paymethod].id,
                                                                                amount: mainAmt.text.toString(),
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
                                                            ),
                                                          );
                                                        },);
                                                    });
                                                  }, child: Padding(
                                                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset("assets/Icons/topupIcon.svg",height: 20,),
                                                    const SizedBox(width: 10),
                                                    Text("Top Up".tr,style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 16)),
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                        ) : Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Lottie.asset("assets/lottie/wallet.json",height: 80),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("TOTAL WALLET BALANCE".tr,style: TextStyle(fontFamily: "SofiaLight", color: notifier.greycolor, fontSize: 16),),
                                                          Text("${homeApi.homeData!.currency} ${walletreportApi.walletreportData!.wallet}",style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 20, fontWeight: FontWeight.w600),),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor: MaterialStatePropertyAll(notifier.purplecolor,),
                                                          shape:  MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                                          elevation: const MaterialStatePropertyAll(0)
                                                      ),
                                                      onPressed: () {
                                                        payGetwayApi.payGetway(context).then((value) {
                                                          walletKey.currentState!.openEndDrawer();
                                                        });
                                                      }, child: Padding(
                                                    padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SvgPicture.asset("assets/Icons/topupIcon.svg",height: 20,),
                                                        const SizedBox(width: 10),
                                                        Text("Top Up".tr,style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 16)),
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          walletreportApi.walletreportData!.walletitem.isEmpty ? const SizedBox() : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Transaction Details".tr,style: TextStyle(fontFamily: "SofiaLight", fontSize: 18, color: notifier.blackcolor, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: walletreportApi.walletreportData!.walletitem.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              walletreportApi.walletreportData!.walletitem[index].status == "Credit"
                                                  ? SvgPicture.asset("assets/Icons/creditIcon.svg",height: 45,)
                                                  : SvgPicture.asset("assets/Icons/debitIcon.svg",height: 45,),
                                              const SizedBox(width: 8),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(walletreportApi.walletreportData!.walletitem[index].message,style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 16, fontFamily: "SofiaLight"),),
                                                  Text(walletreportApi.walletreportData!.walletitem[index].status,style: TextStyle(color: notifier.greycolor, fontSize: 12, fontFamily: "SofiaLight"),),
                                                ],
                                              ),
                                            ],
                                          ),
                                          walletreportApi.walletreportData!.walletitem[index].status == "Credit" ? Text("+ ${homeApi.homeData!.currency}${walletreportApi.walletreportData!.walletitem[index].amt}", style: TextStyle(fontWeight: FontWeight.w600, color: notifier.lightgreencolor, fontSize: 14, fontFamily: "SofiaLight"),)
                                              : Text("- ${homeApi.homeData!.currency}${walletreportApi.walletreportData!.walletitem[index].amt}", style: TextStyle(fontWeight: FontWeight.w600, color: notifier.redcolor, fontSize: 14, fontFamily: "SofiaLight"),),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                    ],
                                  );
                                },),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                ],
              ),
              SizedBox(height:  walletreportApi.walletreportData!.walletitem.isEmpty ? 20 : 50  ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 20,),
                HeadingPage(pageTitle: "Home".tr,nTitle: "My Wallet".tr,currentTitle: "",),
                const SizedBox(height: 20),
                Row(
                  children: [
                   constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 10 : 0, right: constraints.maxWidth < 1000 ? 10 : 0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: notifier.purplecolor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: constraints.maxWidth < 600 ? 20 : 50,left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Wallet".tr, style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),),
                                          logInApi.userData["user_type"] == "USER" ? InkWell(
                                            onTap: () {

                                              Get.to(const Faqpage());

                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(bottom: 2.0),
                                                  child: Text("FAQ", style: TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 14,),),
                                                ),
                                                const SizedBox(width: 5,),
                                                SvgPicture.asset("assets/Icons/questioncircleIcon.svg",height: 20,),
                                              ],
                                            ),
                                          )
                                              : InkWell(
                                            onTap: () {
                                              payoutListApi.payoutList().then((value) {
                                                Get.to(const AgentEarning());
                                              });

                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 2.0),
                                                  child: Text("My Earning".tr, style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 14,),),
                                                ),
                                                const SizedBox(width: 5,),
                                                SvgPicture.asset("assets/Icons/questioncircleIcon.svg",height: 20,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Padding(
                                      padding: EdgeInsets.only(left: constraints.maxWidth < 600 ? 20 : constraints.maxWidth < 1000 ? 50 : 100, right: constraints.maxWidth < 600 ? 20 : constraints.maxWidth < 1000 ? 50 : 100),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: notifier.whitecolor,
                                          border: Border.all(color: notifier.sugestionbutton),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: constraints.maxWidth < 600 ? Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Lottie.asset("assets/lottie/wallet.json",height: 50),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("TOTAL WALLET BALANCE".tr,style: TextStyle(fontFamily: "SofiaLight", color: notifier.greycolor, fontSize: 12),),
                                                      Text("${homeApi.homeData!.currency} ${walletreportApi.walletreportData!.wallet}",style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16, fontWeight: FontWeight.w600),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStatePropertyAll(notifier.purplecolor,),
                                                      shape:  MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                                      elevation: const MaterialStatePropertyAll(0)
                                                  ),
                                                  onPressed: () {
                                                    payGetwayApi.payGetway(context).then((value) {
                                                      showModalBottomSheet(
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius.circular(28),
                                                                topLeft: Radius.circular(28))),
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                            color: notifier.backgroundColor,
                                                            child: Stack(
                                                              children: [
                                                                SingleChildScrollView(
                                                                  child: StatefulBuilder(builder: (context, setState) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets.only(
                                                                          left: 10, right: 10, bottom: 40, top: 10),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              'Enter Wallet Amount'.tr,
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: notifier.purplecolor,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: 'SofiaLight'),
                                                                              overflow: TextOverflow.ellipsis
                                                                          ),
                                                                          const SizedBox(height: 10),
                                                                          TextField(
                                                                            controller: mainAmt,
                                                                            decoration: InputDecoration(
                                                                              hintText: "Enter Amount".tr,
                                                                              hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                                                                              prefixIcon: Padding(
                                                                                padding: const EdgeInsets.all(10),
                                                                                child: SvgPicture.asset("assets/Icons/wallet.svg",height: 10),
                                                                              ),
                                                                              contentPadding: const EdgeInsets.only(left: 5),
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
                                                                          const SizedBox(
                                                                            height: 10,
                                                                          ),
                                                                          Text(
                                                                              'Select Payment Method'.tr,
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: notifier.purplecolor,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontFamily: 'SofiaLight'),
                                                                              overflow: TextOverflow.ellipsis
                                                                          ),
                                                                          const SizedBox(height: 10),
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

                                                                            mainAmt.text.isEmpty ?  Fluttertoast.showToast(
                                                                              msg: "Please enter amount first!",
                                                                            ) : razorPayClass.openCheckout(
                                                                                key: payGetwayApi.paygetwayData!.paymentdata[paymethod].id,
                                                                                amount: mainAmt.text.toString(),
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
                                                            ),
                                                          );
                                                        },);
                                                    });
                                                  }, child: Padding(
                                                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset("assets/Icons/topupIcon.svg",height: 20,),
                                                    const SizedBox(width: 10),
                                                    Text("Top Up".tr,style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 16)),
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                        ) : Column(
                                      children: [
                                      Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Lottie.asset("assets/lottie/wallet.json",height: 80),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("TOTAL WALLET BALANCE".tr,style: TextStyle(fontFamily: "SofiaLight", color: notifier.greycolor, fontSize: 16),),
                                                  Text("${homeApi.homeData!.currency} ${walletreportApi.walletreportData!.wallet}",style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 20, fontWeight: FontWeight.w600),),
                                                ],
                                              ),
                                            ],
                                          ),
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(notifier.purplecolor,),
                                                  shape:  MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                                  elevation: const MaterialStatePropertyAll(0)
                                              ),
                                              onPressed: () {
                                                payGetwayApi.payGetway(context).then((value) {
                                                  walletKey.currentState!.openEndDrawer();
                                                });
                                              }, child: Padding(
                                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset("assets/Icons/topupIcon.svg",height: 20,),
                                                const SizedBox(width: 10),
                                                Text("Top Up".tr,style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 16)),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            walletreportApi.walletreportData!.walletitem.isEmpty ? const SizedBox() : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Transaction Details".tr,style: TextStyle(fontFamily: "SofiaLight", fontSize: 18, color: notifier.blackcolor, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 12),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: walletreportApi.walletreportData!.walletitem.length,
                                  itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              walletreportApi.walletreportData!.walletitem[index].status == "Credit"
                                                  ? SvgPicture.asset("assets/Icons/creditIcon.svg",height: 45,)
                                                  : SvgPicture.asset("assets/Icons/debitIcon.svg",height: 45,),
                                              const SizedBox(width: 8),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(walletreportApi.walletreportData!.walletitem[index].message,style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 16, fontFamily: "SofiaLight"),),
                                                  Text(walletreportApi.walletreportData!.walletitem[index].status,style: TextStyle(color: notifier.greycolor, fontSize: 12, fontFamily: "SofiaLight"),),
                                                ],
                                              ),
                                            ],
                                          ),
                                          walletreportApi.walletreportData!.walletitem[index].status == "Credit" ? Text("+ ${homeApi.homeData!.currency}${walletreportApi.walletreportData!.walletitem[index].amt}", style: TextStyle(fontWeight: FontWeight.w600, color: notifier.lightgreencolor, fontSize: 14, fontFamily: "SofiaLight"),)
                                              : Text("- ${homeApi.homeData!.currency}${walletreportApi.walletreportData!.walletitem[index].amt}", style: TextStyle(fontWeight: FontWeight.w600, color: notifier.redcolor, fontSize: 14, fontFamily: "SofiaLight"),),
                                        ],
                                      ),
                                      const SizedBox(height: 18),
                                    ],
                                  );
                                },),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                  ],
                ),
                SizedBox(height:  walletreportApi.walletreportData!.walletitem.isEmpty ? 20 : 50  ),
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

  Widget paymethodDrawer(){
    return Drawer(
      width: 350,
      backgroundColor: notifier.backgroundColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 40, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Wallet Amount'.tr,
                      style: TextStyle(
                          fontSize: 16,
                          color: notifier.purplecolor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaLight'),
                        overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: mainAmt,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        hintText: "Enter Amount".tr,
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset("assets/Icons/wallet.svg",height: 10,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                        ),
                        contentPadding: const EdgeInsets.only(left: 5),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Select Payment Method'.tr,
                      style: TextStyle(
                          fontSize: 16,
                          color: notifier.purplecolor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaLight'),
                        overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 10),
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
                                        fillColor: MaterialStatePropertyAll(notifier.blackcolor),
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
                      if(mainAmt.text.isEmpty){
                        Fluttertoast.showToast(
                        webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                        msg: "Please enter amount first!",
                        textColor: notifier.blackwhitecolor,
                      );
                    }else if(paymethod == 4) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Paypalwebview(amount: mainAmt.text.toString(),email: logInApi.userData["email"],),));
                      } else {
                        razorPayClass.openCheckout(
                            key: payGetwayApi.paygetwayData!
                                .paymentdata[paymethod].id,
                            amount: mainAmt.text.toString(),
                            number: logInApi.userData["mobile"],
                            name: logInApi.userData["name"],
                            email: logInApi.userData["email"]);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Continue'.tr,
                        style: const TextStyle(
                          fontFamily: 'SofiaLight',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget paymentBottom(){
    return Stack(
      children: [
        SingleChildScrollView(
          child: StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 40, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Enter Wallet Amount'.tr,
                      style: TextStyle(
                          fontSize: 16, 
                          color: notifier.purplecolor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaLight'),
                      overflow: TextOverflow.ellipsis
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: mainAmt,
                    style: TextStyle(fontSize: 14,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                    decoration: InputDecoration(
                      hintText: "Enter Amount".tr,
                      hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset("assets/Icons/wallet.svg",height: 10,colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                      ),
                      contentPadding: const EdgeInsets.only(left: 5),
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Select Payment Method'.tr,
                      style: TextStyle(
                          fontSize: 16,
                          color: notifier.purplecolor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaLight'),
                      overflow: TextOverflow.ellipsis
                  ),
                  const SizedBox(height: 10),
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
                                      fillColor: MaterialStatePropertyAll(notifier.blackcolor),
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
                    mainAmt.text.isEmpty ?  Fluttertoast.showToast(
                      webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                      msg: "Please enter amount first!",
                      textColor: notifier.blackwhitecolor,
                    ) : razorPayClass.openCheckout(
                        key: payGetwayApi.paygetwayData!.paymentdata[paymethod].id,
                        amount: mainAmt.text.toString(),
                        number: logInApi.userData["mobile"],
                        name: logInApi.userData["name"],
                        email: logInApi.userData["email"]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Continue'.tr,
                      style: const TextStyle(
                        fontFamily: 'SofiaLight',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    response.paymentId.toString();
    walletApi.wallet(mainAmt.text.toString()).then((value) {

      walletreportApi.walletReport(context).then((value) {
        showDialog(
          barrierDismissible: false,
          context: context, builder: (context) {
          return Dialog(
            backgroundColor: notifier.whitecolor,
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
                        SvgPicture.asset("assets/Icons/checkedIcon.svg",height: 150,width: 150),
                        RichText(
                            overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Top up".tr,
                            style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22),
                            children: [
                              TextSpan(
                                text: " ${homeApi.homeData!.currency}${mainAmt.text}\n",
                                style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22),
                                children: [
                                  TextSpan(
                                    text: "Successfuly".tr,
                                  style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22)
                                  )
                                ]
                              ),
                            ]
                          ),
                        ),
                        const SizedBox(height: 14,),
                        RichText(
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                          text: "${homeApi.homeData!.currency}${mainAmt.text} ",
                          style: TextStyle(fontFamily: 'SofiaLight',color: notifier.greycolor,fontSize: 14),
                          children: [
                            TextSpan(
                              text: "has been added to your wallet".tr,
                              style: TextStyle(fontFamily: 'SofiaLight',color: notifier.greycolor,fontSize: 14),
                            ),
                          ]
                        ))
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
                              walletreportApi.walletReport(context).then((value) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return const WalletScreen();
                                },));
                              });

                            }, child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text("Done For Now".tr,style: const TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14),overflow: TextOverflow.ellipsis),
                        )),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const WalletScreen();
                            },));
                          },
                          child: Text("Another Top Up".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },);
      });

          // : ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Not done !"), elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //   ),
      // );
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

}
