import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:zigzagbus/deshboard/deshboard.dart';
import 'package:zigzagbus/deshboard/wallet.dart';
import 'package:zigzagbus/search/searchbus.dart';

import '../helper/colornotifier.dart';
import '../helper/filldetails.dart';

class HeadingPage extends StatefulWidget {
  final String pageTitle;
  final String nTitle;
  final String currentTitle;
  const HeadingPage({super.key, required this.pageTitle, required this.nTitle, required this.currentTitle});

  @override
  State<HeadingPage> createState() => _HeadingPageState();
}

class _HeadingPageState extends State<HeadingPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return heading(constraints);
    },);
  }
  Widget heading(constraints){
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    return Column(
      children: [
        Row(
          children: [
            constraints.maxWidth < 1000
                ? const SizedBox()
                : const Spacer(),
            Expanded(
              flex: constraints.maxWidth < 1000 ? 7 : 5,
              child: Padding(
                padding: EdgeInsets.only(left: constraints.maxWidth < 1000 ? 20 : 0, right: constraints.maxWidth < 1000 ? 20 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: const MaterialStatePropertyAll(0),
                            backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
                            padding: const MaterialStatePropertyAll(EdgeInsets.all(18)),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: notifier.sugestionbutton, width: 2)
                              ),
                            ),
                          ),
                            onPressed: () {
                             Get.to(const deshscreen());
                        }, child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.keyboard_arrow_left_rounded,size: 20, color: notifier.blackcolor,),
                            const SizedBox(width: 5,),
                            Text( "Go Home".tr,style: TextStyle(fontSize: 14, color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w600)),
                          ],
                        )),
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 12,),
                              InkWell(
                                  onTap: () {
                                    widget.pageTitle == "Home".tr ? Get.to(const deshscreen()) : widget.pageTitle == "Search Bus".tr ? Get.to(const SearchBuses()) : Get.back();
                                  },
                                  child: Text(widget.pageTitle,style: TextStyle(fontFamily: 'SofiaLight', color: widget.nTitle.isNotEmpty ? notifier.subgreycolor : CupertinoColors.systemGrey2, fontWeight: FontWeight.w600, fontSize: 14),)),
                              const SizedBox(width: 12,),
                              widget.nTitle.isNotEmpty ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Icon(Icons.keyboard_arrow_right_rounded,color: notifier.subgreycolor,size: 20),
                              ) : const SizedBox(),
                              SizedBox(width: widget.nTitle.isNotEmpty ? 12 : 0,),
                              widget.currentTitle.isNotEmpty ? InkWell(
                                onTap: () {
                                  widget.currentTitle == "My Wallet".tr ? Get.to(const WalletScreen())  : Get.back();
                                },
                                  child: Text(widget.nTitle,style: TextStyle(fontFamily: 'SofiaLight', color: widget.currentTitle.isNotEmpty ? notifier.subgreycolor : CupertinoColors.systemGrey2, fontWeight: FontWeight.w600, fontSize: 14),overflow: TextOverflow.ellipsis))
                              : Text(widget.nTitle,style: const TextStyle(fontFamily: 'SofiaLight', color: CupertinoColors.systemGrey2, fontWeight: FontWeight.w600, fontSize: 14),overflow: TextOverflow.ellipsis),
                              const SizedBox(width: 12,),
                              widget.currentTitle.isNotEmpty ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Icon(Icons.keyboard_arrow_right_rounded,color: notifier.subgreycolor,size: 20),
                              ) : const SizedBox(),
                              SizedBox(width: widget.nTitle.isNotEmpty ? 12 : 0,),
                              widget.currentTitle.isNotEmpty ? Text(widget.currentTitle,style: const TextStyle(fontFamily: 'SofiaLight', color: CupertinoColors.systemGrey2, fontWeight: FontWeight.w600, fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1,) : const SizedBox(),

                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                  widget.nTitle == "My Wallet" ? const SizedBox() : (widget.nTitle.isNotEmpty && widget.currentTitle.isEmpty) ? Text(widget.nTitle, style: TextStyle(color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w800,fontSize: 40),overflow: TextOverflow.ellipsis)
                   : Text(widget.currentTitle, style: TextStyle(color: notifier.blackcolor, fontFamily: 'SofiaLight', fontWeight: FontWeight.w800,fontSize: 40),overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
            constraints.maxWidth < 1000
                ? const SizedBox()
                : const Spacer(),
          ],
        ),
      ],
    );
  }
}
