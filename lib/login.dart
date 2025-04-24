import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dashboard.dart';
import 'globals.dart' as globals;

int selectedIndex = 0;
var selecteFromdt = '';
var selecteTodt = '';
TextEditingController User_Name_Controller = TextEditingController();
TextEditingController Password_Controller = TextEditingController();
bool _isVisible = false;

class Phlebo_login extends StatefulWidget {
  Phlebo_login({Key? key}) : super(key: key);

  @override
  State<Phlebo_login> createState() => _Phlebo_loginState();
}

class _Phlebo_loginState extends State<Phlebo_login> {
  final email = TextEditingController();

  final pass = TextEditingController();

  void clearText() {
    User_Name_Controller.clear();
    Password_Controller.clear();
  }

  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  login(username, password, BuildContext context) async {
    // ProgressDialog progressDialog = ProgressDialog(context);
    // progressDialog.style(message: 'Loading...'); // Customize the loader message
    // progressDialog.show(); // Show the loader

    EasyLoading.show(status: 'Loading...');
    Map data = {
      "username": username.split(':')[1],
      "PASSOWRD": password,
      "LOCATIONID": "",
      "VERSION": "",
      "MACHINE": "",
      "TERMINAL": "",
      "OSUSER": "",
      "ORG_ID": "1",
      "ROLE_ID": "1",
      "LOC_ID": "2",
      "GRP_ID": "1",
      "SESSION_ID": "1",
      "TIMEZONE_ID": "24",
      "TRANSACTION_PASSWORD": "",
      "FCM_TOKEN": "",
      "APP_VERSION": "1.0.0",
      "connection": globals.Connection_Flag
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url +
            '/mobile/api/PhleboHomeCollection/ValidateLogin1234'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      // progressDialog.hide(); // Hide the loader
      EasyLoading.dismiss();
      if (resposne["message"] == "DATA FOUND") {
        Successtoaster();
        clearText();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Phlebo_Dashboard()));
      } else {
        errormsg2();
      }
      Map<String, dynamic> user = resposne['result'][0];
      globals.Glb_LOCATION_QR = user['LOCATION_QR'].toString();

