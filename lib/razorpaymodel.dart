import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';

class RazorPayClass{

  Razorpay _razorpay = Razorpay();

  openCheckout({required String key, required String amount, required String number, required String name, required String email}){

    var options = {
      'key': "rzp_test_oyEnEu70MpsDyP",
      'amount': (double.parse(amount.toString()) * 100).toString().split(".").first,
      'name': name,
      'description': '',
      'retry': {'enabled': true,'max_count': 1},
      'prefill': {
        'contact': number,
        'email': email,
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  initiateRazorPay({required Function handlePaymentSuccess, required Function handlePaymentError, required Function handleExternalWallet}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  desposRazorPay() {
    _razorpay.clear();
  }
}