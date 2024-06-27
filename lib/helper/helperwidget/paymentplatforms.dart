
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:zigzagbus/apicontroller/bookinghistory.dart';
import 'package:zigzagbus/apicontroller/bookticketapi.dart';
import 'package:zigzagbus/apicontroller/homeapi.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/apicontroller/paygetvayapi.dart';
import 'package:zigzagbus/config.dart';
import 'package:zigzagbus/paymentwebview/paypalwebview.dart';
import 'package:zigzagbus/razorpaymodel.dart';

import '../../deshboard/deshboard.dart';
import '../../deshboard/myticket.dart';
import '../../mediaquery/mq.dart';
import '../../models/bookinghmodel.dart';
import '../colornotifier.dart';

class PaymentPlatform extends StatefulWidget {
  final double amount;
  final int index2;
  final String contactEmail;
  final String contactNumber;
  final String contactName;
  final List detailName;
  final List detailAge;
  final List gender;
  final String dropPlace;
  final String pickPlace;
  final List seatnumber;
  final List dataName;
  final List dataAge;
  final Map pickData;
  final Map dropData;
  final String couponAmt;
  final List passengerData;
  final String taxAmt;
  final String commision;
  final String walletAmt;
  final double mainAmt;

  const PaymentPlatform(
      {super.key,
      required this.amount,
      required this.index2,
      required this.contactEmail,
      required this.contactNumber,
      required this.contactName,
      required this.detailName,
      required this.detailAge,
      required this.gender,
      required this.dropPlace,
      required this.pickPlace,
      required this.seatnumber,
      required this.dataName,
      required this.dataAge,
      required this.pickData,
      required this.dropData,
      required this.couponAmt,
      required this.passengerData,
      required this.taxAmt,
      required this.commision,
      required this.walletAmt, required this.mainAmt});

  @override
  State<PaymentPlatform> createState() => _PaymentPlatformState();
}

class _PaymentPlatformState extends State<PaymentPlatform> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorPayClass.initiateRazorPay(
        handlePaymentSuccess: handlePaymentSuccess,
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet);

  }

  late ColorNotifier notifier;

  double mainAmt = 0;
  int paymethod = 0;

  PayGetwayApi payGetwayApi = Get.put(PayGetwayApi());
  LoginApiController logInApi = Get.put(LoginApiController());
  BookTicketApi bookTicketApi = Get.put(BookTicketApi());
  BookingHistoryApi bookingHApi = Get.put(BookingHistoryApi());

  int index = 0;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
                      'Select Payment Method'.tr,
                      style: TextStyle(
                          fontSize: 16,
                          color: notifier.purplecolor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SofiaLight'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                      if(paymethod == 4) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Paypalwebview(amount: widget.mainAmt.toString(),email: logInApi.userData["email"],),));
                      } else {
                      razorPayClass.openCheckout(
                      key: payGetwayApi.paygetwayData!.paymentdata[paymethod].id,
                      amount: widget.mainAmt.toString(),
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

  RazorPayClass razorPayClass = RazorPayClass();
  HomeApiController homeApi = Get.put(HomeApiController());
  void handlePaymentSuccess(PaymentSuccessResponse response) {
    loading = false;
    mainAmt = widget.mainAmt + double.parse(widget.walletAmt);
    String payMethodId = payGetwayApi.paygetwayData!.paymentdata[0].id;
    String orderId = response.paymentId.toString();

    bookTicketApi.bookTicket(
        // context,
        widget.index2,
        widget.walletAmt,
        widget.pickPlace,
        widget.dropPlace,
        widget.amount.toStringAsFixed(2),
        widget.couponAmt,
        orderId,
        payMethodId,
        widget.pickData,
        widget.dropData,
        widget.passengerData,
        widget.taxAmt,
        widget.seatnumber,
        widget.commision,
        mainAmt.toStringAsFixed(2).toString(),
        widget.contactName,
      widget.contactNumber,
      widget.contactEmail
    ).then((value) {

      value == "true" ? showDialog(
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
                      Lottie.asset("assets/lottie/ticket-confirm.json",height: 150,width: 150),
                      Text("Booking Confirmed!".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22)),
                      const SizedBox(height: 14,),
                      Text("Congratulation! your bus ticket is confirmed. For more details check the My Booking tab.".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),maxLines: 2,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
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
                            bookingHApi.bookinghistory(context, "Pending").then((value) {
                              setState(() {
                                bookingHApi.bookingHData = bookingHistoryModelFromJson(value);
                              });
                              bookingHApi.bookinghistory(context, "Completed").then((value) {
                                setState(() {
                                  bookingHApi.bookingHDataComp =  bookingHistoryModelFromJson(value);
                                });
                                bookingHApi.bookinghistory(context, "cancel").then((value) {
                                  setState(() {
                                    bookingHApi.bookingHDataCanc =  bookingHistoryModelFromJson(value);
                                    homeApi.homepage().then((value) {
                                      Get.to(const Mytickets());
                                    });
                                  });
                                });
                              });
                            });

                          }, child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("View Transaction".tr,style: const TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14)),
                      )),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          homeApi.homepage().then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const deshscreen();
                            },));
                          });

                        },
                        child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },)
          : ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookTicketApi.bookTicketData!.responseMsg), elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}

