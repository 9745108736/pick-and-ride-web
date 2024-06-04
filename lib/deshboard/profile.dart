import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/apicontroller/profileeditapi.dart';
import 'package:zigzagbus/deshboard/heading.dart';

import '../helper/appbar.dart';
import '../helper/colornotifier.dart';
import '../helper/drawerCommon.dart';
import 'endofpage.dart';

class ProfileandEdit extends StatefulWidget {
  const ProfileandEdit({super.key});

  @override
  State<ProfileandEdit> createState() => _ProfileandEditState();
}

class _ProfileandEditState extends State<ProfileandEdit> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = loginApi.userData["name"];
    email.text = loginApi.userData["email"];
    password.text = loginApi.userData["password"];
    mobile.text = loginApi.userData["mobile"];

  }

  LoginApiController loginApi = Get.put(LoginApiController());
  ProfileEditApi profileeditApi = Get.put(ProfileEditApi());

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();

  final GlobalKey<ScaffoldState> profileKey = GlobalKey();

  late ColorNotifier notifier;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.isDark ? notifier.backgroundColor : notifier.searchgrey,
      key: profileKey,
      endDrawer: const CommonDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: LocalappBar(gkey: profileKey,),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return profile(constraints);
      },),
    );
  }
  Widget profile(constraints){
    return SingleChildScrollView(
      child: constraints.maxHeight < 674 ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              HeadingPage(pageTitle: "Home".tr, nTitle: "My Profile".tr, currentTitle: ""),
              const SizedBox(height: 10),
              constraints.maxWidth < 600 ? Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: name,
                      keyboardType: TextInputType.name,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 12),
                        hintText: 'Enter Name'.tr,
                        hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
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
                    TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 12),
                        hintText: 'Email',
                        hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
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
                    TextField(
                      controller: password,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 12),
                        hintText: "Enter Password".tr,
                        hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                    IntlPhoneField(
                      keyboardType: TextInputType.number,
                      disableLengthCheck: true,
                      controller: mobile,
                      style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 12),
                        hintText: 'Phone Number'.tr,
                        hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: notifier.purplecolor,width: 1),
                        ),
                      ),
                      showCountryFlag: false,
                      showDropdownIcon: false,
                      dropdownTextStyle: TextStyle(fontSize: 14,color: notifier.blackcolor,fontWeight: FontWeight.w600,fontFamily: 'SofiaLight'),
                      initialCountryCode: "IN",
                      onCountryChanged: (value) {
                        // setState(() {
                        //   logInApi.ccode = value.dialCode;
                        // });
                      },
                      onChanged: (phone) {
                        phone = loginApi.userData["ccode"];
                      },
                    ),
                  ],
                ),
              )
                  : Row(
                children: [
                  constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        children: [
                          TextField(
                            controller: name,
                            keyboardType: TextInputType.name,
                            style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 12),
                              hintText: 'Enter Name'.tr,
                              hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
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
                          TextField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 12),
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
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
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        children: [
                          TextField(
                            controller: password,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 12),
                              hintText: "Enter Amount".tr,
                              hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                          IntlPhoneField(
                            keyboardType: TextInputType.number,
                            disableLengthCheck: true,
                            controller: mobile,
                            style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 12),
                              hintText: 'Phone Number'.tr,
                              hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: notifier.purplecolor,width: 1),
                              ),
                            ),
                            showCountryFlag: false,
                            showDropdownIcon: false,
                            dropdownTextStyle: TextStyle(fontSize: 14,color: notifier.blackcolor,fontWeight: FontWeight.w600,fontFamily: 'SofiaLight'),
                            initialCountryCode: "IN",
                            onCountryChanged: (value) {
                              // setState(() {
                              //   logInApi.ccode = value.dialCode;
                              // });
                            },
                            onChanged: (phone) {
                              phone = loginApi.userData["ccode"];
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                ],
              ),
              const SizedBox(height: 10,),
              constraints.maxWidth < 600 ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(0),
                          backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          )
                      ),
                      onPressed: () {
                        profileeditApi.profileEdit(context, name.text, email.text, password.text).then((value) {
                          loginApi.getlocaldata().then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const ProfileandEdit();
                            },));
                          });
                        });
                      }, child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                    child: Text("Confirm".tr,style: const TextStyle(fontFamily: "SofiaLight", fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                  )),
                ),
              )
                  : Center(
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(0),
                        backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                        shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        )
                    ),
                    onPressed: () {
                      profileeditApi.profileEdit(context, name.text, email.text, password.text).then((value) {
                        loginApi.getlocaldata().then((value) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const ProfileandEdit();
                          },));
                        });
                      });
                    }, child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                  child: Text("Confirm".tr,style: const TextStyle(fontFamily: "SofiaLight", fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                )),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Container(
              alignment: Alignment.bottomCenter,
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
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                HeadingPage(pageTitle: "Home".tr, nTitle: "My Profile".tr, currentTitle: ""),
                const SizedBox(height: 10),
                constraints.maxWidth < 600 ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        controller: name,
                        keyboardType: TextInputType.name,
                        style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 12),
                          hintText: 'Enter Name'.tr,
                          hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
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
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 12),
                          hintText: 'Email',
                          hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
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
                      TextField(
                        controller: password,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 12),
                          hintText: "Enter Password".tr,
                          hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                      IntlPhoneField(
                        keyboardType: TextInputType.number,
                        disableLengthCheck: true,
                        controller: mobile,
                        style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 12),
                          hintText: 'Phone Number'.tr,
                          hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: notifier.purplecolor,width: 1),
                          ),
                        ),
                        showCountryFlag: false,
                        showDropdownIcon: false,
                        dropdownTextStyle: TextStyle(fontSize: 14,color: notifier.blackcolor,fontWeight: FontWeight.w600,fontFamily: 'SofiaLight'),
                        initialCountryCode: "IN",
                        onCountryChanged: (value) {
                          // setState(() {
                          //   logInApi.ccode = value.dialCode;
                          // });
                        },
                        onChanged: (phone) {
                          phone = loginApi.userData["ccode"];
                        },
                      ),
                    ],
                  ),
                )
                    : Row(
                  children: [
                    constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            TextField(
                              controller: name,
                              keyboardType: TextInputType.name,
                              style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 12),
                                hintText: 'Enter Name'.tr,
                                hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
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
                            TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 12),
                                hintText: 'Enter Email',
                                hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Column(
                          children: [
                            TextField(
                              controller: password,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 12),
                                hintText: "Enter Amount".tr,
                                hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontFamily: 'SofiaLight'),
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
                            IntlPhoneField(
                              keyboardType: TextInputType.number,
                              disableLengthCheck: true,
                              controller: mobile,
                              style: TextStyle(fontSize: 16,color: notifier.blackcolor,fontFamily: 'SofiaLight'),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 12),
                                hintText: 'Phone Number'.tr,
                                hintStyle: TextStyle(fontSize: 14,color: notifier.subgreycolor,fontFamily: 'SofiaLight'),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade400,width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: notifier.purplecolor,width: 1),
                                ),
                              ),
                              showCountryFlag: false,
                              showDropdownIcon: false,
                              dropdownTextStyle: TextStyle(fontSize: 14,color: notifier.blackcolor,fontWeight: FontWeight.w600,fontFamily: 'SofiaLight'),
                              initialCountryCode: "IN",
                              onCountryChanged: (value) {
                                // setState(() {
                                //   logInApi.ccode = value.dialCode;
                                // });
                              },
                              onChanged: (phone) {
                                phone = loginApi.userData["ccode"];
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    constraints.maxWidth < 1000 ? const SizedBox() : const Spacer(),
                  ],
                ),
                const SizedBox(height: 10,),
                constraints.maxWidth < 600 ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: const MaterialStatePropertyAll(0),
                            backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            )
                        ),
                        onPressed: () {
                          profileeditApi.profileEdit(context, name.text, email.text, password.text).then((value) {
                            loginApi.getlocaldata().then((value) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const ProfileandEdit();
                              },));
                            });
                          });
                        }, child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                      child: Text("Confirm".tr,style: const TextStyle(fontFamily: "SofiaLight", fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                    )),
                  ),
                )
                    : Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(0),
                          backgroundColor: MaterialStatePropertyAll(notifier.purplecolor),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          )
                      ),
                      onPressed: () {
                        profileeditApi.profileEdit(context, name.text, email.text, password.text).then((value) {
                          loginApi.getlocaldata().then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const ProfileandEdit();
                            },));
                          });
                        });
                      }, child: Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                    child: Text("Confirm".tr,style: const TextStyle(fontFamily: "SofiaLight", fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                  )),
                ),
                const SizedBox(height: 20),
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
}
