// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/colornotifier.dart';
import '../mediaquery/mq.dart';

class endofpage extends StatefulWidget {
  const endofpage({super.key});

  @override
  State<endofpage> createState() => _endofpageState();
}

class _endofpageState extends State<endofpage> {
  late ColorNotifier notifier;

  List logos = [
    'assets/logo/linkedinIcon.png',
    'assets/logo/twitterIcon.png',
    'assets/logo/facebookIcon.png',
    'assets/logo/instagram.png',
    'assets/logo/pinterest.png',
    'assets/logo/youtube.png',
    'assets/logo/twitch.png',
    'assets/logo/skype.png',
  ];

  bool tfHover = false;

  List contactsImage = [
    'assets/Icons/emailicon.svg',
    'assets/Icons/phoneicon.svg',
    'assets/Icons/gpsicon.svg'
  ];
  List contacts = [
    'hello@prozigzag.com',
    ' +91 123456789',
    'India'
  ];


  List<Uri> urls = [
    Uri.parse("https://www.linkedin.com/feed/"),
    Uri.parse( "https://twitter.com/?lang=en"),
    Uri.parse("https://www.facebook.com/Meta"),
    Uri.parse("https://www.instagram.com/"),
    Uri.parse("https://in.pinterest.com/"),
    Uri.parse("https://www.youtube.com/"),
    Uri.parse("https://www.twitch.tv/"),
    Uri.parse("https://www.skype.com/en/")
  ];

  List<bool> elementsHover = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 900 ? eop(constraints) : Align(alignment: Alignment.bottomCenter,child: largeScreen(constraints));
      },
    );
  }

  Widget eop(constraints) {
    return Column(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/logo/zigzagLogo.svg',
                                  height: constraints.maxWidth < 300 ? 27 : 35),
                              const SizedBox(width: 5),
                              Text(
                                'ZigZag',
                                style: TextStyle(
                                    fontFamily: 'SofiaLight',
                                    fontWeight: FontWeight.w700,
                                    color: notifier.purplecolor,
                                    fontSize: constraints.maxWidth < 300 ? 16 : 24),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxWidth < 300 ? 10 : 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/Icons/lightbulbicon.png',
                                  height: constraints.maxWidth < 300 ? 14 : 20,
                                  color: notifier.subgreycolor),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                'Dark theme'.tr,
                                style: TextStyle(
                                    fontFamily: 'SofiaLight',
                                    fontSize: constraints.maxWidth < 300 ? 12 : 14,
                                    color: notifier.subgreycolor,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              SizedBox(
                                height: 29,
                                child: FlutterSwitch(
                                  height: 23.0,
                                  width: constraints.maxWidth < 300 ? 40.0 : 45.0,
                                  padding: 4.0,
                                  toggleSize: 16.0,
                                  borderRadius: 15.0,
                                  inactiveToggleColor: notifier.buttoncolor,
                                  activeColor: notifier.buttoncolor,
                                  inactiveColor: notifier.sugestionbutton,
                                  value: notifier.isDark,
                                  onToggle: (bool value) {
                                    setState(() {
                                      notifier.isAvailable(value);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                          width: width / 1,
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(contactsImage[index],
                                      height: 20),
                                  const SizedBox(width: 10),
                                  Text(contacts[index],
                                      style: TextStyle(
                                          fontFamily: 'SofiaLight',
                                          fontWeight: FontWeight.w600,
                                          color: notifier.subgreycolor,
                                          fontSize: 16)),
                                  const SizedBox(width: 20),
                                ],
                              );
                            },
                          )),
                    ]),
              const SizedBox(height: 30),
              Divider(
                color: notifier.isDark
                    ? notifier.subgreycolor
                    : notifier.sugestionbutton,
              ),
              const SizedBox(height: 30),
              Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        // width: 300,
                        child: ListView.builder(
                          itemCount: logos.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: notifier.subgreycolor,
                                      ),
                                    ),
                                    child: index == 1 ? Image.asset(logos[index], color: notifier.blackcolor,height: 16)
                                        : Image.asset(logos[index],height: 16),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Copyright © Make it Zigzag\n| Designed by Make it Services - Powered by Zigzag',
                        style: TextStyle(
                            fontSize: constraints.maxWidth < 500 ? 12 : 14,
                            fontFamily: 'SofiaLight',
                            fontWeight: FontWeight.w600,
                            color: notifier.isDark
                                ? notifier.subgreycolor
                                : notifier.blackcolor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
  Widget largeScreen(constraints){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/logo/zigzagLogo.svg',
                height: 35),
            const SizedBox(width: 5),
            Text(
              'Zigzag',
              style: TextStyle(
                fontFamily: 'SofiaLight',
                fontWeight: FontWeight.w700,
                color: notifier.purplecolor,
                fontSize: 24,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: contacts.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(contactsImage[index], height: 20),
                    const SizedBox(width: 10),
                    Text(contacts[index],
                        style: TextStyle(
                            fontFamily: 'SofiaLight',
                            color: notifier.subgreycolor,
                            fontSize: 16)),
                    const SizedBox(width: 20),
                  ],
                );
              },
            )),
        const SizedBox(height: 30),
        Divider(
          color: notifier.isDark
              ? notifier.subgreycolor
              : notifier.sugestionbutton,
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 40,
          // width: 300,
          child: ListView.builder(
            itemCount: logos.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  InkWell(
                    onTap: () async {
                      if (!await launchUrl(urls[index])) {
                      throw Exception('Could not launch ${urls[index]}');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: notifier.sugestionbutton,
                        ),
                      ),
                      child: index == 1 ? Image.asset(logos[index], color: notifier.blackcolor,height: 16)
                          : Image.asset(logos[index],height: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Copyright © Make it Zigzag\n| Designed by Make it Services - Powered by Zigzag',
          style: TextStyle(
              fontSize: constraints.maxWidth < 300 ? 10 : 14,
              fontFamily: 'SofiaLight',
              fontWeight: FontWeight.w600,
              color: notifier.isDark
                  ? notifier.subgreycolor
                  : notifier.blackcolor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
