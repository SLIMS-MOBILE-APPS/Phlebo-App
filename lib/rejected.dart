import 'package:flutter/material.dart';
import 'package:im_stepper/main.dart';
import 'package:im_stepper/stepper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Phlebo_Rejected extends StatefulWidget {
  @override
  _Phlebo_Rejected createState() => _Phlebo_Rejected();
}

class _Phlebo_Rejected extends State<Phlebo_Rejected> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 5; // Initial step set to 5.
  DateTime selectedDate = DateTime.now();
  int upperBound = 6; // upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    Widget Application_Widget(var data, BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 210,
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
                            data.patient_name.length <= 35
                                ? Text(data.patient_name)
                                : Text(data.patient_name.substring(0, 40)),
                            Spacer(),
                            SizedBox(
                              height: 30,
                              child: IconButton(
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
                                        // title: const Text(
                                        //     'AlertDialog Title'),
                                        //title: SizedBox(height: 10),
                                        content: Container(
                                          // color: Colors.blue[100],
                                          height: 400,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 187,
                                                  child: Card(
                                                    elevation: 6,
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                                      ? Text(data
                                                                          .patient_name)
                                                                      : Text(data
                                                                          .patient_name
                                                                          .substring(
                                                                              0,
                                                                              18)),
                                                                  Spacer(),
                                                                  Text(data
                                                                          .customer_age
                                                                          .split(
                                                                              ',')[0] +
                                                                      " Years,"),
                                                                  data.customer_gender
                                                                              .toString() ==
                                                                          "1"
                                                                      ? Text(
                                                                          "Male")
                                                                      : Text(
                                                                          "Female"),
                                                                ],
                                                              ),
                                                              InkWell(
                                                                // onTap: () {
                                                                // Navigator.push(
                                                                //   context,
                                                                //   MaterialPageRoute(
                                                                //       builder: (context) => DoctorHome(0)),
                                                                // );
                                                                // },
                                                                child: Row(
                                                                  children: [
                                                                    Text(data
                                                                        .order_no),
                                                                    Spacer(),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        String
                                                                            Number =
                                                                            data.customer_mobile_no;
                                                                        _callNumber(
                                                                            Number);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.phone_in_talk,
                                                                            size:
                                                                                15,
                                                                            color:
                                                                                Colors.blue[200],
                                                                          ),
                                                                          Text(
                                                                              data.customer_mobile_no,
                                                                              style: TextStyle(
                                                                                color: Colors.blue[200],
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
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
                                                                  Text(
                                                                    "Booked Date:",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    data.BOOKING_DT,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Schedule Date:",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    data.collection_dt,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
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
                                                            child: Text(
                                                                data
                                                                    .customer_address,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12)),
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
                                                      Text(
                                                        "Test Details",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 150,
                                                    width: 250,
                                                    child: Card(
                                                      elevation: 6,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: 150,
                                                                  child: Text(
                                                                    "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  '\u{20B9} ' +
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Reason:",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child: Text(
                                                                    data.REASON_NAME,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(),
                                                          ],
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
                                    color: Colors.blue[200],
                                  )),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(data.order_no),
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
                                  Text(data.customer_mobile_no,
                                      style: TextStyle(
                                        color: Colors.blue[200],
                                      ))
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
                            Text("Booked Date:"),
                            Spacer(),
                            Text(data.BOOKING_DT)
                          ],
                        ),
                        Row(
                          children: [
                            Text("Schedule Date:"),
                            Spacer(),
                            Text(data.collection_dt)
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                    child: Container(
                      height: 30,
                      child: Text(data.customer_address),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: Container(
                                  width: 220,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Reason:"),
                                      Text(
                                        data.REASON_NAME,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Fjalla One'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
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
                                            top: 20.0, left: 20.0, right: 20.0),
                                        // title: const Text(
                                        //     'AlertDialog Title'),
                                        //title: SizedBox(height: 10),
                                        content: Container(
                                          // color: Colors.blue[100],
                                          height: 550,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 170,
                                                  child: Card(
                                                    elevation: 6,
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                                          15
                                                                      ? Text(data
                                                                          .patient_name)
                                                                      : Text(data
                                                                          .patient_name
                                                                          .substring(
                                                                              0,
                                                                              15)),
                                                                  Spacer(),
                                                                  Text(data
                                                                          .customer_age
                                                                          .split(
                                                                              ',')[0] +
                                                                      " Years,"),
                                                                  data.customer_gender
                                                                              .toString() ==
                                                                          "1"
                                                                      ? Text(
                                                                          "Male")
                                                                      : Text(
                                                                          "Female"),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(data
                                                                      .order_no),
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
                                                                          color:
                                                                              Colors.blue[200],
                                                                        ),
                                                                        Text(
                                                                            data
                                                                                .customer_mobile_no,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.blue[200],
                                                                            ))
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
                                                                  Text(
                                                                    "Booked Date:",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    data.BOOKING_DT,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Schedule Date:",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    data.collection_dt,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
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
                                                            child: Text(
                                                                data
                                                                    .customer_address,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12)),
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
                                                      Text(
                                                        "Test Details",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    // height: 450,
                                                    width: 330,
                                                    child: Card(
                                                      elevation: 6,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: 180,
                                                                  child: Text(
                                                                    "",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  '\u{20B9} ' +
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                            // Spacer(),
                                                            Divider(),
                                                            SizedBox(
                                                              height: 150,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: 180,
                                                                  child: Text(
                                                                    "Total Amount:",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  '\u{20B9} ' +
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: 180,
                                                                  child: Text(
                                                                    "Paid Amount:",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  '\u{20B9} ' +
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: 180,
                                                                  child: Text(
                                                                    "Due Amount:",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                  '\u{20B9} ' +
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
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
                                      Text(
                                        "Bill Details",
                                        style:
                                            TextStyle(fontFamily: 'Fjalla One'),
                                      ),
                                    ],
                                  )),
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
      return ListView();
    }

    Future<List<Data_Model>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "userid": globals.REFERENCE_ID,
        "fromdt": globals.selectDate == ""
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : globals.selectDate,
        "todt": globals.selectDate == ""
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : globals.selectDate,
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl = Uri.parse(globals.API_url +
          '/mobile/api/PhleboHomeCollection/GetRejectMobileOrder');

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

        return jsonResponse
            .map((strans) => Data_Model.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalList3 = Container(
      color: Color.fromARGB(255, 198, 202, 206),
      height: MediaQuery.of(context).size.height * 0.7,
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
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );

    return Container(child: verticalList3);
  }

  phone() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        // title: const Text(
        //     'AlertDialog Title'),
        //title: SizedBox(height: 10),
        content: Container(
          height: 25,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_in_talk,
                      size: 20, color: Color.fromARGB(255, 54, 244, 79)),
                  Text(
                    '8050809995',
                    style: TextStyle(
                        color: Color.fromARGB(255, 54, 244, 79), fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Data_Model {
  final patient_name;
  final customer_mobile_no;
  final order_no;
  final order_id;
  final APPOINTMENT_DT;
  final BOOKING_DT;
  final customer_address;
  final REASON_NAME;
  final collection_dt;
  final customer_age;
  final customer_gender;

  Data_Model({
    required this.patient_name,
    required this.customer_mobile_no,
    required this.order_no,
    required this.order_id,
    required this.APPOINTMENT_DT,
    required this.BOOKING_DT,
    required this.customer_address,
    required this.REASON_NAME,
    required this.collection_dt,
    required this.customer_age,
    required this.customer_gender,
  });

  factory Data_Model.fromJson(Map<String, dynamic> json) {
    return Data_Model(
      patient_name: json['patient_name'],
      customer_mobile_no: json['customer_mobile_no'],
      order_no: json['order_no'],
      order_id: json['order_id'],
      APPOINTMENT_DT: json['APPOINTMENT_DT'],
      BOOKING_DT: json['BOOKING_DT'],
      customer_address: json['customer_address'],
      REASON_NAME: json['REASON_NAME'],
      collection_dt: json['collection_dt'],
      customer_age: json['customer_age'],
      customer_gender: json['customer_gender'],
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