      globals.DISPLAY_NAME = user['DISPLAY_NAME'].toString();
      globals.USER_NAME = user['USER_NAME'].toString();
      globals.PASSWORD = user['PASSWORD'].toString();
      globals.USER_ID = user['USER_ID'].toString();
      globals.LOCATION_NAME = user['LOCATION_NAME'].toString();
      globals.LOCATION_ID = user['LOCATION_ID'].toString();
      globals.session_id = user['session_id'].toString();
      globals.AGENCY_ID = user['AGENCY_ID'].toString();
      globals.REFERENCE_ID = user['REFERENCE_ID'].toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('USER_ID', user['USER_ID'].toString()).toString();
      prefs.setString('USER_NAME', user['USER_NAME'].toString()).toString();
      prefs
          .setString('DISPLAY_NAME', user['DISPLAY_NAME'].toString())
          .toString();
      prefs.setString('PASSWORD', user['PASSWORD'].toString()).toString();
      prefs
          .setString('LOCATION_NAME', user['LOCATION_NAME'].toString())
          .toString();
      prefs.setString('LOCATION_ID', user['LOCATION_ID'].toString()).toString();
      prefs.setString('session_id', user['session_id'].toString()).toString();
      prefs.setString('AGENCY_ID', user['AGENCY_ID'].toString()).toString();
      prefs
          .setString('REFERENCE_ID', user['REFERENCE_ID'].toString())
          .toString();
      prefs.setString('LOCATION_QR', user['LOCATION_QR'].toString()).toString();
    }
  }

  login1(username, password, BuildContext context) async {
    var isLoading = true;

    Map data = {"IP_USER_NAME": username, "IP_PASSWORD": '', "connection": "7"};

    print(data.toString());
    final response = await http.post(
        Uri.parse(
            globals.API_url_Main_login + '/Logistics/APP_VALIDATION_MOBILE'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (jsonDecode(response.body)["message"] != "success") {
        errormsg1();
      }

      globals.Connection_Flag = resposne["Data"][0]["CONNECTION_STRING"];
      globals.Report_URL = resposne["Data"][0]["REPORT_URL"];
      globals.Logo = resposne["Data"][0]["COMPANY_LOGO"].toString();
      globals.API_url = resposne["Data"][0]["API_URL"];
      globals.Client_Name = resposne["Data"][0]["CLIENT_NAME"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs
          .setString(
              'CONNECTION_STRING', resposne["Data"][0]["CONNECTION_STRING"])
          .toString();
      prefs.setString('API_URL', resposne["Data"][0]["API_URL"]).toString();
      prefs
          .setString('REPORT_URL', resposne["Data"][0]["REPORT_URL"])
          .toString();
      prefs
          .setString('COMPANY_LOGO', resposne["Data"][0]["COMPANY_LOGO"])
          .toString();
      prefs
          .setString('CLIENT_NAME', resposne["Data"][0]["CLIENT_NAME"])
          .toString();

      login(User_Name_Controller.text, Password_Controller.text, context);
    }
  }

  bool isButtonDisabled = false;
  Future<void> WaitingFunciton() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true; // Disable the button
      });

      WaitMessage();
      login1(User_Name_Controller.text, Password_Controller.text, context);

      Future.delayed(Duration(seconds: 10), () {
        // Enable the button again after the delay
        setState(() {
          isButtonDisabled = false;
        });
      });
    }
  }

  Widget build(BuildContext context) {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   print(value);
    // });

    Widget head() => Padding(
          padding: const EdgeInsets.only(
            bottom: 50.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(70),
                    bottomLeft: Radius.circular(70),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff123456),
                        Color(0xff123456),
                        Color(0xff123456),
                      ]),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 70.0,
                    width: 70.0,
                    decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage('images/home visit.png'),
                            fit: BoxFit.fitWidth)),
                  ),
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: const Text(
                      'Welcome to \n Phlebo at Home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Pacifico-Regular',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

    Widget buildgoogleicon() => Expanded(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.5,
                color: const Color.fromRGBO(52, 52, 52, 1),
              ),
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromRGBO(30, 30, 30, .51),
            ),
            child: MaterialButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              onPressed: () {},
              child: const Image(
                image: AssetImage('assets/white-google-logo.png'),
                width: 30,
                height: 30,
              ),
            ),
          ),
        );

    Widget buildappleicon() => Expanded(
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.5,
                color: Color.fromARGB(255, 168, 31, 31),
              ),
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromRGBO(30, 30, 30, .51),
            ),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              onPressed: () {},
              child: const Icon(
                Icons.apple,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        );

    Widget buildemail() => Container(
        margin: const EdgeInsets.only(left: 16, right: 32),
        child: TextField(
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          controller: User_Name_Controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 2.5,
                color: Color.fromRGBO(52, 52, 52, 1),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            prefixIcon: const Icon(
              Icons.person,
              color: Color(0xff123456),
            ),
            filled: true,
            fillColor: Color.fromARGB(130, 247, 242, 242),
          ),
        ));

    Widget buildpass() => Container(
        margin: const EdgeInsets.only(left: 16, right: 32),
        child: TextField(
          controller: Password_Controller,
          obscureText: _isVisible ? false : true,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => updateStatus(),
              icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 2.5,
                color: Color.fromRGBO(52, 52, 52, 1),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ));
    Widget buldbuttonlogin() => Container(
          width: 200,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff123456),
                  Color(0xff123456),
                  Color(0xff123456),
                ]),
          ),
          child: MaterialButton(
            onPressed: () {
              WaitingFunciton();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            splashColor: const Color.fromRGBO(30, 30, 30, .51),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: const Text(
                'Log in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Satisfy-Regular',
                ),
              ),
            ),
          ),
        );
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    var date = "";
    DateTime selectedDate = DateTime.now();
    String _formattodate = new DateFormat.yMMMd().format(selectedDate);
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
        backgroundColor: Color.fromARGB(255, 241, 239, 239),
        body: Container(
          height: 900,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      head(),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                              child: Text(
                                'User Name',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff123456),
                                  fontFamily: 'Satisfy-Regular',
                                ),
                              ),
                            ),
                            buildemail(),
                            const SizedBox(height: 25),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff123456),
                                  fontFamily: 'Satisfy-Regular',
                                ),
                              ),
                            ),
                            buildpass(),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10, bottom: 10),
                        child: buldbuttonlogin(),
                      ),
                      SizedBox(
                        height: 130,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(
                              "Powered by  \u00a9 Suvarna TechnoSoft Pvt Ltd.",
                              style: TextStyle(
                                  color: Color(0xff123456),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//........................................................................................
Successtoaster() {
  return Fluttertoast.showToast(
      msg: "Login Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg1() {
  return Fluttertoast.showToast(
      msg: "Invalid UserName",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg2() {
  return Fluttertoast.showToast(
      msg: "Invalid Password",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

WaitMessage() {
  return Fluttertoast.showToast(
      msg: "Please wait",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 17, 188, 17),
      textColor: Colors.white,
      fontSize: 20.0);
}
