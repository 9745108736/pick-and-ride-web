
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../config.dart';

class Paypalwebview extends StatefulWidget {
  final String amount;
  final String email;
  const Paypalwebview({super.key, required this.amount, required this.email});

  @override
  State<Paypalwebview> createState() => _PaypalwebviewState();
}

class _PaypalwebviewState extends State<Paypalwebview> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  String amount = "";
  String email = "";
  // final PlatformWebViewController _controller = ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            onWebViewCreated: (InAppWebViewController controller) {
            },
            initialUrlRequest: URLRequest(
              url: Uri.parse("${Config.paymentUrl}flutterwave/index.php?amt=${widget.amount}&email=${widget.email}"),
            ),
            onLoadStart: (controller, url) {
              // _setupJavaScriptCommunication();
            },
            onLoadStop: (controller, url) {
            },
          )
        ],
      ),
    );
  }
  // Widget paypal(){
  //   return Stack(
  //     children: [
  //       PlatformWebViewWidget(
  //         PlatformWebViewWidgetCreationParams(
  //           controller: PlatformWebViewController(
  //             const PlatformWebViewControllerCreationParams(),
  //           )..loadRequest(
  //             LoadRequestParams(
  //               uri: Uri.parse("${Config.paymentUrl + "/flutterwave/index.php?amt=${widget.amount}&email=${widget.email}"}"),
  //             ),
  //           ).then((value) => (value) {
  //             Navigator.push(context, MaterialPageRoute(builder: (context) => deshscreen(),));
  //           }),
  //         ),
  //       ).build(context),
  //     ],
  //   );
  // }
}
