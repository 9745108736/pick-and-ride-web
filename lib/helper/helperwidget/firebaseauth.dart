// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';

class FirebaseAuthentication {
  String phoneNumber = "";

  sendOTP(String phoneNumber) async {
    this.phoneNumber = phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(
        '+91 $phoneNumber',
        RecaptchaVerifier(auth: FirebaseAuthWeb.instance)
    );
    printMessage("OTP Sent to +91 $phoneNumber");

    // Get the verification ID
    // String verificationId = confirmationResult.verificationId;
    // print("Verification ID: $verificationId");

    return confirmationResult;
  }

  Future authenticateMe(ConfirmationResult confirmationResult, String otp) async {

    try {
      // Confirm the OTP
      UserCredential userCredential = await confirmationResult.confirm(otp);

      // If the confirmation is successful, userCredential will contain the user information
      // You can perform further actions here, such as signing in the user or getting user data
      // For example:
      if (userCredential.additionalUserInfo!.isNewUser == false) {
        // User is signed in
        return true;
      } else {
        return false;
        // User is not signed in
      }
    } catch (e) {
      // If the OTP confirmation fails, handle the error here
      // You might want to notify the user about the invalid OTP and provide them with the opportunity to retry
      return null;
    }

  }

  printMessage(String msg) {
    debugPrint(msg);
  }
}