class PayMethods extends StatefulWidget {
  final double amount;
  final int index2;
  final String contactEmail;
  final String contactNumber;
  final String contactName;
  final List detailName;
  final List detailAge;
  final List gender;
  final String dropPlace;
  final String pickPlace;
  final List seatnumber;
  final List dataName;
  final List dataAge;
  final Map pickData;
  final Map dropData;
  final String couponAmt;
  final List passengerData;
  final String taxAmt;
  final String commision;
  final String walletAmt;
  final double mainAmt;
  const PayMethods({super.key, required this.mainAmt, required this.amount, required this.index2, required this.contactEmail, required this.contactNumber, required this.contactName, required this.detailName, required this.detailAge, required this.gender, required this.dropPlace, required this.pickPlace, required this.seatnumber, required this.dataName, required this.dataAge, required this.pickData, required this.dropData, required this.couponAmt, required this.passengerData, required this.taxAmt, required this.commision, required this.walletAmt});

  @override
  State<PayMethods> createState() => _PayMethodsState();
}

class _PayMethodsState extends State<PayMethods> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    razorPayClass.initiateRazorPay(
        handlePaymentSuccess: handlePaymentSuccess,
        handlePaymentError: handlePaymentError,
        handleExternalWallet: handleExternalWallet);

  }

  late ColorNotifier notifier;
  int paymethod = 0;
  double mainAmt = 0;
  bool loading = true;

  PayGetwayApi payGetwayApi = Get.put(PayGetwayApi());
  RazorPayClass razorPayClass = RazorPayClass();
  HomeApiController homeApi = Get.put(HomeApiController());
  LoginApiController logInApi = Get.put(LoginApiController());
  BookTicketApi bookTicketApi = Get.put(BookTicketApi());
  BookingHistoryApi bookingHApi = Get.put(BookingHistoryApi());

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
      width = MediaQuery.of(context).size.width;
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
                    'Select Payment Method'.tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: notifier.purplecolor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SofiaLight'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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

                    razorPayClass.openCheckout(
                        key: payGetwayApi
                            .paygetwayData!.paymentdata[paymethod].id,
                        amount: widget.mainAmt.toString(),
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
    );
  }
  void handlePaymentSuccess(PaymentSuccessResponse response) {
    loading = false;
    mainAmt = widget.mainAmt + double.parse(widget.walletAmt);
    String payMethodId = payGetwayApi.paygetwayData!.paymentdata[0].id;
    String orderId = response.paymentId.toString();

    bookTicketApi.bookTicket(
      // context,
        widget.index2,
        widget.walletAmt,
        widget.pickPlace,
        widget.dropPlace,
        widget.amount.toStringAsFixed(2),
        widget.couponAmt,
        orderId,
        payMethodId,
        widget.pickData,
        widget.dropData,
        widget.passengerData,
        widget.taxAmt,
        widget.seatnumber,
        widget.commision,
        mainAmt.toStringAsFixed(2).toString(),
        widget.contactName,
        widget.contactNumber,
        widget.contactEmail
    ).then((value) {

      value == "true" ? showDialog(
        barrierDismissible: false,
        context: context, builder: (context) {
        return Dialog(
          backgroundColor: notifier.backgroundColor,
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
                      Lottie.asset("assets/lottie/ticket-confirm.json",height: 150,width: 150),
                      Text("Booking Confirmed!".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.purplecolor,fontSize: 22)),
                      const SizedBox(height: 14,),
                      Text("Congratulation! your bus ticket is confirmed. For more details check the My Booking tab.",style: TextStyle(fontFamily: 'SofiaLight',color: notifier.blackcolor,fontSize: 14),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
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
                            bookingHApi.bookinghistory(context, "Pending").then((value) {
                              setState(() {
                                bookingHApi.bookingHData = bookingHistoryModelFromJson(value);
                              });
                              bookingHApi.bookinghistory(context, "Completed").then((value) {
                                setState(() {
                                  bookingHApi.bookingHDataComp =  bookingHistoryModelFromJson(value);
                                });
                                bookingHApi.bookinghistory(context, "cancel").then((value) {
                                  setState(() {
                                    bookingHApi.bookingHDataCanc =  bookingHistoryModelFromJson(value);
                                    homeApi.homepage().then((value) {
                                      Get.to(const Mytickets());
                                    });
                                  });
                                });
                              });
                            });

                          }, child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("View Transaction".tr,style: TextStyle(fontFamily: 'SofiaLight',fontWeight: FontWeight.w600,color: notifier.whitecolor,fontSize: 14)),
                      )),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          homeApi.homepage().then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const deshscreen();
                            },));
                          });

                        },
                        child: Text("Back to Home".tr,style: TextStyle(fontFamily: 'SofiaLight',color: notifier.purplecolor,fontSize: 14),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },)
          : ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bookTicketApi.bookTicketData!.responseMsg), elevation: 0, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
}
