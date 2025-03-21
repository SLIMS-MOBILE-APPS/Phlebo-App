import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Phlebo_Cancellation extends StatefulWidget {
  @override
  _Phlebo_Cancellation createState() => _Phlebo_Cancellation();
}

class _Phlebo_Cancellation extends State<Phlebo_Cancellation> {
  String date = '';
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2026));
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 5; // Initial step set to 5.

  int upperBound = 6; // upperBound MUST BE total number of icons minus 1.
  // bool? check1 = false;
  // bool? check2 = false;
  String? cancelled_reason;
  @override
  Widget build(BuildContext context) {
    Reject_Function(
        ReasonappId, billid, sessionid, BuildContext context) async {
      var isLoading = true;

      Map data = {
        "billid": billid.toString(),
        "reasons": globals.SESSION_ID,
        "sessionID": sessionid.toString(),
        "reasonappid": ReasonappId.toString(),
        "connection": globals.Connection_Flag
      };
      print(data.toString());
      final response = await http.post(
          Uri.parse(globals.API_url +
              '/mobile/api/PhleboHomeCollection/RejectMobileOrder'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);

        if (resposne["message"] == "DATA FOUND") {
          Successtoaster1();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Phlebo_Dashboard()));
          globals.customer_name = "";
          globals.order_id = "";

          globals.order_no = "";

          globals.schedule_dt = "";

          globals.customer_mobile_no = "";

          globals.CHANNEL = "";

          globals.REFERAL_DOCTOR = "";

          globals.customer_address = "";

          globals.customer_age = "";

          globals.customer_gender = "";

          globals.order_date = "";
          globals.SESSION_ID = "";
          globals.rejection_reason = "";
        } else {}
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      // theme: ThemeData(fontFamily: 'Fjalla One'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/home visit.png'),
                          fit: BoxFit.fitWidth)),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          // toolbarHeight: 40,
          backgroundColor: Color(0xff123456),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.date_range_outlined),
          //     onPressed: () {
          //       _selectDate(context);
          //     },
          //   ),
          // ],
          title: Text('Order Rejection'),
        ),
        drawer: DrawerForAll(),
        body: Container(
          color: Color.fromARGB(255, 198, 202, 206),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height / 4,
                    width: width / 1.1,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person,
                                        color: Colors.blueAccent),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: globals.customer_name.length <= 25
                                          ? Text(globals.customer_name,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold))
                                          : Text(
                                              globals.customer_name
                                                  .substring(0, 25),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                    Spacer(),
                                    Text(
                                        globals.customer_age.split(',')[0] +
                                            " Years, ",
                                        style: TextStyle(color: Colors.grey)),
                                    globals.customer_gender == "1"
                                        ? Text("Male",
                                            style:
                                                TextStyle(color: Colors.grey))
                                        : Text("Female",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text("Order No: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(globals.order_no.toString()),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        String Number =
                                            globals.customer_mobile_no;
                                        _callNumber(Number);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.phone_in_talk,
                                              size: 15,
                                              color: Colors.blue[300]),
                                          SizedBox(width: 3),
                                          Text(
                                              globals.customer_mobile_no
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.blue[300])),
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
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text("Booked Date:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    Text(globals.order_date),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text("Schedule Date:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    Text(globals.schedule_dt),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Channel: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(globals.CHANNEL),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text("Referral Doctor: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(globals.REFERAL_DOCTOR),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5),
                            child: Container(
                              height: 40,
                              child: Text(globals.customer_address,
                                  style: TextStyle(color: Colors.grey[700])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Select the reason for Rejection",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  height: height / 1.9,
                  width: width / 1.1,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Checkbox(
                                //     //only check box
                                //     value: check1, //unchecked
                                //     onChanged: (bool? value) {
                                //       //value returned when checkbox is clicked
                                //       setState(() {
                                //         check1 = value;
                                //       });
                                //     }),
                                Radio(
                                  value: '10',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Customer already have Tea/Food",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                // Checkbox(
                                //     //only check box
                                //     value: check2, //unchecked
                                //     onChanged: (bool? value) {
                                //       //value returned when checkbox is clicked
                                //       setState(() {
                                //         check2 = value;
                                //       });
                                //     }), //Checkbox
                                Radio(
                                  value: '9',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Customer request-re-schedule for Same Day",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Radio(
                                  value: '8',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Customer request-postpone for Next Day",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Radio(
                                  value: '7',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Sample already given to other Lab",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Radio(
                                  value: '6',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Customer not available",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Radio(
                                  value: '5',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Number not reachable",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Radio(
                                  value: '4',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Took extra time in previous collection",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Radio(
                                  value: '3',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Heavy traffic / Traffic Jam in the area",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Radio(
                                  value: '2',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "I have some urgent personal emergency",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Radio(
                                  value: '1',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.rejection_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Bike breakdown",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
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
                ),
                Container(
                  width: 330,
                  color: Color(0xff123456),
                  child: TextButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Reject_Function(globals.rejection_reason,
                            globals.order_id, globals.SESSION_ID, context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           Phlebo_Transaction_update()),
                        // );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Successtoaster1() {
  return Fluttertoast.showToast(
      msg: "Rejected Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}

_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}
