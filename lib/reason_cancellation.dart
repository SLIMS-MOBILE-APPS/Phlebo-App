import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';

class Phlebo_Test_Cancellation extends StatefulWidget {
  @override
  _Phlebo_Test_Cancellation createState() => _Phlebo_Test_Cancellation();
}

class _Phlebo_Test_Cancellation extends State<Phlebo_Test_Cancellation> {
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
        // globals.globalDate = selectedDate.toString();
        // PendingListPending(0);
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
                      globals.customer_mobile_no,
                      style: TextStyle(
                          color: Color.fromARGB(255, 54, 244, 79),
                          fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    Cancelled_Function(
        ReasonappId, billid, sessionid, BuildContext context) async {
      var isLoading = true;

      Map data = {
        "sessionID": globals.SESSION_ID,
        "tokenno": globals.PASSWORD,
        "orderid": globals.order_id,
        "serviceid": "",
        "userid": globals.USER_ID,
        "reasion": ReasonappId.toString(),
        "remarks": ReasonappId.toString() == "1"
            ? "Sample already given to other lab."
            : ReasonappId.toString() == "2"
                ? "Customer changes his/her mind."
                : ReasonappId.toString() == "3"
                    ? "Reports TAT is too long."
                    : ReasonappId.toString() == "4"
                        ? "Patient not abailable at given adress."
                        : ReasonappId.toString() == "5"
                            ? "Test Price are high."
                            : ReasonappId.toString() == "6"
                                ? "Delay in visit."
                                : ReasonappId.toString() == "7"
                                    ? "Incorect contact details."
                                    : ReasonappId.toString() == "8"
                                        ? "Wants to go for package or profile test."
                                        : ReasonappId.toString() == "9"
                                            ? "Pre requisition condition not followed."
                                            : ReasonappId.toString() == "10"
                                                ? "Wrong information on the test price."
                                                : ReasonappId.toString() == "11"
                                                    ? "Wrong test name were selected."
                                                    : Container(),
        "connection": globals.Connection_Flag
      };
      print(data.toString());
      final response = await http.post(
          Uri.parse(globals.API_url +
              '/mobile/api/PhleboHomeCollection/PhleboMobileCancelOrder'),
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

          globals.cancelled_reason = "";
        } else {}
      }
    }

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
          title: Text('Order Cancellation'),
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
                    height: 165,
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
                                    SizedBox(
                                        width: 25, child: Icon(Icons.person)),
                                    globals.customer_name.length <= 25
                                        ? Text(
                                            globals.customer_name,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            globals.customer_name
                                                .substring(0, 25)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                    Spacer(),
                                    Text(
                                        globals.customer_age.split(',')[0] +
                                            " Years,",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    globals.customer_gender == "1"
                                        ? Text("Male",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold))
                                        : Text("Female",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text(globals.order_no.toString()),
                                    Spacer(),
                                    InkWell(
                                      onTap: phone,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.phone_in_talk,
                                            size: 15,
                                            color: Colors.blue[200],
                                          ),
                                          Text(
                                              globals.customer_mobile_no
                                                  .toString(),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text("Booked Date:"),
                                    Spacer(),
                                    Text(globals.order_date)
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text("Schedule Date:"),
                                    Spacer(),
                                    Text(globals.schedule_dt)
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Text("Collection Date:"),
                                //     Spacer(),
                                //     Text("27-10-2022")
                                //   ],
                                // )
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
                                SizedBox(
                                  width: 25,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(globals.CHANNEL),
                                    Text(globals.REFERAL_DOCTOR)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 35.0, right: 10.0, top: 5),
                            child: Container(
                              height: 40,
                              child: Text(globals.customer_address),
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
                      "Select the reason for Cancellation",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  height: 420,
                  width: 330,
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
                                  value: '1',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Sample already given to other lab.",
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
                                  value: '2',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Customer changes his/her mind.",
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
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Reports TAT is too long.",
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
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Patient not abailable at given adress.",
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
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Test Price are high.",
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
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Delay in visit.",
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
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Incorect contact details.",
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
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Wants to go for package or profile test.",
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
                                  value: '9',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Pre requisition condition not followed.",
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
                                  value: '10',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Wrong information on the test price.",
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
                                  value: '11',
                                  groupValue: cancelled_reason,
                                  onChanged: (value) {
                                    setState(() {
                                      cancelled_reason = value.toString();
                                      globals.cancelled_reason =
                                          cancelled_reason.toString();
                                    });
                                  },
                                ),
                                Container(
                                  width: 250,
                                  child: Text(
                                    "Wrong test name were selected. ",
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
                        Cancelled_Function(globals.cancelled_reason,
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
      msg: "Cancelled Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}
