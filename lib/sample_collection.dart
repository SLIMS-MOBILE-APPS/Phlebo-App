import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

class Phlebo_Sample_Collection extends StatefulWidget {
  @override
  _Phlebo_Sample_Collection createState() => _Phlebo_Sample_Collection();
}

class _Phlebo_Sample_Collection extends State<Phlebo_Sample_Collection> {
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
            height: 200,
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
                            Text(data.patient_name.toString()),
                            Spacer(),
                          ],
                        ),
                        Row(
                          children: [
                            Text(data.order_no),
                            Spacer(),
                            InkWell(
                              // onTap: phone,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone_in_talk,
                                    size: 15,
                                    color: Colors.blue[200],
                                  ),
                                  Text(data.customer_mobile_no.toString(),
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
                            Text("Booked Date:",
                                style: TextStyle(fontSize: 12)),
                            Spacer(),
                            Text(data.BOOKING_DT.toString(),
                                style: TextStyle(fontSize: 12))
                          ],
                        ),
                        Row(
                          children: [
                            Text("Schedule Date:",
                                style: TextStyle(fontSize: 12)),
                            Spacer(),
                            Text(data.collection_dt.toString(),
                                style: TextStyle(fontSize: 12))
                          ],
                        ),
                        Row(
                          children: [
                            Text("Collection Date:",
                                style: TextStyle(fontSize: 12)),
                            Spacer(),
                            Text(data.APPOINTMENT_DT.toString(),
                                style: TextStyle(fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                    child: Container(
                      height: 30,
                      child: Text(data.customer_address.toString()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      color: Color.fromARGB(255, 167, 175, 169),
                      height: 50,
                      child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                                  height: 185,
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
                                                                  Text(data
                                                                      .patient_name
                                                                      .toString()),
                                                                  Spacer(),
                                                                  Text(data
                                                                      .customer_age
                                                                      .toString()),
                                                                  Text(data
                                                                      .customer_gender
                                                                      .toString())
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(data
                                                                      .customer_mobile_no
                                                                      .toString()),
                                                                  Spacer(),
                                                                  InkWell(
                                                                    // onTap: phone,
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
                                                                            data.customer_mobile_no
                                                                                .toString(),
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
                                                                      "Booked Date:"),
                                                                  Spacer(),
                                                                  Text(data
                                                                      .BOOKING_DT
                                                                      .toString())
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      "Schedule Date:"),
                                                                  Spacer(),
                                                                  Text(data
                                                                      .collection_dt
                                                                      .toString())
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      "Collection Date:"),
                                                                  Spacer(),
                                                                  Text(data
                                                                      .APPOINTMENT_DT
                                                                      .toString())
                                                                ],
                                                              )
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
                                                            child: Text(data
                                                                .customer_address
                                                                .toString()),
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
                                                    width: 340,
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
                                                                    data.test_name
                                                                        .toString(),
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
                                                                      data.net_amount
                                                                          .toString(),
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
                                                                      data.net_amount
                                                                          .toString(),
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
                                                                      data.DUE_AMOUNT
                                                                          .toString(),
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
        "flagnew": "p",
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl = Uri.parse(globals.API_url +
          '/mobile/api/PhleboHomeCollection/Getsamplependingnew');

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
              // return NoContent3();
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
