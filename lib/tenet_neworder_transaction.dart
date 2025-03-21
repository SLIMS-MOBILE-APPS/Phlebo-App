import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'select_services.dart';
import 'drawer.dart';
import 'function.dart';
import 'globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

TextEditingController cash_Controller = TextEditingController();
TextEditingController card_Controller = TextEditingController();
TextEditingController due_Controller = TextEditingController();
TextEditingController Due_Controller = TextEditingController();
TextEditingController Discount_Authorisation_nameController =
    TextEditingController();
TextEditingController Bill_Validation_Controller = TextEditingController();
TextEditingController Concession_Controller = TextEditingController();
TextEditingController Wallet_Controller = TextEditingController();

class tenet_neworder_transaction extends StatefulWidget {
  @override
  _tenet_neworder_transaction createState() => _tenet_neworder_transaction();
}

class _tenet_neworder_transaction extends State<tenet_neworder_transaction> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Razorpay _razorpay;
  String date = '';
  bool _isLoading = false;
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

  void clearText() {
    cash_Controller.clear();
    due_Controller.clear();
    card_Controller.clear();
  }

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

  void Completed_Function(BuildContext context) async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return Center(
    //       child: CircularProgressIndicator(), // or any other loader widget
    //     );
    //   },
    // );
    // ProgressDialog progressDialog = ProgressDialog(context);
    // progressDialog.style(message: 'Loading...'); // Customize the loader message
    // progressDialog.show(); // Show the loader

    EasyLoading.show(status: 'Loading...');
    Saving_Message();
    Map<String, dynamic> data = {
      "tokenno":
          "AgBQBOvXLdwKAhlG1bamFxx8p9GkS3Q1riNmjYx2dWf4RPevTnu6mtCTPGllXP6wTfnKBqeGJaLLBON/VHoCtZdO75UR+w==",
      "serviceid": globals.SERVICE_ID_by_new_order,
      "userid": globals.USER_ID,
      "orderid": globals.order_id, //order id needed
      "specimenid": globals.SPECIMEN_ID_by_new_order, // needed
      "vaccutainerid": globals.VACCUTAINER_ID_by_new_order, //needed
      "vaccutainercount": globals.VACCUTAINER_CUNT_for_New_Order, //needed
      "barcode": globals.Barcode_for_New_Order, //needed
      "lattitude": "",
      "langitude": "",
      "sessionID": globals.SESSION_ID,
      "connection": globals.Connection_Flag
    };

    try {
      final response = await http.post(
        Uri.parse(globals.API_url +
            '/mobile/api/PhleboHomeCollection/PhleboMobileSampleCollectionSave'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        // progressDialog.hide(); // Hide the loader
        EasyLoading.dismiss();
        if (resposne["message"] == "DATA FOUND") {
          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (BuildContext context) {
          //     return Dialog(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //       elevation: 0.0,
          //       backgroundColor: Colors.transparent,
          //       child: Container(
          //         padding: EdgeInsets.all(20.0),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10.0),
          //         ),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             LinearProgressIndicator(
          //               valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          //               backgroundColor: Colors.grey[300],
          //             ),
          //             SizedBox(height: 20.0),
          //             Text(
          //               "Loading...\n don't click the back button",
          //               style: TextStyle(fontSize: 16.0),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );

          // Future.delayed(Duration(seconds: 10), () {
          //   Navigator.of(context, rootNavigator: true).pop();

          //   globals_value_clear();

          //   Successtoaster1();
          //   Getprint(globals.order_id);
          //   // Navigator.pop(context); // Dismiss the loader
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => Phlebo_Dashboard()),
          //   );
          // });
          globals_value_clear();

          Successtoaster1();
          Getprint(globals.order_id);
          // Navigator.pop(context); // Dismiss the loader
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Phlebo_Dashboard()),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      // Navigator.pop(context); // Dismiss the loader
    }
  }

  calculation(obj) {
    var due_amount = 0;
    int total_number = globals.Price_new_order;
    int pay_amount = int.parse(cash_Controller.text);
    if (pay_amount <= total_number) {
      if (cash_Controller.text != "") {
        int pay_amount = int.parse(cash_Controller.text);

        due_amount = (total_number - pay_amount);
        setState(() {
          due_Controller.text = due_amount.toString();
        });
      }
    } else {
      print("enter only payable amount");
      errormsg();
      clearText();
    }
  }

  // void _onLoading() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           height: 200,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               new CircularProgressIndicator(),
  //               new Text("Loading"),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //   new Future.delayed(new Duration(seconds: 1), () {
  //     Navigator.pop(context); //pop dialog
  //   });
  // }

  OnlinePament_Not_Available() {
    return Fluttertoast.showToast(
        msg: "Online Payment not Available",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // Cash_Card(cash_card, mode) {
  //   var Card_Cash_Value = 0;
  //   globals.PaymentMode = mode;
  //   mode == 4 ? cash_Controller.text = "" : card_Controller.text = "";
  //   // Card_Cash_Value = int.parse(cash) + int.parse(card);
  //   Card_Cash_Value = int.parse(cash_card);
  //   if (Card_Cash_Value > int.parse(globals.Price_new_order.toString())) {
  //     cash_Controller.text = "";
  //     card_Controller.text = "";
  //     Card_Cash_Message();
  //   } else {
  //     globals.glb_Card_Cash_Saving_Amount = Card_Cash_Value;
  //   }
  // }
  Cash_Card(cash_card, mode) {
    if (cash_Controller.text == "") {
      cash_Controller.text = "0";
    }
    if (card_Controller.text == "") {
      card_Controller.text = "0";
    }
    if (Wallet_Controller.text == "") {
      Wallet_Controller.text = "0";
    }

    if (cash_Controller.text == "0" &&
        card_Controller.text == "0" &&
        Wallet_Controller.text == "0") {
      cash_card = "0";
    }

    var Card_Cash_Value = 0;
    globals.PaymentMode = mode;
    if (mode == 4) {
      cash_Controller.text = "";
      Wallet_Controller.text = "";
    } else if (mode == 9) {
      card_Controller.text = "";
      cash_Controller.text = "";
    } else {
      Wallet_Controller.text = "";
      card_Controller.text = "";
    }

    // Card_Cash_Value = int.parse(cash) + int.parse(card);
    Card_Cash_Value = int.parse(cash_card);

    if (Card_Cash_Value == "") {
      setState(() {
        Due_Controller.text = "0";
      });
    }

    globals.glb_Due_Amount =
        int.parse(globals.Price_new_order.toString()) - Card_Cash_Value;

    setState(() {
      Due_Controller.text = globals.glb_Due_Amount.toString();
    });

    if (Card_Cash_Value > int.parse(globals.Price_new_order.toString())) {
      cash_Controller.text = "";
      card_Controller.text = "";
      Wallet_Controller.text = "";

      setState(() {
        Due_Controller.text = globals.Price_new_order.toString();
        globals.glb_Due_Amount = int.parse(globals.Price_new_order.toString());
      });

      Card_Cash_Message();
    } else {
      globals.glb_Card_Cash_Saving_Amount = Card_Cash_Value;
    }
  }

  // Cash_Card(cash_card, mode) {
  //    if (cash_Controller.text == "") {
  //     cash_Controller.text = "0";
  //   }
  //   if (card_Controller.text == "") {
  //     card_Controller.text = "0";
  //   }
  //   if (Wallet_Controller.text == "") {
  //     Wallet_Controller.text = "0";
  //   }

  //   if (cash_Controller.text == "0" &&
  //       card_Controller.text == "0" &&
  //       Wallet_Controller.text == "0") {
  //     cash_card = "0";
  //   }

  //   var Card_Cash_Value = 0;
  //   globals.PaymentMode = mode;
  //   if (mode == 4) {
  //     cash_Controller.text = "";
  //     Wallet_Controller.text = "";
  //   } else if (mode == 9) {
  //     card_Controller.text = "";
  //     cash_Controller.text = "";
  //   } else {
  //     Wallet_Controller.text = "";
  //     card_Controller.text = "";
  //   }
  //   // Card_Cash_Value = int.parse(cash) + int.parse(card);
  //   Card_Cash_Value = int.parse(cash_card);

  //   if (Card_Cash_Value == "") {
  //     setState(() {
  //       Due_Controller.text = "0";
  //     });
  //   }

  //   globals.glb_Due_Amount =
  //       int.parse(globals.Price_new_order.toString()) - Card_Cash_Value;

  //   setState(() {
  //     Due_Controller.text = globals.glb_Due_Amount.toString();
  //   });

  //   if (Card_Cash_Value > int.parse(globals.Price_new_order.toString())) {
  //     cash_Controller.text = "";
  //     card_Controller.text = "";
  //     Wallet_Controller.text = "";

  //     setState(() {
  //       Due_Controller.text = globals.Price_new_order.toString();
  //       globals.glb_Due_Amount = int.parse(globals.Price_new_order);
  //     });

  //     Card_Cash_Message();
  //   } else {
  //     globals.glb_Card_Cash_Saving_Amount = Card_Cash_Value;
  //   }
  // }

  Cash_calculation(obj) {
    if (Concession_Controller.text == "") {
      Concession_Controller.text = "0";
    }
    cash_Controller.text = globals.Price_new_order.toString();

    var ConcessionMinusCash = 0.0;
    var ConcessionPlusCash = 0.0;
    double TotalAmount = double.parse(globals.Price_new_order.toString());
    double Concession_Amount = double.parse(Concession_Controller.text);
    globals.glb_ConcessionPercentage = Concession_Amount;
    double Cash_Amount = double.parse(cash_Controller.text);

    double percentage = (Concession_Amount / 100) * Cash_Amount;
    globals.glb_PercentageAmount = percentage;

    if (percentage <= Cash_Amount) {
      ConcessionMinusCash = (Cash_Amount - percentage);

      ConcessionPlusCash = (percentage + ConcessionMinusCash);

      if (ConcessionPlusCash == TotalAmount) {
        setState(() {
          globals.glb_PercentageAmount = percentage;
          globals.glb_ConcessionPercentage = Concession_Amount;
          globals.glb_ConcessionAmount = percentage;
          globals.glb_ConcessionPlusCash = ConcessionMinusCash;
          globals.glb_ConcessionPlusCash == 0
              ? globals.glb_ConcessionPlusCash = 0.1
              : globals.glb_ConcessionPlusCash;
        });
      } else {
        setState(() {
          tenet_neworder_transaction();
          errormsg();
        });
      }
    } else {
      setState(() {
        globals.glb_ConcessionAmount = 0;
        globals.glb_ConcessionPlusCash = 0;
        Concession_Controller.text = "";
        errormsg();
        // clearText();
      });
    }
  }

  void Pay_Function(BuildContext context) async {
    // ProgressDialog progressDialog = ProgressDialog(context);
    // progressDialog.style(message: 'Loading...'); // Customize the loader message
    // progressDialog.show(); // Show the loader

    EasyLoading.show(status: 'Loading...');
    Map<String, dynamic> data = {
      "Token": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
      "patientId": globals.USER_ID, //Phlebo_user_id
      "userName": globals.family_members_uid,
      "test_id": globals.SERVICE_ID_by_new_order, //SERVICE ID NEEDED
      "item_net_amount": globals.Billing_pricenew, //SERVICE AMOUNT NEEDED
      "schdate":
          "${selectedDate.toLocal()}".split(' ')[0], //SCHEDULE DATE NEEEDED
      "orderType": "1",
      "refdocID": globals.REFRL_ID == ""
          ? globals.REFERAL_NAME
          : globals.REFRL_ID, //this is came from select referal doctor
      "channelID": globals.ID, //this is came from select chennel
      "bill_no": "NEW",
      "bill_id":
          globals.LOCATION_ID_new_order, //this location selected by drowpdown
      "bill_type_id": "7",
      "dscntplcyID": "",
      "cmpID": globals.COMPANY_ID,
      "temprefdocID":
          globals.REFRL_ID == "" ? globals.REFERAL_NAME : globals.REFRL_ID,
      "schaddress": "hyderabad",
      "payment_mode": globals.PaymentMode.toString(),
      "paid_amnt": globals.glb_IS_DISCOUNT_NEED == "Y"
          ? globals.glb_ConcessionPlusCash == 0.0 ||
                  globals.glb_ConcessionPlusCash == ""
              ? globals.Price_new_order.toString
              : globals.glb_ConcessionPlusCash.toString()
          : globals.glb_Card_Cash_Saving_Amount
              .toString(), //globals.total_price,,
      "card_no": "",
      "Bank_name": "",
      "etap_no": "",
      "authorised_name": "",
      "policy_reason_id": globals.glb_Selected_Employee_Id.toString(), //emp_id
      "agency_id": globals.AGENCY_ID,
      "area_id": globals.LOCATION_ID_new_order.toString(),
      "due_amount": globals.glb_IS_REQ_DUE == "Y"
          ? globals.glb_Due_Amount == 0
              ? "0"
              : globals.glb_Due_Amount.toString()
          : "0",
      "due_authorization_id": globals.glb_IS_REQ_DUE == "Y"
          ? globals.Selected_Due_Auth_Id == ""
              ? "0"
              : globals.Selected_Due_Auth_Id.toString()
          : "0",
      "sessionID": globals.SESSION_ID,
      "class_service_id": "",
      "service_class_id": "",
      "disc_authorization_id": "",
      "eze_tap_transaction_id": "",
      "transaction_type_flag": "TOTAL_CASH",
      "transaction_reponse": globals.Glb_Payment_Id,
      "Ip_Concession_Amount": globals.glb_PercentageAmount.toString(),
      "Ip_Concession_Percentage": globals.glb_ConcessionPercentage.toString(),
      "Ip_Total_Amount": globals.Price_new_order.toString(),
      "IP_Manual_Barcode": globals.glb_manualbarcode,
      "connection": globals.Connection_Flag
    };

    try {
      final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetBillGenerationNew'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        // progressDialog.hide(); // Hide the loader
        // Hide the loader
        EasyLoading.dismiss();
        Map<String, dynamic> user = resposne['result'][0];
        globals.order_url = user['order_url'].toString();
        globals.order_id = user['order_id'].toString();
        globals.order_no = user['order_no'].toString();

        if (resposne["message"] == "Data Found") {
          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (BuildContext context) {
          //     return Dialog(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //       elevation: 0.0,
          //       backgroundColor: Colors.transparent,
          //       child: Container(
          //         padding: EdgeInsets.all(20.0),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10.0),
          //         ),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             CircularProgressIndicator(
          //               valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          //             ),
          //             SizedBox(height: 20.0),
          //             Text(
          //               "Loading...\n don't click the back button",
          //               style: TextStyle(fontSize: 16.0),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );

          // Future.delayed(Duration(seconds: 10), () {
          //   Navigator.of(context, rootNavigator: true).pop();

          //   Completed_Function(context);

          //   // Reset global variables
          //   globals.vac_count = "";
          //   globals.barcode = "";
          //   globals.glb_Selected_Employee_Id = "";
          //   globals.LOCATION_ID_new_order = "";
          //   cash_Controller.text = "";
          //   globals.REFRL_ID = "";
          //   globals.ID = "";
          //   globals.glb_Card_Cash_Saving_Amount = 0;
          // });
          Completed_Function(context);

          // Reset global variables
          globals.vac_count = "";
          globals.barcode = "";
          globals.glb_Selected_Employee_Id = "";
          globals.LOCATION_ID_new_order = "";
          cash_Controller.text = "";
          globals.REFRL_ID = "";
          globals.ID = "";
          globals.glb_Card_Cash_Saving_Amount = 0;
        }
      }
    } catch (e) {
      print('Error: $e');
      // Navigator.pop(context); // Dismiss the loader
    }
  }

  Bill_No_Validation_Function(BuildContext context) async {
    Map data = {
      "IP_BILL_NO": globals.Glb_Bill_Validation_Controller,
      "IP_SESSION_ID": globals.SESSION_ID,
      "connection": globals.Connection_Flag
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GET_VALIDATE_BILLNO'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      Map<String, dynamic> user = resposne['result'][0];

      var Status = user['cnt'].toString();

      Status == "0" ? Bill_No_Not_Valid_Message() : Pay_Function(context);
    }
  }

  Accept_Permission() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
        content: Center(
          heightFactor: 1,
          child: Container(
            height: 70,
            child: Column(
              children: [
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: Text(
                    'Please click Yes to proceed ahead',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("No"))),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          FunctionForWaiting();
                          myList.clear();
                          clearText();
                        },
                        child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("Yes"))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isButtonDisabled = false;
  Future<void> FunctionForWaiting() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true; // Disable the button
      });
      Pay_Function(context);

      print("clicked");
      Future.delayed(Duration(seconds: 15), () {
        // Enable the button again after the delay
        setState(() {
          isButtonDisabled = false;
        });
      });
    }
  }

  var _selectedItem;
  var _selectedItem_Due;
  late Map<String, dynamic> map;
  List data = [];
  List data_due = [];

  //   late Map<String, dynamic> map;
  // late Map<String, dynamic> params;
  // List data = [];
  // List data_due = [];
  PaymentSuccess() async {
    var isLoading = true;

    Map data = {
      "billid": globals.USER_ID, //patient id
      "reasons": globals.Glb_Payment_Id, //Payment Id
      "sessionID": globals.Glb_Order_Id, //Order Id
      "reasonappid": "0000", //code
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
      } else {}
    }
  }

  PaymentCancelled() async {
    var isLoading = true;

    Map data = {
      "billid": globals.USER_ID, //patient id
      "reasons": globals.Glb_Payment_Error, //error
      "sessionID": globals.Glb_Payment_Message, //message
      "reasonappid": "0000", //code
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
      } else {}
    }
  }

  Select_Due_Authorisation() async {
    var isLoading = true;

    Map data = {
      "IP_COLUMN_NAME": "AUTH_NAME",
      "IP_PREFIX_TEXT": "",
      "IP_ADVANCE_SEARCH": "",
      "IP_AUTH_SOURCE_ID": "0",
      "IP_AUTH_FOR_TRAN_ID": "2",
      "IP_PAGENUM": "0",
      "IP_PAGESIZE": "0",
      "OP_COUNT": "",
      "IP_SESSION_ID": globals.SESSION_ID,
      "connection": globals.Connection_Flag
    };

    final jobsListAPIUrl = Uri.parse(globals.API_url +
        '/mobile/api/PhleboHomeCollection/Phlebo_LOOKUP_AUTH_MOBILE');

    var bodys = json.encode(data);

    var response = await http.post(jobsListAPIUrl,
        headers: {"Content-Type": "application/json"}, body: bodys);
    print("${response.statusCode}");
    print("${response.body}");

    //this code is using for drowpdown
    map = json.decode(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      //this code is using for drowpdown
      setState(() {
        data_due = map["result"] as List;
      });
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  void initState() {
    globals.Selected_Due_Auth_Id = "";
    cash_Controller.text = "";
    card_Controller.text = "";
    Due_Controller.text = globals.Price_new_order.toString();
    globals.glb_Card_Cash_Saving_Amount = 0;
    globals.glb_Due_Amount = globals.Price_new_order;
    Select_Due_Authorisation();
    Concession_Controller.text = "";
    globals.glb_ConcessionAmount = 0;
    globals.glb_ConcessionPlusCash = 0;
    globals.Selected_Auth = null;
    Wallet_Controller.text = "";
    clearText();
    // Razorpay Code Start
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    //Razorpay Code End
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String? paymentId = response.paymentId;
    String? orderId = response.orderId;
    globals.Glb_Payment_Id = paymentId.toString();
    globals.Glb_Order_Id = orderId.toString();
    PaymentSuccess();
    globals.Glb_Payment_Id != ""
        ? globals.glob_IS_REQ_BARCODE_BILLNO == "Y"
            ? Bill_Validation_Controller.text.length < 8
                ? Successtoaster2()
                : Bill_No_Validation_Function(context)
            : Pay_Function(context)
        : Container();

    print('Payment Success: ${response.paymentId}');

    // Handle success
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    String? paymentMessage = response.message;
    String? paymentCode = response.code.toString();
    String? paymentError = response.error.toString();

    globals.Glb_Payment_Message = paymentMessage.toString();
    globals.Glb_Payment_Code = paymentCode.toString();
    globals.Glb_Payment_Error = paymentError.toString();

    PaymentCancelled();
    print('Payment Error: ${response.code} - ${response.message}');
    // Handle error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
    // Handle external wallet
  }

  void _handlePayment() async {
    var options = {
      'key': globals.Glb_Payment_Key.toString(),
      'amount': globals.onlinePrice,
      'name': globals.Glb_Payment_Marchant_Name.toString(),
      'description': 'Description',
      'prefill': {
        'contact': globals.Glb_Payment_Marchant_Contact_No,
        'email': globals.Glb_Payment_Marchant_Email_Id
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  //Razorpay Code End
  @override
  Widget build(BuildContext context) {
//.................................................................................discount authorisation code start
    Widget Discount_Aughorisation_Widget(var data, BuildContext context) {
      return InkWell(
          onTap: () {
            Discount_Authorisation_nameController.text = "";
            globals.AUTH_NAME = data.AUTH_NAME.toString();
            globals.AUTH_ID = data.AUTH_ID.toString();

            setState(() {
              tenet_neworder_transaction();
            });
            Navigator.pop(context);
          },
          child: Container(
              child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: Text(data.AUTH_NAME.toString()))));
    }

    ListView Discount_Aughorisation_ListView(data, BuildContext context) {
      if (data != null) {
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Discount_Aughorisation_Widget(data[index], context);
            });
      }
      return ListView();
    }

    Future<List<Discount_Aughorisation_Data_Model>>
        _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "autherisationsrcId": "0",
        "authtranId": "2",
        "pageNum": "0",
        "pageSize": "0",
        "refferalSourceID": globals.REFERAL_SOURCE_ID,
        "columnName": "AUTH_NAME",
        "prefixText": Discount_Authorisation_nameController.text,
        "sessionID": globals.SESSION_ID,
        "locationID": globals.LOCATIONID,
        "tpaID": "10",
        "flag": "",
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl =
          Uri.parse(globals.API_url + '/mobile/api/Patient/GetAuthorisation');

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
            .map((strans) => Discount_Aughorisation_Data_Model.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget Discount_Aughorisation_verticalList = Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: FutureBuilder<List<Discount_Aughorisation_Data_Model>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              return SizedBox(
                  child: Discount_Aughorisation_ListView(data, context));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );

//.................................................................................discount authorisation code finished
    //Due_Authorisation_word
    final Select_Due_locationDropdwon = SizedBox(
        width: 340,
        height: 48,
        child: Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                value: _selectedItem_Due,
                hint: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text(
                      'Select Due Discount',
                      style: TextStyle(fontSize: 10),
                    )),
                onChanged: (value) {
                  setState(() {
                    _selectedItem_Due = value;
                    globals.Selected_Due_Auth_Id = _selectedItem_Due;
                    tenet_neworder_transaction();
                  });
                },
                items: data_due.map((ldata) {
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['AUTH_NAME'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['AUTH_ID'].toString(),
                  );
                }).toList(),
              ),
            ),
          ),
        ));

    final Select_Booking_Area_locationDropdwon = SizedBox(
        width: 340,
        height: 48,
        child: Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                value: _selectedItem,
                hint: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text(
                      'Select Discount',
                      style: TextStyle(fontSize: 10),
                    )),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                    globals.Selected_Auth = _selectedItem;
                    tenet_neworder_transaction();
                  });
                },
                items: data.map((ldata) {
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['AUTH_NAME'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['AUTH_ID'].toString(),
                  );
                }).toList(),
              ),
            ),
          ),
        ));
    Future<bool> _showExitDialog(BuildContext context) async {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Alert',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text(
                "While using the phlebo app, please only use the app\'s back button."),
            // actions: <Widget>[
            //   TextButton(
            //     onPressed: () {
            //      await Navigator.of(context).pop(false);
            //     },
            //     child: Text('OK'),
            //   ),
            // ],
          );
        },
      );

      return result ?? false;
    }

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
              globals.SERVICE_ID_by_new_order = "";
              globals.SPECIMEN_ID_by_new_order = "";
              globals.VACCUTAINER_ID_by_new_order = "";
              globals.SERVICE_NAME_by_new_order = "";
              globals.SPECIMEN_NAME_by_new_order = "";
              globals.VACCUTAINER_by_new_order = "";
              globals.Billing_pricenew = "";
              globals.VACCUTAINER_CUNT_for_New_Order = "";
              globals.Barcode_for_New_Order = "";
              globals.SERVICE_ID_by_new_order_with_all_Service_id = "";
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search()),
              );
            },
          ),
          backgroundColor: Color(0xff123456),
          actions: <Widget>[Container()],
          title: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Row(
                children: [
                  const Text('Tenet Transaction'),
                  Spacer(),
                  Center(
                      child: globals.glb_IMG_PATH ==
                              "https://asterlabs.asterdmhealthcare.com/mobileappapi/Image/Asterqrcode.jpg"
                          ? ElevatedButton(
                              child: Text('Scan & Pay'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Container(
                                        child: Image.network(
                                          width: 150,
                                          height: 250,
                                          globals.glb_IMG_PATH,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      actions: <Widget>[],
                                    );
                                  },
                                );
                              },
                            )
                          : globals.Glb_LOCATION_QR ==
                                  "http://137.59.200.62/Slims_apps/App_img/Hyderabad QR.png"
                              ? ElevatedButton(
                                  child: Text('Scan & Pay'),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Container(
                                            child: Image.network(
                                              width: 150,
                                              height: 250,
                                              globals.Glb_LOCATION_QR,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          actions: <Widget>[],
                                        );
                                      },
                                    );
                                  },
                                )
                              : globals.Glb_LOCATION_QR ==
                                      "http://137.59.200.62/Slims_apps/App_img/Banglore QR.jpg"
                                  ? ElevatedButton(
                                      child: Text('Scan & Pay'),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                child: Image.network(
                                                  width: 150,
                                                  height: 250,
                                                  globals.Glb_LOCATION_QR,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              actions: <Widget>[],
                                            );
                                          },
                                        );
                                      },
                                    )
                                  : Container()),
                ],
              )),
        ),
        drawer: DrawerForAll(),
        endDrawer: Drawer(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff123456),
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text("Select Services(s)"))
                ],
              ),
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: TextField(
                        controller: Discount_Authorisation_nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Select Discount Authorisation',
                        ),
                        onChanged: (text) {
                          setState(() {
                            tenet_neworder_transaction();
                          });
                        }),
                  ),
                ),
              ),
              Container(
                  height: 40,
                  child: Card(
                      child: Center(
                          child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Discount_Aughorisation_verticalList,
                  ))))
            ]),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 101, 140, 178),
            child: Column(
              children: [
                Container(
                  height: 120,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
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
                                              width: 25,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.blue,
                                              )),
                                          globals.family_members_user_name
                                                      .length <=
                                                  35
                                              ? MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text(globals
                                                      .family_members_user_name),
                                                )
                                              : MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text(globals
                                                      .family_members_user_name
                                                      .substring(0, 35)),
                                                ),
                                          Spacer(),
                                          MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: Text(globals
                                                    .family_members_age
                                                    .split(',')[0] +
                                                " Years,"),
                                          ),
                                          globals.family_members_gender == "1"
                                              ? MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text("Male"))
                                              : MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text("Female")),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: 25,
                                              child: Icon(
                                                Icons.mail,
                                                size: 15,
                                                color: Colors.blue,
                                              )),
                                          MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: globals
                                                        .family_members_user_email ==
                                                    "null"
                                                ? Text("not available",
                                                    style:
                                                        TextStyle(fontSize: 10))
                                                : Text(globals
                                                    .family_members_user_email),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              String Number = globals
                                                  .family_members_user_phone;
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
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text(
                                                      globals
                                                          .family_members_user_phone,
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
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 5),
                                  child: Container(
                                    height: 40,
                                    child: MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: Text(
                                            globals.family_members_area_name)),
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
                Container(
                  height: 110,
                  child: SingleChildScrollView(
                      child: Container(child: function_widet())),
                ),
                globals.ID != "18"
                    ? Container(
                        height: 340,
                        width: 330,
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                              left: 8.0,
                              bottom: 8.0,
                              right: 8.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: const Text(
                                            "Cash Payment",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 120,
                                        height: 30,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: TextField(
                                            readOnly: false,
                                            controller: cash_Controller,

                                            keyboardType: TextInputType
                                                .number, // Show numeric keyboard
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'[0-9]')), // Allow digits only
                                            ],
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Cash Amount',
                                                labelStyle:
                                                    TextStyle(fontSize: 10)),

                                            // onTap: () {
                                            //   OnlinePament_Not_Available();
                                            // },
                                            onChanged: (content) {
                                              setState(() {
                                                Cash_Card(
                                                    cash_Controller.text, 1);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 150,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: const Text(
                                            "Online",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 120,
                                        height: 30,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: TextField(
                                            readOnly: false,
                                            controller: Wallet_Controller,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType
                                                .number, // Show numeric keyboard
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'[0-9]')), // Allow digits only
                                            ],
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Online Payment',
                                                labelStyle:
                                                    TextStyle(fontSize: 10)),
                                            // onTap: () {
                                            //   OnlinePament_Not_Available();
                                            // },
                                            onChanged: (content) {
                                              Cash_Card(
                                                  Wallet_Controller.text, 9);

                                              setState(() {
                                                globals.onlinePrice = int.parse(
                                                        Wallet_Controller
                                                            .text) *
                                                    100;
                                              });

                                              //  Card_calculation(content);
                                              // OnlinePament_Not_Available();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 8.0,
                                    bottom: 8.0,
                                    right: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 150,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: const Text(
                                            "Card",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 120,
                                        height: 30,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: TextField(
                                            readOnly: false,
                                            controller: card_Controller,
                                            keyboardType: TextInputType
                                                .number, // Show numeric keyboard
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'[0-9]')), // Allow digits only
                                            ],
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Card Payment',
                                                labelStyle:
                                                    TextStyle(fontSize: 10)),
                                            // onTap: () {
                                            //   OnlinePament_Not_Available();
                                            // },
                                            onChanged: (content) {
                                              setState(() {
                                                Cash_Card(
                                                    card_Controller.text, 4);
                                              });
                                              //  Card_calculation(content);
                                              // OnlinePament_Not_Available();
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

//Due_Authorisation_word
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: const Text(
                                            "Due Amount",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 120,
                                        height: 30,
                                        child: TextField(
                                          readOnly: true,
                                          controller: Due_Controller,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            // labelText: 'Due Amount',
                                            labelStyle: TextStyle(fontSize: 10),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 10.0),
                                            alignLabelWithHint: true,
                                          ),
                                          textAlign: TextAlign.center,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: false),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (content) {
                                            // Due_Amount_calculation(content);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //Due_Authorisation_work

                                globals.glb_Due_Amount != 0 &&
                                        globals.glb_IS_REQ_DUE == "Y"
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                          left: 8.0,
                                          bottom: 8.0,
                                          right: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 150,
                                              child: MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: const Text(
                                                  "Select Due Authorisation",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              width: 120,
                                              height: 30,
                                              child: MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child:
                                                    Select_Due_locationDropdwon,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),

                                Spacer(),
                                Divider(),
                                Row(
                                  children: [
                                    Container(
                                      width: 200,
                                      child: MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: Text(
                                          "Total Payable Amount: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.pink,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(
                                        '\u{20B9} ' +
                                            globals.Price_new_order.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.pink,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 300,
                        width: 330,
                      ),
                globals.discount_policy_id == ""
                    ? Container(
                        height: 45,
                      )
                    : Builder(
                        builder: (context) => (InkWell(
                              onTap: () => Scaffold.of(context).openEndDrawer(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                height: 43,
                                width: 330,
                                child: Row(
                                  children: [
                                    globals.AUTH_NAME == ""
                                        ? MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: Text(
                                                "Select Discount Authorisation"))
                                        : Text(globals.AUTH_NAME),
                                    Spacer(),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                              ),
                            ))),

//work_progress
                globals.glb_IS_REQ_DUE == "Y"
                    ? globals.Selected_Due_Auth_Id == "" &&
                            globals.glb_Due_Amount == 0
                        ? Container(
                            width: 350,
                            color: Color(0xff123456),
                            child: TextButton(
                                child: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: const Text(
                                    "Pay",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Accept_Permission();
                                }),
                          )
                        : globals.Selected_Due_Auth_Id == "" &&
                                globals.glb_Due_Amount != 0 &&
                                globals.glb_Due_Amount != ""
                            ? Container(
                                width: 350,
                                color: Color.fromARGB(255, 78, 76, 76),
                                child: TextButton(
                                    child: MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: const Text(
                                        "Pay",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Accept_Permission();
                                    }),
                              )
                            : Container(
                                width: 350,
                                color: Color(0xff123456),
                                child: TextButton(
                                    child: MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: const Text(
                                        "Pay",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Accept_Permission();
                                    }),
                              )
                    : card_Controller.text ==
                                globals.Price_new_order.toString() ||
                            cash_Controller.text ==
                                globals.Price_new_order.toString() ||
                            globals.ID == "18"
                        ? globals.glb_IS_DISCOUNT_NEED == "Y"
                            ? globals.Selected_Auth == null ||
                                    globals.glb_ConcessionPlusCash == 0.0 ||
                                    globals.glb_ConcessionPlusCash == ""
                                ? Container(
                                    width: 350,
                                    color: Color.fromARGB(255, 117, 117, 118),
                                    child: TextButton(
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: const Text(
                                            "Pay",
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          // Accept_Permission();
                                        }),
                                  )
                                : Container(
                                    width: 350,
                                    color: Color(0xff123456),
                                    child: TextButton(
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: const Text(
                                            "Pay",
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Accept_Permission();
                                        }),
                                  )
                            : Container(
                                width: 350,
                                color: Color(0xff123456),
                                child: TextButton(
                                    child: MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: const Text(
                                        "Pay",
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Accept_Permission();
                                    }),
                              )
                        : Container(
                            width: 350,
                            color: Color.fromARGB(255, 117, 117, 118),
                            child: TextButton(
                                child: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: const Text(
                                    "Pay",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  // Accept_Permission();
                                }),
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }

  All_Test_Widget(var data, BuildContext context) {
    return Column(
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
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16, top: 5),
                      child: Row(
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(
                              i["SERVICE_NAME"],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Spacer(),
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(
                              "\u{20B9}",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          i["SRV_NET_PRICE"] == null
                              ? MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(
                                    "0",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(
                                    i["SRV_NET_PRICE"].toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
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
    );
  }

  function_widet() {
    return All_Test_Widget(myList, context);
  }

  function_widget() {
    Add_NewTest(obj) {
      var flag = "";
      for (int i = 0; i <= myList.length - 1; i++) {
        if (obj.SERVICE_ID == myList[i]["SERVICE_ID"]) {
          flag = "Y";
        }
      }
      if (flag == "") {
        myList.add({
          'SERVICE_ID': obj.SERVICE_ID,
          'SPECIMEN_NAME': obj.SPECIMEN_NAME,
          'SERVICE_NAME': obj.SERVICE_NAME,
          'PRICE': obj.PRICE,
          'OFFER_CONCESSION': obj.OFFER_CONCESSION,
          'SRV_NET_PRICE': obj.SRV_NET_PRICE,
          'VACCUTAINER': obj.VACCUTAINER,
          'SPECIMEN_ID': obj.SPECIMEN_ID,
          'VACCUTAINER_ID': obj.VACCUTAINER_ID,
          'SERVICECLASS_ID': obj.SERVICECLASS_ID
        });
      } else {
        return errormsg();
        ; //keep toaster
      }

      function_widet();
    }
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

errormsg() {
  return Fluttertoast.showToast(
      msg: "Pay only payable amount",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg1() {
  return Fluttertoast.showToast(
      msg: "Select Discount Authorisation",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

Successtoaster1() {
  return Fluttertoast.showToast(
      msg: "Sample Collected Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}

class Discount_Aughorisation_Data_Model {
  final AUTH_NAME;
  final AUTH_ID;

  Discount_Aughorisation_Data_Model({
    required this.AUTH_NAME,
    required this.AUTH_ID,
  });

  factory Discount_Aughorisation_Data_Model.fromJson(
      Map<String, dynamic> json) {
    return Discount_Aughorisation_Data_Model(
        AUTH_NAME: json['AUTH_NAME'], AUTH_ID: json['AUTH_ID']);
  }
}

_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}

Card_Cash_Message() {
  return Fluttertoast.showToast(
      msg: "Pay only Payable Amount",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 225, 26, 26),
      textColor: Colors.white,
      fontSize: 16.0);
}

Bill_No_Not_Valid_Message() {
  Bill_Validation_Controller.clear();
  return Fluttertoast.showToast(
      msg: "Bill No is already exist",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 225, 26, 26),
      textColor: Colors.white,
      fontSize: 16.0);
}

Successtoaster2() {
  return Fluttertoast.showToast(
      msg: "Please enter Bill No",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 225, 26, 26),
      textColor: Colors.white,
      fontSize: 16.0);
}

Saving_Message() {
  return Fluttertoast.showToast(
      msg: "Bill Generating, don't click the back button",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 12, 192, 123),
      textColor: Colors.white,
      fontSize: 16.0);
}
