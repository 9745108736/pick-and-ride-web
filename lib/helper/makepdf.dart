import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:zigzagbus/apicontroller/ticketdetailsapi.dart';

Future<Uint8List> makePdf({tickethistory, currency, netImage}) async{

  TicketDetailsApi tickethistoryApi = Get.put(TicketDetailsApi());

  final pdf = Document();
  // final netImage = await networkImage('${Config.baseUrl}${tickethistoryApi.ticketDetailsData!.tickethistory[0].busImg}');
  // final netImage = await networkImage(Config.imageBaseUrl + tickethistoryApi.ticketDetailsData!.tickethistory[0].busImg);
  // final busImage = await networkImage("${Config.baseUrl}${tickethistoryApi.ticketDetailsData!.tickethistory[0].busImg}");
  final netImage1 = await networkImage(tickethistoryApi.ticketDetailsData!.tickethistory[0].qrcode);
  final imageLogo = MemoryImage((await rootBundle.load('assets/Group3.png')).buffer.asUint8List());
  final imageLogo1 = MemoryImage((await rootBundle.load('assets/AutoLayoutHorizontal.png')).buffer.asUint8List());
  final imageLogo2 = MemoryImage((await rootBundle.load('assets/Rectangle_2.png')).buffer.asUint8List());

  pdf.addPage(
    MultiPage(build: (context) {
      return [
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Wrap(
            children: [
              Container(
                decoration: const BoxDecoration(
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Image(imageLogo2,height: 30),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Qr Code'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                // color: notifier.textColor
                              )),
                          Spacer(),
                          RichText(
                            text: TextSpan(
                               text: "Ticket Id".tr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              children: [
                                TextSpan(
                                  text: ":- ${tickethistoryApi.ticketDetailsData!.tickethistory[0].ticketId}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    )
                                )
                              ]
                            ),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15,bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                Image(netImage1,height: 150),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image(imageLogo2,height: 30),
                              SizedBox(width: 10,),
                              Container(
                                  height: 30,
                                  width: 30,
                                  child: ClipRRect(
                                    horizontalRadius: 25,
                                    verticalRadius: 20,
                                    // child: Image(netImage, fit: BoxFit.fill)
                                  ),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].busName,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,letterSpacing: 1
                                  ),
                                  ),
                                  Row(
                                    children: [
                                      tickethistoryApi.ticketDetailsData!.tickethistory[0].isAc ==
                                          "0"
                                          ? Text(
                                          'Non AC'.tr,
                                          style: const TextStyle(
                                            fontSize: 8,
                                          ))
                                          : Text(
                                          'AC',
                                          style: const TextStyle(
                                            fontSize: 8,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text('$currency ${tickethistoryApi.ticketDetailsData!.tickethistory[0].subtotal}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].boardingCity,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(convertTimeTo12HourFormat(tickethistoryApi.ticketDetailsData!.tickethistory[0].busPicktime),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),maxLines: 1),
                            ],
                          ),
                          SizedBox(width: 10,),
                          Column(
                            children: [
                              Image(imageLogo1,height: 20,width: 100),
                              SizedBox(height: 5),
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].differencePickDrop,style: const TextStyle(fontSize: 8,),)
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].dropCity,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(convertTimeTo12HourFormat(tickethistoryApi.ticketDetailsData!.tickethistory[0].busDroptime),style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),maxLines: 1),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].subPickPlace,style: const TextStyle(fontSize: 10,),maxLines: 1),
                          Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].boardingCity,style: const TextStyle(fontSize: 10,),maxLines: 1),
                          SizedBox(height: 12,),
                          Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].subPickMobile.toString().split(',').first,style: const TextStyle(fontSize: 10),maxLines: 1),
                          SizedBox(height: tickethistoryApi.ticketDetailsData!.tickethistory[0].subPickMobile.isEmpty ? 0 : 8,),
                          Text(convertTimeTo12HourFormat(tickethistoryApi.ticketDetailsData!.tickethistory[0].subPickTime),style: const TextStyle(fontSize: 8,),maxLines: 1),
                        ],
                      ),
                      Image(imageLogo,height: 50,width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].subDropPlace, style: const TextStyle(fontSize: 10,),maxLines: 1),
                          Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].dropCity, style: const TextStyle(fontSize: 10,),maxLines: 1),
                          SizedBox(height: 12,),
                          SizedBox(height: tickethistoryApi.ticketDetailsData!.tickethistory[0].subPickMobile.isEmpty ? 0 : 8,),
                          Text(convertTimeTo12HourFormat(tickethistoryApi.ticketDetailsData!.tickethistory[0].subDropTime),style: const TextStyle(fontSize: 8,),maxLines: 1),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Image(imageLogo2,height: 30),
                          SizedBox(width: 10,),
                          Text("Tansaction Details".tr, style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Booking Date".tr,style: const TextStyle(fontSize: 10,),maxLines: 1,),
                              SizedBox(height: 12,),
                              Text("Payment Method".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text("Transaction Id".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text("Ticket Id".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].bookDate.toString().split(' ').first, style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].pMethodName, style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].transactionId,style: const TextStyle(fontSize: 10),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].ticketId,style: const TextStyle(fontSize: 10),maxLines: 1),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50,),
              Container(
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Image(imageLogo2,height: 30),
                          SizedBox(width: 10,),
                          Text("Passanger(S)".tr,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: FixedColumnWidth(300),
                          // 1: FixedColumnWidth(40),
                          // 2: FixedColumnWidth(40),
                          // 3: FixedColumnWidth(40),
                        },
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              Text('Name'.tr,style: const TextStyle(fontSize: 10),),
                              Center(child: Text('Age'.tr,style: const TextStyle(fontSize: 10,),),),
                              SizedBox(width: 20),
                              Center(child: Text('Seat'.tr,style: const TextStyle(fontSize: 10,),),),
                            ],
                          ),
                          for( int a = 0; a < tickethistoryApi.ticketDetailsData!.tickethistory[0].orderProductData.length; a++) TableRow(
                              children: <Widget>[
                                Text('${tickethistoryApi.ticketDetailsData!.tickethistory[0].orderProductData[a].name}(${tickethistoryApi.ticketDetailsData!.tickethistory[0].orderProductData[a].gender})',style: const TextStyle(fontSize: 10),),
                                Center(child: Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].orderProductData[a].age,style: const TextStyle(fontSize: 10),)),
                                SizedBox(width: 20),
                                Center(child: Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].orderProductData[a].seatNo,style: const TextStyle(fontSize: 10),)),
                              ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Image(imageLogo2,height: 30),
                          SizedBox(width: 10,),
                          Text("Contact Details".tr,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Full Name".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text("Email".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text("Phone Number".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].contactName, style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].contactEmail, style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].contactMobile,style: const TextStyle(fontSize: 10,),maxLines: 1),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              tickethistoryApi.ticketDetailsData!.tickethistory[0].driverName.isEmpty ? SizedBox() : Container(
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Image(imageLogo2,height: 30),
                          SizedBox(width: 10,),
                          Text("Driver Details".tr,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Full Name".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text("Phone Number".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text("Bus Number".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].driverName, style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].driverMobile, style: const TextStyle(fontSize: 10,),maxLines: 1),
                              SizedBox(height: 12,),
                              Text(tickethistoryApi.ticketDetailsData!.tickethistory[0].busNo,style: const TextStyle(fontSize: 10,),maxLines: 1),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Image(imageLogo2,height: 30),
                          SizedBox(width: 10,),
                          Text("Price Details".tr,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Price".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                                  SizedBox(height: 12,),
                                  RichText(
                                    text: TextSpan(
                                      text: "Tax".tr,
                                        style: const TextStyle(fontSize: 10,),
                                      children: [
                                        TextSpan(
                                          text: "(${tickethistoryApi.ticketDetailsData!.tickethistory[0].tax}%)",
                                          style: const TextStyle(fontSize: 10,),
                                        )
                                      ]
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  Text("Discount".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                                  SizedBox(height: 12,),
                                  Text("Wallet".tr,style: const TextStyle(fontSize: 10,),maxLines: 1),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("$currency${tickethistoryApi.ticketDetailsData!.tickethistory[0].total}", style: const TextStyle(fontSize: 10,),maxLines: 1),
                                  SizedBox(height: 12,),
                                  Text("$currency${tickethistoryApi.ticketDetailsData!.tickethistory[0].taxAmt}", style: const TextStyle(fontSize: 10,),maxLines: 1),
                                  SizedBox(height: 12,),
                                  Text("$currency${tickethistoryApi.ticketDetailsData!.tickethistory[0].couAmt}",style: const TextStyle(fontSize: 10,),maxLines: 1),
                                  SizedBox(height: 12,),
                                  Text("$currency${tickethistoryApi.ticketDetailsData!.tickethistory[0].wallAmt}",style: const TextStyle(fontSize: 10),maxLines: 1),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Divider(),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Price".tr,style: const TextStyle(fontSize: 12,),maxLines: 1),
                              Text("$currency${tickethistoryApi.ticketDetailsData!.tickethistory[0].subtotal}",style: const TextStyle(fontSize: 10,),maxLines: 1),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ),
      ];
    },)
  );
  return pdf.save();
}

String convertTimeTo12HourFormat(String time24Hour) {
  // Parse the input time in 24-hour format
  final inputFormat = DateFormat('HH:mm:ss');
  final inputTime = inputFormat.parse(time24Hour);

  // Format the time in 12-hour format
  final outputFormat = DateFormat('h:mm a');
  final formattedTime = outputFormat.format(inputTime);

  return formattedTime;
}