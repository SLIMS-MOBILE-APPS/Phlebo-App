import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class add_referral extends StatefulWidget {
  const add_referral({Key? key}) : super(key: key);

  @override
  State<add_referral> createState() => _add_referralState();
}

class _add_referralState extends State<add_referral> {
  var functionCalls = "";
  int selectedIndex = 0;
  var selecteFromdt = '';
  var selecteTodt = '';
  String? gender;
  TextEditingController Mobile_No_Controller = TextEditingController();
  TextEditingController Referral_Name_Controller = TextEditingController();
  TextEditingController Registration_No_Controller = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  bool _validate = false;
  bool _validate1 = false;

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  String? _selectedItem;
  String? _selectedItem1;

  var _formKey = GlobalKey<FormState>();
  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
  }

  void clearText() {
    Mobile_No_Controller.clear();
    Referral_Name_Controller.clear();
    Registration_No_Controller.clear();
  }

  late Map<String, dynamic> map;
  late Map<String, dynamic> params;
  // var functionCalls = "";
  List selectTitle = []; //edi
  List selectPincode = []; //edi

  getSWData1() async {
    params = {
      "Token": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
      "City_id": "19",
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetAreaByCity'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params,
        encoding: Encoding.getByName("utf-8"));

    print('im here');
    print(response.body);
    map = json.decode(response.body);

    print(response.body);
    if (response.statusCode == 200) {
      functionCalls = "true";
    } else {
      functionCalls == "false";
    }
    setState(() {
      selectPincode = map["result"] as List;
    });
  }

  getSWData() async {
    params = {
      "Token":
          "AgBQBOvXLdwKAhlG1bamFxx8p9GkS3Q1riNmjYx2dWf4RPevTnu6mtCTPGllXP6wTfnKBqeGJaLLBON/VHoCtZdO75UR+w==",
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetPatientTitles'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params,
        encoding: Encoding.getByName("utf-8"));

    print('im here');
    print(response.body);
    map = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      functionCalls = "true";
    } else {
      functionCalls == "false";
    }
    setState(() {
      selectTitle = map["result"] as List;
    });

    return "Sucess";
  }

  @override
  @override
  void initState() {
    PageLoadReferral();

    super.initState();
  }

  AddReferral_Save(age, BuildContext context) async {
    var isLoading = true;

    Map<String, dynamic> body = {
      "TABLE_NAME": "",
      "TABKEY_CD": "",
      "SESSION_ID": "",
      "IP_ADDRESS1": "",
      "IP_ADDRESS2": "",
      "IP_AREA_ID": "0",
      "IP_CITY_ID": "0",
      "IP_STATE_ID": "0",
      "IP_COUNTRY_ID": "0",
      "IP_OFFICE_PHONE": "",
      "IP_HOME_PHONE": "",
      "IP_MOBILE_PHONE": globals.mobile_no,
      "IP_FAX_NUMBER": "",
      "IP_EMAIL_ID": "",
      "IP_WEBSITE_URL": "",
      "IP_ZIPCODE": "",
      "IP_ADDR_TYPE_ID": "0",
      "IP_REFERENCE_ID": "0",
      "IP_ADDR_GRP_ID": "0",
      "IP_REFRL_SRC_ID": "6",
      "IP_REFERAL_NAME": globals.refferal_name,
      "IP_REFERAL_TYPE_ID": "0",
      "IP_REGISTRATION_NO": globals.registration_no,
      "IP_REFRL_CD": "REF13364",
      "IP_SESSION_ID": "1",
      "OP_REFRL_ID": "0 ",
      "IP_OPCONSPERCENT": "0",
      "IP_INVPERCENT": "0",
      "IP_IPPERCENT": "0",
      "IP_PANNO": "",
      "IP_PACKAGES": "0",
      "IP_SERVICES": "0",
      "IP_MISCELLANEOUS": "0",
      "IP_PROCEDURES": "0",
      "IP_BILLWISEPERCENT": "",
      "IP_PRO_ID": "",
      "IP_REFERRAL_TYPE_ID": "",
      "IP_TARIFF_ID": "",
      "IP_AGREMENT_FROM_DT": "2023-02-01 12:00:00 AM",
      "IP_AGREMENT_TO_DT": "2023-02-01 12:00:00 ",
      "IP_DISPATCH_TYPE_ID": "0",
      "IP_LOCATION_ID": "",
      "IP_CREDIT_LIMIT": "0",
      "IP_TRESHOLD_VALUE": "0",
      "IP_ATTACH_FILE_PATH": "",
      "IP_IS_EMAIL_REQ_TO_PATIENT": "N",
      "IP_IS_SMS_REQ_TO_PATIENT": "N",
      "IP_REF_PAY_MODE": "",
      "IP_REF_LOC_IDS": "",
      "IP_WITHHEADER": "",
      "IP_WITHOUTHEADER": "",
      "IP_IS_ROLLING_ADVANCE": "N",
      "connection":
          "Server=202.143.99.71,9969;;User id=app2;Password=deeksha452018;Database=UAT_PARKLINE_TESTING"
    };

    final response = await http.post(
        Uri.parse(
            globals.API_url + '/mobile/api/PhleboHomeCollection/REFERALINFO'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne["message"] == "DATA FOUND") {
        globals.mobile_no = "";
        globals.refferal_name = "";
        globals.registration_no = "";

        Successtoaster();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Phlebo_Dashboard()),
        );
        clearText();
      } else {
        errormsg();
        globals.mobile_no = "";
        globals.refferal_name = "";
        globals.registration_no = "";
      }
    }
  }

  PageLoadReferral() async {
    var isLoading = true;

    Map<String, dynamic> body = {
      "IP_TABLE_NAME": "REFERAL",
      "OP_TABKEY_CD": "1000",
      "IP_SESSION_ID": "1",
      "connection":
          "Server=202.143.99.71,9969;;User id=app2;Password=deeksha452018;Database=P_CEMS_LIMS"
    };

    final response = await http.post(
        Uri.parse(
            globals.API_url + '/mobile/api/PhleboHomeCollection/PAGELOAD_RE'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne["message"] == "FOUND") {
      } else {}
    }
  }

  String dropdownvalue = 'permanent Doctor';

  // List of items in our dropdown menu
  var items = [
    'permanent Doctor',
    'Pickup Point',
  ];

  String dropdownvalue1 = 'Debit';

  // List of items in our dropdown menu
  var items1 = [
    'Debit',
    'Credit',
  ];

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
        appBar: AppBar(
          backgroundColor: const Color(0xff123456),
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
          // title: Row(
          //   children: [
          //     const SizedBox(
          //       width: 30,
          //     ),
          //     MediaQuery(
          //       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //       child: const Text(
          //         "Add Referral",
          //         style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white),
          //       ),
          //     ),
          //     const Spacer(),
          //   ],
          // ),
        ),
        drawer: DrawerForAll(),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 570,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10.0),
                        //   child: Container(
                        //     padding: const EdgeInsets.all(10),
                        //     child: TextFormField(
                        //       // autofocus: true,
                        //       textCapitalization: TextCapitalization.characters,
                        //       keyboardType: TextInputType.name,
                        //       controller: Mobile_No_Controller,
                        //       decoration: InputDecoration(
                        //           prefixIcon: const Icon(
                        //             Icons.phone_in_talk,
                        //             color: Color.fromARGB(255, 19, 102, 170),
                        //           ),
                        //           labelText: 'Mobile No.:',
                        //           errorBorder: const OutlineInputBorder(
                        //             //<-- SEE HERE
                        //             borderSide: BorderSide(
                        //                 width: 3, color: Colors.redAccent),
                        //           ),
                        //           focusedBorder: const OutlineInputBorder(
                        //             //<-- SEE HERE
                        //             borderSide: BorderSide(
                        //                 width: 3, color: Colors.blueAccent),
                        //           ),
                        //           enabledBorder: OutlineInputBorder(
                        //               borderSide: const BorderSide(
                        //                 width: 1,
                        //                 color: const Color.fromARGB(
                        //                     255, 170, 168, 168),
                        //               ),
                        //               borderRadius: BorderRadius.circular(15))),
                        //       onFieldSubmitted: (value) {
                        //         //Validator
                        //       },
                        //     ),
                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.only(top: 17.0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: TextFormField(
                                autofocus: true,
                                controller: Mobile_No_Controller,
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
                                        borderRadius:
                                            BorderRadius.circular(15))),
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

                        Padding(
                          padding: const EdgeInsets.only(top: 07.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: TextFormField(
                                controller: Referral_Name_Controller,
                                decoration: InputDecoration(
                                    // prefixIcon: const Icon(
                                    //   Icons.mail,
                                    //   color:
                                    //       const Color.fromARGB(255, 19, 102, 170),
                                    // ),
                                    labelText: 'Referral Name:',
                                    errorText: _validate
                                        ? 'Enter Referral Name'
                                        : null,
                                    errorBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.redAccent),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blueAccent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 170, 168, 168),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                keyboardType: TextInputType.emailAddress,
                                onFieldSubmitted: (value) {},
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: TextFormField(
                                controller: Registration_No_Controller,
                                // autofocus: true,
                                textCapitalization:
                                    TextCapitalization.characters,
                                keyboardType: TextInputType.streetAddress,

                                decoration: InputDecoration(
                                    // prefixIcon: const Icon(
                                    //   Icons.directions,
                                    //   color: Color.fromARGB(255, 19, 102, 170),
                                    // ),
                                    labelText: 'Registration No.:',
                                    errorText: _validate1
                                        ? 'Enter Registration Number'
                                        : null,
                                    errorBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.redAccent),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blueAccent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: const Color.fromARGB(
                                              255, 170, 168, 168),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onFieldSubmitted: (value) {
                                  //Validator
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 340,
                          height: 48,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0),
                                child: DropdownButton(
                                  isDense: true,
                                  isExpanded: true,
                                  menuMaxHeight: 300,
                                  value: dropdownvalue,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(items)),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                      globals.permanent_dr = dropdownvalue;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 340,
                          height: 48,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0),
                                child: DropdownButton(
                                  isDense: true,
                                  isExpanded: true,
                                  menuMaxHeight: 300,
                                  value: dropdownvalue1,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: items1.map((String items1) {
                                    return DropdownMenuItem(
                                      value: items1,
                                      child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(items1)),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue1 = newValue!;
                                      globals.payment_mode = dropdownvalue1;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: SizedBox(
                    width: 350,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xff123456),
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: const Text('Save Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            )),
                      ),
                      onPressed: () {
                        _submit();
                        setState(() {
                          globals.mobile_no = Mobile_No_Controller.text;
                          globals.refferal_name = Referral_Name_Controller.text;
                          globals.registration_no =
                              Registration_No_Controller.text;

                          Referral_Name_Controller.text.isEmpty
                              ? _validate = true
                              : _validate = false;
                          Registration_No_Controller.text.isEmpty
                              ? _validate1 = true
                              : _validate1 = false;
                        });
                        AddReferral_Save(globals.age, context);
                      },
                    ),
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

Successtoaster() {
  return Fluttertoast.showToast(
      msg: "Register Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg() {
  return Fluttertoast.showToast(
      msg: "Something wrong",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}
