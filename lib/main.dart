
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:zigzagbus/helper/routes.dart';

import 'deshboard/scrolling.dart';
import 'helper/colornotifier.dart';
import 'helper/helperwidget/languagetran.dart';
// import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDUaDOXKWaHeg61_Y1Yx4kJSBkdbABVKiQ",
            appId: "1:319710447950:web:73c22fdb6e7af7c6a2f61f",
            messagingSenderId: "319710447950",
            projectId: "redbus-3ec46"));
  }
  // await Firebase.initializeApp();
  // final prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  // final SharedPreferences _prefs;
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ColorNotifier()),
        // ChangeNotifierProvider(create: (context) => LocaleModel(widget._prefs)),
      ],
      builder: (context, child) {
        return GetMaterialApp(
          locale: const Locale('en', 'US'),
          translations: LocalString(),
          debugShowCheckedModeBanner: false,
          title: 'zigzagbus',
          scrollBehavior: MyCustomScrollerBehavior(),
          theme: ThemeData(
            useMaterial3: false,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            dividerColor: Colors.transparent,
          ),
          initialRoute: Routes.initial,
          getPages: getPages,
          // home: const Splash(),
        );
      },
    );
  }
}

// class MyCustomScrollBehavior extends MaterialScrollBehavior {
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//         PointerDeviceKind.touch,
//         PointerDeviceKind.mouse,
//       };
// }

// class AppTranslations extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => {
//         'en_US': {
//           'enter_mail': 'Enter your email',
//         },
//         'ur_PK': {
//           'enter_mail': 'اپنا ای میل درج کریں۔',
//         }
//       };
// }
