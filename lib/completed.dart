import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Phlebo_Completed extends StatefulWidget {
  @override
  _Phlebo_Completed createState() => _Phlebo_Completed();
}

class _Phlebo_Completed extends State<Phlebo_Completed> {
  Widget Application_Widget(var data, BuildContext context) {
    phone() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          content: Container(
            height: 25,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_in_talk,
                        size: 20, color: Color.fromARGB(255, 54, 244, 79)),
                    MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        data.customer_mobile_no,
                        style: TextStyle(
                            color: Color.fromARGB(255, 54, 244, 79),
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Getprint(obj) async {
    //   var url = globals.API_url +
    //       '/index.html?bill_id=' +
    //       obj.toString() +
    //       '&Connection=' +
    //       globals.Connection_Flag +
    //       '&Client_name=' +
    //       globals.Client_Name.toString() +
    //       '&Logo=' +
    //       globals.Logo.toString();
    //   '';
    //   if (await canLaunch(url)) {
    //     await launch(url);
    //     //window.close();
    //   } else {
    //     throw globals.Connection_Flag + obj.toString();
    //   }
    // }
    Getprint(obj) async {
      String encodedPart = base64.encode(utf8.encode(
        'bill_id=' +
            obj.toString() +
            '&Connection=' +
            globals.Connection_Flag +
            '&Client_name=' +
            globals.Client_Name +
            '&Logo=' +
            globals.Logo,
      ));

      // Construct the full URL
      String url = '${globals.API_url}/index.html?$encodedPart';

      // Launch the URL
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Failed to launch URL: ${globals.Connection_Flag} $obj';
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String dynamicText =
        data.test_name; // Replace this with your dynamic incoming text

    List<String> parts = dynamicText.split(',');
    Widget textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts.map((part) {
        return Text(
          part,
          style: TextStyle(fontSize: 10, color: Colors.black),
        );
      }).toList(),
    );

    // void openWhatsApp(String phoneNumber, String message) async {
    //   String url =
    //       "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeFull(message)}";

    //   if (await canLaunch(url)) {
    //     await launch(url);
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // }
    Future<bool> _showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Are you sure?',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text("Do you want to exit the App?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Stay in app
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Trigger exit
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );

  if (result == true) {
    SystemNavigator.pop(); // ✅ Exit the app
  }

  return Future.value(false); // Prevent default back behavior
}


    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: 250,
          height: height / 2.7,
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          data.patient_name.length <= 40
                              ? MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.patient_name.toString()))
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.patient_name
                                      .substring(0, 40)
                                      .toString()),
                                ),
                          Spacer(),
                          SizedBox(
                            height: 30,
                            child: IconButton(
                                onPressed: () {
                                  // openWhatsApp("918050809995",
                                  //     " Getprint(data.order_id);");

                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0))),
                                      contentPadding: EdgeInsets.only(
                                          top: 20.0, left: 10.0, right: 10.0),
                                      content: Container(
                                        height: height / 2,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: height / 3.5,
                                                child: Card(
                                                  elevation: 6,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 10.0,
                                                                top: 5),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .person),
                                                                data.patient_name
                                                                            .length <=
                                                                        18
                                                                    ? MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            data.patient_name
                                                                                .toString(),
                                                                            style:
                                                                                TextStyle(fontSize: 11)),
                                                                      )
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            data.patient_name.substring(0, 18).toString(),
                                                                            style: TextStyle(fontSize: 11)),
                                                                      ),
                                                                Spacer(),
                                                                MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          textScaleFactor:
                                                                              1.0),
                                                                  child: Text(
                                                                      data.customer_age.toString().split(',')[
                                                                              0] +
                                                                          " Years,",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11)),
                                                                ),
                                                                data.customer_gender
                                                                            .toString() ==
                                                                        "1"
                                                                    ? MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            "Male",
                                                                            style:
                                                                                TextStyle(fontSize: 11)),
                                                                      )
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            "Female",
                                                                            style:
                                                                                TextStyle(fontSize: 12)),
                                                                      ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(""),
                                                                Spacer(),
                                                                InkWell(
                                                                  onTap: () {
                                                                    String
                                                                        Number =
                                                                        data.customer_mobile_no;
                                                                    _callNumber(
                                                                        Number);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .phone_in_talk,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .blue[200],
                                                                      ),
                                                                      MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            data.customer_mobile_no
                                                                                .toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.blue[200],
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                data.BOOKING_DT ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          "Booked Date:",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                Spacer(),
                                                                data.BOOKING_DT ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          data.BOOKING_DT
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                data.APPOINTMENT_DT ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          "Schedule Date:",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                Spacer(),
                                                                data.APPOINTMENT_DT ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          data.APPOINTMENT_DT
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                data.collection_dt ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          "Collection Date:",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                Spacer(),
                                                                data.collection_dt ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          data.collection_dt
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 10.0,
                                                          right: 10.0,
                                                          top: 5.0,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                data.CHANNEL ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(data
                                                                            .REFERAL_DOCTOR
                                                                            .toString()),
                                                                      ),
                                                                data.CHANNEL ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(data
                                                                            .REFERAL_DOCTOR
                                                                            .toString()),
                                                                      )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 10.0,
                                                                top: 5),
                                                        child: Container(
                                                          height: 40,
                                                          child: MediaQuery(
                                                            data: MediaQuery.of(
                                                                    context)
                                                                .copyWith(
                                                                    textScaleFactor:
                                                                        1.0),
                                                            child: Text(data
                                                                .customer_address
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: Text(
                                                        "Test Details",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: height / 6,
                                                  width: width / 1,
                                                  child: Card(
                                                    elevation: 6,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                //workgoing
                                                                Container(
                                                                  width: 150,
                                                                  child: MediaQuery(
                                                                      data: MediaQuery.of(context).copyWith(
                                                                          textScaleFactor:
                                                                              1.0),
                                                                      child:
                                                                          textWidget),
                                                                ),
                                                                Spacer(),
                                                                MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          textScaleFactor:
                                                                              1.0),
                                                                  child: Text(
                                                                    '\u{20B9} ' +
                                                                        data.net_amount
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.menu_sharp,
                                  color: Colors.blue,
                                )),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(data.order_no.toString())),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              String Number = data.customer_mobile_no;
                              _callNumber(Number);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_in_talk,
                                  size: 15,
                                  color: Colors.blue[200],
                                ),
                                MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child:
                                      Text(data.customer_mobile_no.toString(),
                                          style: TextStyle(
                                            color: Colors.blue[200],
                                          )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          data.BOOKING_DT == "null"
                              ? Container()
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text("Booked Date:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                          Spacer(),
                          data.BOOKING_DT == null
                              ? Container()
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.BOOKING_DT.toString(),
                                      style: TextStyle(fontSize: 12)),
                                )
                        ],
                      ),
                      Row(
                        children: [
                          data.APPOINTMENT_DT == null
                              ? Container()
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text("Schedule Date:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                          Spacer(),
                          data.APPOINTMENT_DT == null
                              ? Container()
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.APPOINTMENT_DT.toString(),
                                      style: TextStyle(fontSize: 12)),
                                )
                        ],
                      ),
                      Row(
                        children: [
                          data.collection_dt == null
                              ? Container()
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text("Collection Date:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                          Spacer(),
                          data.collection_dt == null
                              ? Container()
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.collection_dt.toString(),
                                      style: TextStyle(fontSize: 12)),
                                )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 5.0,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          data.CHANNEL == null
                              ? Container()
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.CHANNEL.toString())),
                          data.REFERAL_DOCTOR == null
                              ? Container()
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.REFERAL_DOCTOR.toString()))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                  child: Container(
                    height: 30,
                    child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text(data.customer_address.toString())),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    color: Color.fromARGB(255, 167, 175, 169),
                    height: 60,
                    child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // TextButton(
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (context) => New_Order(),
                            //           ));
                            //     },
                            //     child: Row(
                            //       children: [
                            //         Icon(Icons.plus_one_rounded),
                            //         MediaQuery(
                            //           data: MediaQuery.of(context)
                            //               .copyWith(textScaleFactor: 1.0),
                            //           child: Text(
                            //             "New Orders",
                            //             style:
                            //                 TextStyle(fontFamily: 'Fjalla One'),
                            //           ),
                            //         )
                            //       ],
                            //     )),

                            TextButton(
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0))),
                                      contentPadding: EdgeInsets.only(
                                          top: 20.0, left: 10.0, right: 10.0),
                                      content: Container(
                                        height: height / 2,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: height / 3.5,
                                                child: Card(
                                                  elevation: 6,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 10.0,
                                                                top: 5),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .person),
                                                                data.patient_name
                                                                            .length <=
                                                                        18
                                                                    ? MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            data.patient_name
                                                                                .toString(),
                                                                            style:
                                                                                TextStyle(fontSize: 11)),
                                                                      )
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            data.patient_name.substring(0, 18).toString(),
                                                                            style: TextStyle(fontSize: 11)),
                                                                      ),
                                                                Spacer(),
                                                                MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          textScaleFactor:
                                                                              1.0),
                                                                  child: Text(
                                                                      data.customer_age.toString().split(',')[
                                                                              0] +
                                                                          " Years,",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11)),
                                                                ),
                                                                data.customer_gender
                                                                            .toString() ==
                                                                        "1"
                                                                    ? MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            "Male",
                                                                            style:
                                                                                TextStyle(fontSize: 11)),
                                                                      )
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            "Female",
                                                                            style:
                                                                                TextStyle(fontSize: 12)),
                                                                      ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(""),
                                                                Spacer(),
                                                                InkWell(
                                                                  onTap: () {
                                                                    String
                                                                        Number =
                                                                        data.customer_mobile_no;
                                                                    _callNumber(
                                                                        Number);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .phone_in_talk,
                                                                        size:
                                                                            15,
                                                                        color: Colors
                                                                            .blue[200],
                                                                      ),
                                                                      MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(
                                                                            data.customer_mobile_no
                                                                                .toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.blue[200],
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 10.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                data.BOOKING_DT ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          "Booked Date:",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                Spacer(),
                                                                data.BOOKING_DT ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          data.BOOKING_DT
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                data.APPOINTMENT_DT ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          "Schedule Date:",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                Spacer(),
                                                                data.APPOINTMENT_DT ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          data.APPOINTMENT_DT
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                data.collection_dt ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          "Collection Date:",
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      ),
                                                                Spacer(),
                                                                data.collection_dt ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Text(
                                                                          data.collection_dt
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 12),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 10.0,
                                                          right: 10.0,
                                                          top: 5.0,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                data.CHANNEL ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(data
                                                                            .REFERAL_DOCTOR
                                                                            .toString()),
                                                                      ),
                                                                data.CHANNEL ==
                                                                        null
                                                                    ? Container()
                                                                    : MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child: Text(data
                                                                            .REFERAL_DOCTOR
                                                                            .toString()),
                                                                      )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 10.0,
                                                                top: 5),
                                                        child: Container(
                                                          height: 40,
                                                          child: MediaQuery(
                                                            data: MediaQuery.of(
                                                                    context)
                                                                .copyWith(
                                                                    textScaleFactor:
                                                                        1.0),
                                                            child: Text(data
                                                                .customer_address
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: Text(
                                                        "Test Details",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: height / 6,
                                                  width: width / 1,
                                                  child: Card(
                                                    elevation: 6,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                //workgoing
                                                                Container(
                                                                  width: 150,
                                                                  child: MediaQuery(
                                                                      data: MediaQuery.of(context).copyWith(
                                                                          textScaleFactor:
                                                                              1.0),
                                                                      child:
                                                                          textWidget),
                                                                ),
                                                                Spacer(),
                                                                MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          textScaleFactor:
                                                                              1.0),
                                                                  child: Text(
                                                                    '\u{20B9} ' +
                                                                        data.net_amount
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.menu_open_sharp),
                                    MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(
                                        "Bill Details",
                                        style:
                                            TextStyle(fontFamily: 'Fjalla One'),
                                      ),
                                    ),
                                  ],
                                )),

                            TextButton(
                                onPressed: () {
                                  Getprint(data.order_id);
                                },
                                child: Row(
                                  children: [Icon(Icons.picture_as_pdf)],
                                ))
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView Application_ListView(data, BuildContext context) {
    if (data != null) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Application_Widget(data[index], context);
          });
    }
    return ListView(
      shrinkWrap: true,
    );
  }

  Future<List<Data_Model>> _fetchSaleTransaction() async {
    var jobsListAPIUrl = null;
    var dsetName = '';
    List listresponse = [];

    Map data = {
      "tokenno": globals.PASSWORD,
      "userid": globals.USER_ID,
      "billno": "",
      "fromdt": globals.selectDate == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : globals.selectDate,
      "todt": globals.selectDate == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : globals.selectDate,
      "patientname": "",
      "flagnew": "",
      "connection": globals.Connection_Flag
    };

    dsetName = 'result';
    jobsListAPIUrl = Uri.parse(globals.API_url +
        '/mobile/api/PhleboHomeCollection/GetPhleboMobileCompletedOrders');

    var response = await http.post(jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      List jsonResponse = resposne["result"];

      return jsonResponse.map((strans) => Data_Model.fromJson(strans)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Widget verticalList3 = Container(
      color: Color.fromARGB(255, 101, 140, 178),
      child: FutureBuilder<List<Data_Model>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              return SizedBox(child: Application_ListView(data, context));
            } else if (snapshot.hasError) {
              return NoContent3();
            }

            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );
    return Container(child: verticalList3);
  }
}

