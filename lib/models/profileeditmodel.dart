// To parse this JSON data, do
//
//     final profileEditModel = profileEditModelFromJson(jsonString);

import 'dart:convert';

ProfileEditModel profileEditModelFromJson(String str) => ProfileEditModel.fromJson(json.decode(str));

String profileEditModelToJson(ProfileEditModel data) => json.encode(data.toJson());

class ProfileEditModel {
  UserLogin userLogin;
  String responseCode;
  String result;
  String responseMsg;

  ProfileEditModel({
    required this.userLogin,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory ProfileEditModel.fromJson(Map<String, dynamic> json) => ProfileEditModel(
    userLogin: UserLogin.fromJson(json["UserLogin"]),
    responseCode: json["ResponseCode"],
    result: json["Result"],
    responseMsg: json["ResponseMsg"],
  );

  Map<String, dynamic> toJson() => {
    "UserLogin": userLogin.toJson(),
    "ResponseCode": responseCode,
    "Result": result,
    "ResponseMsg": responseMsg,
  };
}

class UserLogin {
  String id;
  String name;
  String mobile;
  String password;
  DateTime rdate;
  String status;
  String ccode;
  String code;
  dynamic refercode;
  String wallet;
  String email;
  String userType;
  String isVerify;

  UserLogin({
    required this.id,
    required this.name,
    required this.mobile,
    required this.password,
    required this.rdate,
    required this.status,
    required this.ccode,
    required this.code,
    required this.refercode,
    required this.wallet,
    required this.email,
    required this.userType,
    required this.isVerify,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) => UserLogin(
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
    password: json["password"],
    rdate: DateTime.parse(json["rdate"]),
    status: json["status"],
    ccode: json["ccode"],
    code: json["code"],
    refercode: json["refercode"],
    wallet: json["wallet"],
    email: json["email"],
    userType: json["user_type"],
    isVerify: json["is_verify"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "password": password,
    "rdate": rdate.toIso8601String(),
    "status": status,
    "ccode": ccode,
    "code": code,
    "refercode": refercode,
    "wallet": wallet,
    "email": email,
    "user_type": userType,
    "is_verify": isVerify,
  };
}
