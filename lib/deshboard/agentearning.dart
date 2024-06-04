import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/apicontroller/payoutlistapi.dart';
import 'package:zigzagbus/apicontroller/requestwithdrawapi.dart';
import 'package:zigzagbus/deshboard/wallet.dart';

import '../apicontroller/homeapi.dart';
import '../apicontroller/loginapicontroller.dart';
import '../apicontroller/paygetvayapi.dart';
import '../apicontroller/walletapi.dart';
import '../apicontroller/walletreportapi.dart';
import '../helper/appbar.dart';
import '../helper/colornotifier.dart';
import '../helper/drawerCommon.dart';
import 'endofpage.dart';
import 'heading.dart';

class AgentEarning extends StatefulWidget {
  const AgentEarning({super.key});

  @override
  State<AgentEarning> createState() => _AgentEarningState();
}

class _AgentEarningState extends State<AgentEarning> {

  late ColorNotifier notifier;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      for( int a = 0; a < payoutListApi.payoutData!.payoutlist.length; a++){
        payoutListApi.isLoading ? CircularProgressIndicator(color: notifier.purplecolor) : details.add(false);
      }
  }
  final GlobalKey<ScaffoldState> earningKey = GlobalKey();

  HomeApiController homeApi = Get.put(HomeApiController());
  WalletApi walletApi = Get.put(WalletApi());
  PayGetwayApi payGetwayApi = Get.put(PayGetwayApi());
  LoginApiController logInApi = Get.put(LoginApiController());
  final GlobalKey<ScaffoldState> walletKey = GlobalKey();
  WalletReportApi walletreportApi = Get.put(WalletReportApi());
  PayoutListApi payoutListApi = Get.put(PayoutListApi());
  RequestWithdrawApi requestWithdrawApi = Get.put(RequestWithdrawApi());

  List<bool> details = [];
  List<String> withdrawTypeList = ["UPI", "BANK Transfer", "Paypal"];
  String? withdrawType;
  TextEditingController mainAmt = TextEditingController();
  TextEditingController upiId = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController holderName = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController emailId = TextEditingController();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.isDark ? notifier.backgroundColor : notifier.searchgrey,
      key: earningKey,
      endDrawer: LayoutBuilder(
          builder: (context, constraints) {
            return const CommonDrawer();
          }
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: LocalappBar(gkey: earningKey,),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return earningStatus(constraints);
      },),
    );
  }
  Widget earningStatus(constraints){
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              HeadingPage(pageTitle: "Home".tr,nTitle: "My Wallet".tr,currentTitle: "My Earning".tr,),
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
                                        Text("My Earning".tr, style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                                        InkWell(
                                          onTap: () {
                                            Get.to(const WalletScreen());
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 2.0),
                                                child: Text("My Wallet".tr, style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 14,),overflow: TextOverflow.ellipsis,),
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
                                  constraints.maxWidth < 680 ? Padding(
                                    padding:  EdgeInsets.only(left: constraints.maxWidth < 600 ? 20 : constraints.maxWidth < 1000 ? 50 : 100, right: constraints.maxWidth < 600 ? 20 : constraints.maxWidth < 1000 ? 50 : 100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: notifier.whitecolor,
                                        border: Border.all(color: notifier.sugestionbutton),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Lottie.asset("assets/lottie/wallet.json",height: 80),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("TOTAL EARNING BALANCE".tr,style: TextStyle(fontFamily: "SofiaLight", color: notifier.greycolor, fontSize: 16),overflow: TextOverflow.ellipsis,),
                                                        Text("${homeApi.homeData!.currency} ${walletreportApi.walletreportData!.agentEarning}",style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 20, fontWeight: FontWeight.w600),),
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
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context, builder: (context) {
                                                        return Dialog(
                                                          elevation: 0,
                                                          backgroundColor: notifier.whitecolor,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          child: SizedBox(
                                                              child: withdraw()),
                                                        );
                                                      },);
                                                    }, child: Padding(
                                                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset("assets/Icons/Uploadicon.svg",height: 20,),
                                                      const SizedBox(width: 10),
                                                      Text("Withdraw".tr,style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 16),overflow: TextOverflow.ellipsis,),
                                                    ],
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                      : Padding(
                                    padding:  EdgeInsets.only(left: constraints.maxWidth < 1000 ? 50 : 100, right: constraints.maxWidth < 1000 ? 50 : 100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: notifier.whitecolor,
                                        border: Border.all(color: notifier.sugestionbutton),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
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
                                                        Text("TOTAL EARNING BALANCE".tr,style: TextStyle(fontFamily: "SofiaLight", color: notifier.greycolor, fontSize: 16),overflow: TextOverflow.ellipsis,),
                                                        Text("${homeApi.homeData!.currency} ${walletreportApi.walletreportData!.agentEarning}",style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 20, fontWeight: FontWeight.w600),),
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
                                                      showDialog(
                                                        barrierDismissible: false,
                                                        context: context, builder: (context) {
                                                        return Dialog(
                                                          elevation: 0,
                                                          backgroundColor: notifier.whitecolor,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          child: SizedBox(
                                                              child: withdraw()),
                                                        );
                                                      },);
                                                    }, child: Padding(
                                                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset("assets/Icons/Uploadicon.svg",height: 20,),
                                                      const SizedBox(width: 10),
                                                      Text("Withdraw".tr,style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 16),overflow: TextOverflow.ellipsis,),
                                                    ],
                                                  ),
                                                ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Transaction Details".tr,style: TextStyle(fontFamily: "SofiaLight", fontSize: 18, color: notifier.blackcolor, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                              const SizedBox(height: 12),
                              payoutListApi.isLoading ? const SingleChildScrollView() : ListView.builder(
                                shrinkWrap: true,
                                itemCount: payoutListApi.payoutData!.payoutlist.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if(details[index] == false){
                                              details[index] = true;
                                            } else {
                                              details[index] = false;
                                            }
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                               payoutListApi.payoutData!.payoutlist[index].status == "completed"
                                                    ? SvgPicture.asset("assets/Icons/puplewalletIcon.svg",height: 45,)
                                                    : SvgPicture.asset("assets/Icons/yellowwalletIcon.svg",height: 45,),
                                                const SizedBox(width: 8),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(payoutListApi.payoutData!.payoutlist[index].status,style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 16, fontFamily: "SofiaLight"),),
                                                    const SizedBox(height: 5),
                                                    Text(payoutListApi.payoutData!.payoutlist[index].rDate.toString().split(' ').first,style: TextStyle(color: notifier.greycolor, fontSize: 12, fontFamily: "SofiaLight"),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                payoutListApi.payoutData!.payoutlist[index].status == "completed" ? Text("${homeApi.homeData!.currency}${payoutListApi.payoutData!.payoutlist[index].amt}", style: TextStyle(fontWeight: FontWeight.w600, color: notifier.lightgreencolor, fontSize: 14, fontFamily: "SofiaLight"),)
                                                    : Text("${homeApi.homeData!.currency}${payoutListApi.payoutData!.payoutlist[index].amt}", style: TextStyle(fontWeight: FontWeight.w600, color: notifier.lightgreencolor, fontSize: 14, fontFamily: "SofiaLight"),),
                                                Icon(Icons.arrow_forward_ios, color: notifier.blackcolor,size: 10,)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      details[index] ? Column(
                                        children: [
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Payout Id".tr,style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),overflow: TextOverflow.ellipsis,),
                                              Text(payoutListApi.payoutData!.payoutlist[index].payoutId,style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Amount".tr,style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),overflow: TextOverflow.ellipsis,),
                                              Text("${homeApi.homeData!.currency}${payoutListApi.payoutData!.payoutlist[index].amt}",style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Pay by".tr,style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),overflow: TextOverflow.ellipsis,),
                                              Text("${payoutListApi.payoutData!.payoutlist[index].rType}(${payoutListApi.payoutData!.payoutlist[index].upiId})",style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Request Date".tr,style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),overflow: TextOverflow.ellipsis,),
                                              Text(payoutListApi.payoutData!.payoutlist[index].rDate.toString(),style: TextStyle(fontWeight: FontWeight.w600, color: notifier.blackcolor, fontSize: 14, fontFamily: "SofiaLight"),),
                                            ],
                                          ),
                                        ],
                                      ) : const SizedBox(),
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
              const SizedBox(height: 20),
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
    );
  }
  Widget withdraw(){
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: withdrawType == "UPI" ? 380 : withdrawType == "BANK Transfer" ? 660 : withdrawType == "Paypal" ? 380 : 300,
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Payout Request".tr,style: TextStyle(fontSize: 16, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                const SizedBox(height: 20),
                RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                  text: "Minimum amount".tr,
                    style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight',),
                  children: [
                    TextSpan(
                      text: ": ${homeApi.homeData!.currency}10",
                      style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight',),
                    )
                  ]
                )),
                const SizedBox(height: 10),
                TextField(
                  controller: mainAmt,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(fontSize: 16, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                     errorBorder: OutlineInputBorder(borderSide: BorderSide(color: notifier.redcolor)),

                    hintText: "Enter Amount".tr,
                    hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                const SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Type".tr, style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16,),overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      // margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        // color: notifier.textColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton(
                        iconDisabledColor: Colors.transparent,
                        iconEnabledColor: Colors.transparent,
                        value: withdrawType,
                        isExpanded: true,
                        icon: SvgPicture.asset("assets/Icons/inboxuploadIcon.svg",height: 18, colorFilter: ColorFilter.mode(notifier.blackcolor, BlendMode.srcIn,),),
                        dropdownColor: notifier.whitecolor,
                        hint: Text(
                          "Select Type".tr,
                          style: TextStyle(color: notifier.blackcolor),
                        ),
                        focusColor: notifier.whitecolor,
                        underline: const SizedBox.shrink(),
                        items: withdrawTypeList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: notifier.blackcolor,
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                          onChanged: (value) {
                            setState(() {
                              withdrawType = value!;
                            });
                          },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                withdrawType == "UPI" ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text("UPI", style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16,),),
                    const SizedBox(height: 10),
                    TextField(
                      controller: upiId,
                      style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "UPI",
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                  ],
                )
                    : withdrawType == "BANK Transfer" ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text("Account Number".tr, style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16,),),
                    const SizedBox(height: 10),
                    TextField(
                      controller: accountNumber,
                      style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "Account Number".tr,
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                    const SizedBox(height: 10),
                    Text("Bank Name".tr, style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16,),overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 10),
                    TextField(
                      controller: bankName,
                      style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "Bank Name".tr,
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                    const SizedBox(height: 10),
                    Text("Account Holder Name".tr, style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16,),overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 10),
                    TextField(
                      controller: holderName,
                      style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "Account Holder Name".tr,
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                    const SizedBox(height: 10),
                    Text("IFSC Code", style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16,),),
                    const SizedBox(height: 10),
                    TextField(
                      controller: ifscCode,
                      style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: "IFSC Code",
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                    const SizedBox(height: 10),
                  ],
                )
                    : withdrawType == "Paypal" ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text("Email Id".tr, style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 16,),),
                        const SizedBox(height: 10),
                        TextField(
                        controller: emailId,
                        style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                        hintText: "Enter your Email".tr,
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                      ],
                    )
                    : const SizedBox(),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      autofocus: false,
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        elevation: const MaterialStatePropertyAll(0),
                      ),
                      onPressed: () {
                        Get.back();
                      }, child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                      child: Text("Cancel".tr,style: TextStyle(fontFamily: "SofiaLight", color: notifier.blackcolor, fontSize: 14,),overflow: TextOverflow.ellipsis,),
                    ),),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        elevation: const MaterialStatePropertyAll(0),
                      ),
                        onPressed: () {
                          int.parse(mainAmt.text.toString()) <= 10 ? requestWithdrawApi.requestWithdraw(mainAmt.text.toString(), withdrawType,  accountNumber.text.toString(), bankName.text.toString(), holderName.text.toString(), ifscCode.text.toString(), upiId.text.toString(), emailId.text.toString()).then((value) {
                            Fluttertoast.showToast(
                              msg: value,
                            );
                            // Get.to(const AgentEarning());
                            payoutListApi.payoutList().then((value) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AgentEarning(),));
                            });
                          }) : Fluttertoast.showToast(
                            webBgColor: notifier.isDark ? "linear-gradient(to right, #ffffff, #ffffff)" : "linear-gradient(to right, #000000, #000000)" ,
                            msg: "Please enter the amount less then 10.".tr,
                            textColor: notifier.blackwhitecolor,
                          );
                    }, child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                      child: Text("Proceed".tr,style: const TextStyle(fontFamily: "SofiaLight", color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                    ),),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
