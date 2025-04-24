import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          if (data.length > 0)
            for (var i in data)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 340,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 5),
                        child: Row(
                          children: [
                            Text(
                              i["SERVICE_NAME"],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "   \u{20B9}",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              i["PRICE"].toString(),
                              style: TextStyle(
                                fontSize: 15,
                              ),
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


    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
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
          backgroundColor: Color(0xff123456),
          actions: <Widget>[Container()],
          title: Text('Bill Details'),
        ),
        drawer: DrawerForAll(),
        body: Container(
          color: Color.fromARGB(255, 198, 202, 206),
          child: Column(
            children: [
              Container(
                height: 210,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 180,
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
                                            ? Text(globals.customer_name)
                                            : Text(globals.customer_name
                                                .substring(0, 32)),
                                        Spacer(),
                                        Text(
                                            globals.customer_age.split(',')[0] +
                                                " Years,"),
                                        globals.customer_gender == "1"
                                            ? Text("Male")
                                            : Text("Female"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(globals.order_no),
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
                                              Text(globals.customer_mobile_no,
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
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Booked Date:",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          globals.order_date,
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Schedule Date:",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          globals.schedule_dt,
                                          style: TextStyle(fontSize: 12),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    left: 10.0, right: 10.0, top: 10),
                                child: Container(
                                  height: 40,
                                  child: globals.customer_address.length <= 85
                                      ? Text(globals.customer_address)
                                      : Text(globals.customer_address
                                          .substring(0, 85)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 320, child: function_widet()),
              Spacer(),
              Container(
                height: 90,
                width: 330,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Amount:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "   \u{20B9}" + globals.total_price,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Paid Amount:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "   \u{20B9} 0",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Due Amount:",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Spacer(),
                            Text(
                              "   \u{20B9}" + globals.total_price,
                              style: TextStyle(
                                fontSize: 15,
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
                width: 350,
                color: Color(0xff123456),
                child: TextButton(
                    child: const Text(
                      "Billing",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Concession_Controller.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Phlebo_Transaction_update()),
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
