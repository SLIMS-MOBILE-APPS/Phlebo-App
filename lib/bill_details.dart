import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:phleboapp/patient_details..dart';
import 'aster_payment_screen.dart';
import 'dashboard.dart';
import 'function.dart';
import 'healmax_payment_screen.dart';
import 'lucid_payment_screen.dart';
// import 'new_tenet_transaction_screen.dart';
import 'nm_payment_screen.dart';

import 'tenet_transaction_screen.dart';
import 'transaction_existing.dart';
import 'drawer.dart';
import 'globals.dart' as globals;

TextEditingController patient_nameController = TextEditingController();

class Phlebo_Bill_Details extends StatefulWidget {
  @override
  _Phlebo_Bill_Details createState() => _Phlebo_Bill_Details();
}

class _Phlebo_Bill_Details extends State<Phlebo_Bill_Details> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  All_Test_Widget(var data, BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (data.length > 0)
            for (var i in data)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  width: screenWidth * 1.0,
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16, top: 5),
                    child: Row(
                      children: [
                        MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: Container(
                            // width: 120,
                            // height: 40,

                            width: screenWidth * 0.5,

                            child: Text(
                              i.SERVICE_NAME,
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: Container(
                            // width: 120,
                            // height: 40,

                            width: screenWidth * 0.2,

                            child: Text(
                              i.ScandingBardCode.toString(),
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),

                        // Spacer(),

                        MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: Text(
                            "   \u{20B9}",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: Text(
                            i.PRICE.toString(),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }

  function_widet() {
    return All_Test_Widget(globals.existing_dataset, context);
  }

  @override
  Widget build(BuildContext context) {
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


    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          flexibleSpace: Container(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Builder(
              builder: (context) => IconButton(
                icon: Image(image: NetworkImage(globals.Logo)),
                onPressed: () {},
              ),
            ),
          )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              globals.existing_dataset = [];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Phlebo_Pat_Details(),
                  ));
            },
          ),

          // Builder(
          //   builder: (BuildContext context) {
          //     return IconButton(
          //       icon: Container(
          //         decoration: const BoxDecoration(
          //             image: DecorationImage(
          //                 image: AssetImage('images/home visit.png'),
          //                 fit: BoxFit.fitWidth)),
          //       ),
          //       onPressed: () {
          //         Scaffold.of(context).openDrawer();
          //       },
          //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          //     );
          //   },
          // ),
          backgroundColor: Color(0xff123456),
          actions: <Widget>[Container()],
          title: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Row(
                children: [
                  Text('Bill Details'),  Spacer(),    IconButton(
                    icon: Icon(
                      Icons.dashboard,
                      color: Color.fromARGB(255, 170, 19, 84),
                    ),
                    onPressed: () {
                      globals_clear_Function();
                      globals.flag_check = "";
                      globals.REFRL_ID = "";
                      globals.Selected_Title = "";
                      globals.LOCATION_ID_new_order = "";
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Phlebo_Dashboard()),
                      );
                    },
                  ),
                ],
              )),
        ),
        drawer: DrawerForAll(),
        body: Container(
          color: Color.fromARGB(255, 101, 140, 178),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: screenWidth * 1.0,
                  height: screenHeight * 0.3,
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
                                  Icon(Icons.person),
                                  globals.customer_name.length <= 32
                                      ? MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(globals.customer_name))
                                      : MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(globals.customer_name
                                              .substring(0, 32)),
                                        ),
                                  Spacer(),
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                        globals.customer_age.split(',')[0] +
                                            " Years,"),
                                  ),
                                  globals.customer_gender == "1"
                                      ? MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text("Male"))
                                      : MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text("Female")),
                                ],
                              ),
                              Row(
                                children: [
                                  MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(globals.order_no)),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      String Number =
                                          globals.customer_mobile_no;
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
                                              Text(globals.customer_mobile_no,
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
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      "Booked Date:",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Spacer(),
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      globals.order_date,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      "Schedule Date:",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Spacer(),
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      globals.schedule_dt,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
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
                                  MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(globals.CHANNEL)),
                                  MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(globals.REFERAL_DOCTOR))
                                ],
                              ),
                            ],
                          ),
                        ),
                        // globals.customer_address.length <= 85
                        //     ?
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Container(
                                      width: screenWidth *
                                          0.8, // 80% of the screen width
                                      height: screenHeight *
                                          0.1, // 30% of the screen height

                                      child: Text(globals.customer_address))),
                            ],
                          ),
                        )
                        // : MediaQuery(
                        //     data: MediaQuery.of(context)
                        //         .copyWith(textScaleFactor: 1.0),
                        //     child: Text(globals.customer_address
                        //         .substring(0, 85)),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(height: screenHeight * 0.4, child: function_widet()),
              Spacer(),
              Container(
                width: screenWidth * 1.0,
                height: screenHeight * 0.1,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 15.0, right: 15.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: const Text(
                                "Total Amount:",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Spacer(),
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                "   \u{20B9}" + globals.total_price,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                "Paid Amount:",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Spacer(),
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                "   \u{20B9} 0",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: const Text(
                                "Due Amount:",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Spacer(),
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                "   \u{20B9}" + globals.total_price,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: screenWidth * 1.0,
                color: Color(0xff123456),
                child: TextButton(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: const Text(
                        "Billing",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // globals.Glb_NAVIGATION == "NM_MEDICAL"
                      //     ? Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                 Lucid_PatientInfoCard()),
                      //       )
                      //     : globals.Glb_NAVIGATION == "LUCID"
                      //         ? Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     Lucid_PatientInfoCard()),
                      //           )
                      //         :
                      globals.Glb_NAVIGATION == "HEALMAX"
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              healmax_payment_screen()),
                                    )
                                  : globals.Glb_NAVIGATION == "TENET"
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Tenet_Transaction()),
                                        )
                                      : globals.Glb_NAVIGATION ==
                                              "ASTER" //CURRENLTY THIS SCREEN NOT USING ASTER
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Aster_Transaction(),
                                              ))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Phlebo_Transaction_update()),
                                            );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}