class Data_Model {
  final collectio_id;
  final create_by;
  final collection_no;
  final collection_dt;
  final APPOINTMENT_DT;
  final order_id;
  final CLINICAL_HISTORY;
  final remarks;
  final lab_no;
  final patient_name;
  final test_name;
  final net_amount;
  final customer_age;
  final customer_mobile_no;
  final customer_gender;
  final BOOKING_DT;
  final order_no;
  final customer_address;
  final DUE_AMOUNT;
  final CLIENT_NAME;
  final CHANNEL;
  final REFERAL_DOCTOR;
  final REFERAL_SOURCE_ID;
  final TEMP_REF_DOC_ID;
  final AREA_ALLOCATED;
  final UMR_NO;
  final AENCY_ARAE_ID;
  final EMAIL_ID;
  final EMPLOYEE_ID;
  final CLIET_ID;
  final UID;
  final LOC_ID;

  Data_Model({
    required this.collectio_id,
    required this.create_by,
    required this.collection_no,
    required this.collection_dt,
    required this.APPOINTMENT_DT,
    required this.order_id,
    required this.CLINICAL_HISTORY,
    required this.remarks,
    required this.lab_no,
    required this.patient_name,
    required this.test_name,
    required this.net_amount,
    required this.customer_age,
    required this.customer_mobile_no,
    required this.customer_gender,
    required this.BOOKING_DT,
    required this.order_no,
    required this.customer_address,
    required this.DUE_AMOUNT,
    required this.CLIENT_NAME,
    required this.CHANNEL,
    required this.REFERAL_DOCTOR,
    required this.REFERAL_SOURCE_ID,
    required this.TEMP_REF_DOC_ID,
    required this.AREA_ALLOCATED,
    required this.UMR_NO,
    required this.AENCY_ARAE_ID,
    required this.EMAIL_ID,
    required this.EMPLOYEE_ID,
    required this.CLIET_ID,
    required this.UID,
    required this.LOC_ID,
  });

