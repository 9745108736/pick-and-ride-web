
import 'package:get/get.dart';
import 'package:zigzagbus/splash.dart';


class Routes{

  static String initial = "/";
}

final getPages = [
  GetPage(
      name: Routes.initial,
      page: () => const Splash(),
  ),
];