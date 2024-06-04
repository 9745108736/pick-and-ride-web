import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zigzagbus/apicontroller/loginapicontroller.dart';
import 'package:zigzagbus/deshboard/deshboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'apicontroller/homeapi.dart';
import 'helper/colornotifier.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print("><><><><><><><><><><><><><${homeApi.homeData!.tickethistory}");
    logInApi.getlocaldata().then((value) {
      homeApi.homepage().then((value) {
        initialization();
      });
    });

  }


  HomeApiController homeApi = Get.put(HomeApiController());
  LoginApiController logInApi = Get.put(LoginApiController());

  void initialization() async {
    await Future.delayed(
      const Duration(seconds: 3),
          () {
        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (context) {
              return const deshscreen();
            }
          ),
        );
      },
    );
  }
  late ColorNotifier notifier;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.whitecolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/logo/zigzagLogo.svg',height: 100),
            Text('Zigzag',style: TextStyle(fontSize: 28,fontFamily: 'SofiaBold',color: notifier.purplecolor),),
            const SizedBox(height: 20),
            SpinKitFadingCircle(
              color: notifier.isDark ? notifier.lightPurplecolor : notifier.purplecolor,//ustomize the color
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