  factory Data_Model.fromJson(Map<String, dynamic> json) {
    return Data_Model(
      collectio_id: json['collectio_id'],
      create_by: json['create_by'],
      collection_no: json['collection_no'],
      collection_dt: json['collection_dt'],
      APPOINTMENT_DT: json['APPOINTMENT_DT'],
      order_id: json['order_id'],
      CLINICAL_HISTORY: json['CLINICAL_HISTORY'],
      remarks: json['remarks'],
      lab_no: json['lab_no'],
      patient_name: json['patient_name'],
      test_name: json['test_name'],
      net_amount: json['net_amount'],
      customer_age: json['customer_age'],
      customer_mobile_no: json['customer_mobile_no'],
      customer_gender: json['customer_gender'],
      BOOKING_DT: json['BOOKING_DT'],
      order_no: json['order_no'],
      customer_address: json['customer_address'],
      DUE_AMOUNT: json['DUE_AMOUNT'],
      CLIENT_NAME: json['CLIENT_NAME'],
      CHANNEL: json['CHANNEL'],
      REFERAL_DOCTOR: json['REFERAL_DOCTOR'],
      REFERAL_SOURCE_ID: json['REFERAL_SOURCE_ID'],
      TEMP_REF_DOC_ID: json['TEMP_REF_DOC_ID'],
      AREA_ALLOCATED: json['AREA_ALLOCATED'],
      UMR_NO: json['UMR_NO'],
      AENCY_ARAE_ID: json['AENCY_ARAE_ID'],
      EMAIL_ID: json['EMAIL_ID'],
      EMPLOYEE_ID: json['EMPLOYEE_ID'],
      CLIET_ID: json['CLIET_ID'],
      UID: json['UID'],
      LOC_ID: json['LOC_ID'],
    );
  }
}

class NoContent3 extends StatelessWidget {
  const NoContent3();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.verified_rounded,
              color: Colors.red,
              size: 50,
            ),
            const Text('No Data Found'),
          ],
        ),
      ),
    );
  }
}

_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}
