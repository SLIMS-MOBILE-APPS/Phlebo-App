import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'family_members.dart';
import 'registration.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

int selectedIndex = 0;
var selecteFromdt = '';
var selecteTodt = '';
TextEditingController Mobile_Controller = TextEditingController();

class New_Order extends StatefulWidget {
  const New_Order({Key? key}) : super(key: key);

  @override
  State<New_Order> createState() => _New_OrderState();
}

class _New_OrderState extends State<New_Order> {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
  }

  void clearText() {
    Mobile_Controller.clear();
  }

  bool isMobileNumberValid(String phoneNumber) {
    String regexPattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    var regExp = new RegExp(regexPattern);

    if (phoneNumber.length == 0) {
      return false;
    } else if (regExp.hasMatch(phoneNumber)) {
      return true;
    }
    return false;
  }

  Registered_Mobile_Number(mobileNumber, BuildContext context) async {
    var isLoading = true;

    Map data = {
      "Token": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
      "Mobile": mobileNumber.toString(),
      "connection": globals.Connection_Flag
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetPatients'),
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

      if (resposne["result"].length > 0) {
        globals.Mobile_Number = mobileNumber.toString();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Family_Members()));
        clearText();
      } else {
        globals.Mobile_Number = mobileNumber.toString();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Registration()));
        clearText();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    var date = "";
    DateTime selectedDate = DateTime.now();
    String formattodate = DateFormat.yMMMd().format(selectedDate);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff123456),
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
          title: Row(
            children: [
              const SizedBox(
                width: 60,
              ),
              MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: const Text(
                  "New Order",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Spacer(),
              MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text(
                  formattodate,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // drawer: Drawer(
        //   child: ListView(
        //     shrinkWrap: true,
        //     padding: EdgeInsets.zero,
        //     children: <Widget>[
        //       const SizedBox(
        //         height: 100,
        //         child: DrawerHeader(
        //           decoration: BoxDecoration(
        //             color: Color.fromARGB(255, 19, 102, 170),
        //           ),
        //           child: Text(
        //             'Logged in as Phlebo',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 20,
        //             ),
        //           ),
        //         ),
        //       ),
        //       UserAccountsDrawerHeader(
        //         currentAccountPicture: Container(
        //           decoration: const BoxDecoration(
        //               image: DecorationImage(
        //                   image: AssetImage('images/home visit.png'),
        //                   fit: BoxFit.fitWidth)),
        //         ),
        //         accountEmail: Text(globals.USER_NAME),
        //         accountName: Text(
        //           globals.DISPLAY_NAME,
        //           style: TextStyle(fontSize: 24.0),
        //         ),
        //         decoration: const BoxDecoration(
        //           color: Colors.black87,
        //         ),
        //       ),
        //       ListTile(
        //         onTap: () {
        //           globals_clear_Function();
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => const Phlebo_Dashboard()),
        //           );
        //         },
        //         leading: const Icon(
        //           Icons.dashboard,
        //           color: Color.fromARGB(255, 19, 102, 170),
        //         ),
        //         title: const Text('Dashboard'),
        //       ),
        //       const Divider(
        //         height: 1,
        //         thickness: 1,
        //       ),
        //       ListTile(
        //         onTap: () {
        //           globals_clear_Function();
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => const New_Order()),
        //           );
        //         },
        //         leading: const Icon(Icons.add_circle,
        //             color: Color.fromARGB(255, 19, 102, 170)),
        //         title: const Text('New Order'),
        //       ),
        //       const Divider(
        //         height: 1,
        //         thickness: 1,
        //       ),
        //       ListTile(
        //         leading: const Icon(Icons.phone_android_outlined,
        //             color: Color.fromARGB(255, 19, 102, 170)),
        //         title: Row(
        //           children: const [
        //             Text('Active Device:'),
        //             Text(
        //               'No Device',
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        //           ],
        //         ),
        //       ),
        //       const Divider(
        //         height: 1,
        //         thickness: 1,
        //       ),
        //       ListTile(
        //         onTap: () {
        //           globals_clear_Function();
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => Phlebo_login()),
        //           );
        //         },
        //         leading: const Icon(Icons.settings_power_outlined,
        //             color: Color.fromARGB(255, 19, 102, 170)),
        //         title: Text('Logout'),
        //       ),
        //       const Divider(
        //         height: 1,
        //         thickness: 1,
        //       ),
        //     ],
        //   ),
        // ),
        drawer: DrawerForAll(),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 70.0,
                          width: 230.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Builder(
                              builder: (context) => IconButton(
                                icon: Image(image: NetworkImage(globals.Logo)),
                                onPressed: () {},
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: TextFormField(
                              autofocus: true,
                              controller: Mobile_Controller,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  labelText: 'Mobile No:',
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.redAccent),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.blueAccent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 3,
                                        color: Colors.blueAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(15))),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$')
                                        .hasMatch(value)) {
                                  return 'Enter a valid number!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 19, 102, 170),
                          textStyle: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        child: MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: const Text('Get Details',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                        onPressed: () {
                          _submit();
                          (Mobile_Controller.text.length == 10)
                              ? Registered_Mobile_Number(
                                  Mobile_Controller.text, context)
                              : Container();
                        },
                      ),
                      const SizedBox(
                        height: 300,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(
                              'Powered by Suvarna Technosoft Pvt. Ltd.',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 102, 170),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
