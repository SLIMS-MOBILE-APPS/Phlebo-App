import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'bill_details.dart';
import 'dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:progress_dialog/progress_dialog.dart';

import 'nm_payment_screen.dart';

var functionCalls = "";
TextEditingController cash_Controller = TextEditingController();
TextEditingController card_Controller = TextEditingController();
TextEditingController due_Controller = TextEditingController();
TextEditingController Concession_Controller = TextEditingController();
TextEditingController Bill_Validation_Controller = TextEditingController();
TextEditingController Due_Controller = TextEditingController();
TextEditingController Wallet_Controller = TextEditingController();

class Aster_Transaction extends StatefulWidget {
  @override
  _Aster_Transaction createState() => _Aster_Transaction();
}

class _Aster_Transaction extends State<Aster_Transaction> {
  late Razorpay _razorpay;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  var _selectedItem;
  var _selectedItem_Due;
  late Map<String, dynamic> map;
  late Map<String, dynamic> params;
  List data = [];
  List data_due = [];
//Due drowpdwon
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
//globals.Connection_Flag
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

//discount drowpdwon
  Select_Authorisation_Concession() async {
    params = {
      "IP_COLUMN_NAME": "AUTH_NAME",
      "IP_PREFIX_TEXT": "",
      "IP_ADVANCE_SEARCH": "",
      "IP_AUTH_SOURCE_ID": "0",
      "IP_AUTH_FOR_TRAN_ID": "1",
      "IP_PAGENUM": "1",
      "IP_PAGESIZE": "20",
      "OP_COUNT": "100",
      "IP_SESSION_ID": "1",
      "connection": globals.Connection_Flag
    };
    final response = await http.post(
        Uri.parse(globals.API_url +
            '/mobile/api/Patient/GET__LOOKUP_AUTH_Phlebo_App'),
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
      data = map["result"] as List;
    });

    return "Sucess";
  }

  bool isLoading = false;
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

  // All_Test_Widget(var data, BuildContext context) {
  //   var screenWidth = MediaQuery.of(context).size.width;
  //   var screenHeight = MediaQuery.of(context).size.height;
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         if (data.length > 0)
  //           for (var i in data)
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(3.0),
  //                   child: Container(
  //                     width: screenWidth * 1.0,
  //                     height: 40,
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         border: Border.all(
  //                           color: Colors.white,
  //                         ),
  //                         borderRadius: BorderRadius.all(Radius.circular(20))),
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(
  //                           left: 16.0, right: 16, top: 5),
  //                       child: Row(
  //                         children: [
  //                           MediaQuery(
  //                             data: MediaQuery.of(context)
  //                                 .copyWith(textScaleFactor: 1.0),
  //                             child: Container(
  //                               width: 150,
  //                               child: Text(
  //                                 i.SERVICE_NAME,
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           MediaQuery(
  //                             data: MediaQuery.of(context)
  //                                 .copyWith(textScaleFactor: 1.0),
  //                             child: Container(
  //                               width: 50,
  //                               child: Text(
  //                                 i.ScandingBardCode.toString(),
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Spacer(),
  //                           MediaQuery(
  //                             data: MediaQuery.of(context)
  //                                 .copyWith(textScaleFactor: 1.0),
  //                             child: Text(
  //                               "\u{20B9}",
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                           MediaQuery(
  //                             data: MediaQuery.of(context)
  //                                 .copyWith(textScaleFactor: 1.0),
  //                             child: Text(
  //                               i.PRICE.toString(),
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             )
  //       ],
  //     ),
  //   );
  // }
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
                  // height: screenHeight * 0.06,
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

  // Getprint(obj) async {
  //   var url = globals.API_url +
  //       '/index.html?bill_id=' +
  //       obj.toString() +
  //       '&Connection=' +
  //       globals.Connection_Flag +
  //       '&Client_name=' +
  //       globals.Client_Name.toString() +
  //       '&Logo=' +
  //       globals.Logo.toString();
  //   '';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw globals.Connection_Flag + obj.toString();
  //   }
  // }
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

  Push_Notification_Method4(BuildContext context) async {
    var isLoading = true;

    Map data = {
      "BILL_NO": globals.order_no,
      "Authorization": "",
      "SenderId": "",
      "Device_Id": "",
      "body": "",
      "Tittle": "",
      "subtitle": "",
      "Patient_Name": "",
      "Mobile_no": "",
      "IOS_ANDROID": "A",
      "STATUS_FLAG": "4",
      "APP_NAME": "AsterLab",
      "firebaseurl": "",
      "connection": globals.Connection_Flag
    };

    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url + '/PatinetMobileApp/PatPushNotifications'),
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
      globals.order_no = "";
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (jsonDecode(response.body)["message"] != "success") {
        return false;
      }
    }
  }

  void Completed_Function(BuildContext context) async {
    // ProgressDialog progressDialog = ProgressDialog(context);
    // progressDialog.style(message: 'Loading...'); // Customize the loader message
    // progressDialog.show(); // Show the loader
    EasyLoading.show(status: 'Loading...');
    Saving_Message();

    Map<String, dynamic> data = {
      "tokenno":
          "AgBQBOvXLdwKAhlG1bamFxx8p9GkS3Q1riNmjYx2dWf4RPevTnu6mtCTPGllXP6wTfnKBqeGJaLLBON/VHoCtZdO75UR+w==",
      "serviceid": globals.Billing_serviceids,
      "userid": globals.USER_ID,
      "orderid": globals.order_id,
      "specimenid": globals.Billing_servicespec,
      "vaccutainerid": globals.Billing_servicevacs,
      "vaccutainercount": globals.vac_count,
      "barcode": globals.barcode,
      "lattitude": globals.Glb_Bill_Validation_Controller,
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
          Getprint(globals.glb_bill_id);
          Successtoaster1();

          // Navigator.pop(context); // Dismiss the loader
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Phlebo_Dashboard()),
          );

          globals.glb_bill_id = "";
          globals.glb_PercentageAmount = 0;
          globals.glb_ConcessionPercentage = 0;
          globals.Billing_servicevacs = "";
          globals.Billing_servicespec = "";
          globals.Billing_serviceids = "";
          globals.SESSION_ID = "";
          globals.Billing_servicePrice = "";
          globals.order_id = "";
          globals.total_price = "";
          globals.glb_IS_DISCOUNT_NEED = "";
          globals.glob_IS_REQ_BARCODE_BILLNO = "";
          globals.barcode = "";
          globals.vac_count = "";
          globals.Service_Id_Add_Price = "";
          globals.PaymentMode = 0;
          globals.Glb_Bill_Validation_Controller = "";
          globals.glb_ConcessionAmount = 0;
          globals.glb_ConcessionPlusCash = 0;
          cash_Controller.clear();
          Concession_Controller.clear();
          card_Controller.clear();
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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

    Card_Cash_Value = int.parse(cash_card);

    if (Card_Cash_Value == "") {
      setState(() {
        Due_Controller.text = "0";
      });
    }

    globals.glb_Due_Amount = int.parse(globals.total_price) - Card_Cash_Value;

    setState(() {
      Due_Controller.text = globals.glb_Due_Amount.toString();
    });

    if (Card_Cash_Value > int.parse(globals.total_price)) {
      cash_Controller.text = "";
      card_Controller.text = "";
      Wallet_Controller.text = "";

      setState(() {
        Due_Controller.text = globals.total_price;
        globals.glb_Due_Amount = int.parse(globals.total_price);
      });

      Card_Cash_Message();
    } else {
      globals.glb_Card_Cash_Saving_Amount = Card_Cash_Value;
    }
  }

  Cash_calculation(obj) {
    if (Concession_Controller.text == "") {
      Concession_Controller.text = "0";
    }
    cash_Controller.text = globals.total_price;

    var ConcessionMinusCash = 0.0;
    var ConcessionPlusCash = 0.0;
    double TotalAmount = double.parse(globals.total_price);
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
          Concession_Controller.text = "";
          globals.glb_ConcessionPlusCash = 0;
          globals.glb_ConcessionAmount = 0;
          globals.glb_PercentageAmount = 0;
          globals.glb_ConcessionPercentage = 0;
          Aster_Transaction();
          errormsg();
        });
      }
    } else {
      setState(() {
        Concession_Controller.text = "";
        globals.glb_ConcessionPlusCash = 0;
        globals.glb_ConcessionAmount = 0;
        globals.glb_PercentageAmount = 0;
        globals.glb_ConcessionPercentage = 0;
        Concession_Controller.text = "";
        errormsg();
      });
    }
  }

  PaymentSuccess() async {
    var isLoading = true;

    Map data = {
      "billid": globals.order_no, //Bill no
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
      "billid": globals.order_no, //Bill no
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

  void Pay_Function(BuildContext context) async {
    Map<String, dynamic> data = {
      "Token": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
      "patientId": globals.USER_ID, //Phlebo_user_id
      "userName": globals.customer_id, //patient_id
      "test_id": globals.Billing_serviceids,
      "item_net_amount": globals.Billing_servicePrice,
      "schdate": globals.schedule_dt,
      "orderType": "1",
      "refdocID": "0",
      "channelID": globals.REFERAL_SOURCE_ID,
      "bill_no": globals.order_no,
      "bill_id": globals.order_id,
      "bill_type_id": "7",
      "dscntplcyID": "",
      "cmpID": "",
      "temprefdocID": "0",
      "schaddress": "hyderabad",
      "payment_mode": globals.PaymentMode.toString(),
      "paid_amnt": globals.glb_IS_DISCOUNT_NEED == "Y"
          ? globals.glb_ConcessionPlusCash == 0.0 ||
                  globals.glb_ConcessionPlusCash == ""
              ? globals.total_price
              : globals.glb_ConcessionPlusCash.toString()
          : globals.glb_Card_Cash_Saving_Amount
              .toString(), //globals.total_price,
      "card_no": "", //here i am passing pament id.
      "Bank_name": "",
      "etap_no":
          "version: 1.6.6+61", //this is the version of the pay store upload
      "authorised_name": "",
      "policy_reason_id": "",
      "agency_id": "",
      "area_id": "",
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
      "transaction_reponse":
          globals.Glb_Payment_Id, //here i am passing pament id.,
      // "IP_VAC_CNT": globals.glb_Total_Vaccutainer_Value,
      // "IP_TUBE_CNT": "",
      // "Ip_SRVS_VAC_COUNTS": "",
      "Ip_Concession_Amount": globals.glb_PercentageAmount.toString(),
      "Ip_Concession_Percentage": globals.glb_ConcessionPercentage.toString(),
      "Ip_Total_Amount": globals.total_price,
      "IP_Manual_Barcode": globals.glb_manualbarcode.toString(),
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
        Push_Notification_Method4(context);
        Map<String, dynamic> resposne = jsonDecode(response.body);
        Map<String, dynamic> user = resposne['result'][0];
        globals.order_url = user['order_url'].toString();
        var bill_id = user['order_id'].toString();

        globals.glb_bill_id = bill_id;
        if (resposne["message"] == "Data Found") {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Loading...\n don't click the back button",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          Future.delayed(Duration(seconds: 10), () {
            Navigator.of(context, rootNavigator: true).pop();

            Completed_Function(context);
            globals.Glb_Payment_Id = "";
            globals.glb_PercentageAmount = 0;
            globals.glb_ConcessionPercentage = 0;
            globals.Billing_servicePrice = "";
          });
        }
      }
    } catch (e) {
      print('Error: $e');
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

  bool isButtonDisabled = false;
  Future<void> FunctionForWaiting() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true; // Disable the button
      });
      globals.PaymentMode == 9
          ? _handlePayment()
          : globals.glob_IS_REQ_BARCODE_BILLNO == "Y"
              ? Bill_Validation_Controller.text.length < 8
                  ? Successtoaster2()
                  : Bill_No_Validation_Function(context)
              : Pay_Function(context);
      print("clicked");
      Future.delayed(Duration(seconds: 15), () {
        // Enable the button again after the delay
        setState(() {
          isButtonDisabled = false;
        });
      });
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
                  child: const Text(
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

                          // _onLoading();
                        },
                        child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: const Text("Yes"))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    Select_Authorisation_Concession(); //this is using only for Aster Testing and Live
    globals.glb_Due_Amount = int.parse(globals.total_price);
    cash_Controller.text = "";
    card_Controller.text = "";
    Due_Controller.text = globals.total_price;
    globals.glb_Card_Cash_Saving_Amount = 0;

    Select_Due_Authorisation();
    Bill_Validation_Controller.text = "";
    Concession_Controller.text = "";
    globals.glb_ConcessionAmount = 0;
    globals.glb_ConcessionPlusCash = 0;
    globals.glb_ConcessionPercentage = 0;
    globals.Selected_Auth = null;
    Wallet_Controller.text = "";

    // Razorpay Code Start
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    //Razorpay Code End
    super.initState();
  }

  //Razorpay Code Start
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String? paymentId = response.paymentId;
    globals.Glb_Payment_Id = paymentId.toString();

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
      'key': globals.Glb_Payment_Key,
      'amount': globals.onlinePrice,
      'name': globals.Glb_Payment_Marchant_Name,
      'description': 'Description',
      'prefill': globals.Glb_Payment_Marchant_Contact_No +
          globals.Glb_Payment_Marchant_Email_Id,
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
                    Aster_Transaction();
                  });
                },
                items: data.map((ldata) {
                  //     data = map["Data"] as List;
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
                    Aster_Transaction();
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Phlebo_Bill_Details()),
                );
              },
            ),
            backgroundColor: Color(0xff123456),
            actions: <Widget>[Container()],
            title: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Row(
                  children: [
                    const Text('Transaction'),
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
          body: SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(255, 101, 140, 178),
              child: Column(
                children: [
                  Container(
                    height: 65,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 60,
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
                                            const SizedBox(
                                                width: 30,
                                                child: Icon(Icons.person)),
                                            globals.customer_name.length <= 35
                                                ? MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Text(
                                                        globals.customer_name))
                                                : MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Text(globals
                                                        .customer_name
                                                        .substring(0, 35)),
                                                  ),
                                            const Spacer(),
                                            MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: Text(globals.customer_age
                                                      .split(',')[0] +
                                                  " Years,"),
                                            ),
                                            globals.customer_gender == "1"
                                                ? MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Text("Male"))
                                                : MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Text("Female")),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(globals.order_no)),
                                            const Spacer(),
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
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Text(
                                                        globals
                                                            .customer_mobile_no,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blue[200],
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                      height: screenHeight * 0.15, child: function_widet()),

                  globals.glb_REFERAL_SOURCE_ID == "18"
                      ? Container(
                          height: 250,
                        )
                      : Container(
                          width: screenWidth * 1.0,
                          height: screenHeight * 0.60,
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
                                        globals.glb_IS_DISCOUNT_NEED == "Y"
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(5)),
                                                    border: Border.all(
                                                        color:
                                                            Colors.blueAccent)),
                                                width: 120,
                                                height: 30,
                                                child: Center(
                                                  child: MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: globals.glb_ConcessionPlusCash ==
                                                                  0 ||
                                                              globals.glb_ConcessionPlusCash ==
                                                                  ""
                                                          ? Text(
                                                              globals
                                                                  .total_price,
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          78,
                                                                          75,
                                                                          75),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              globals
                                                                  .glb_ConcessionPlusCash
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          78,
                                                                          75,
                                                                          75),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                ))
                                            : globals.glb_IS_DISCOUNT_NEED ==
                                                    "Y"
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(5)),
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueAccent)),
                                                    width: 120,
                                                    height: 30,
                                                    child: Center(
                                                        child: MediaQuery(
                                                            data: MediaQuery.of(context)
                                                                .copyWith(
                                                                    textScaleFactor: 1.0),
                                                            child: globals.glb_Due_Amount == 0 || globals.glb_Due_Amount == ""
                                                                ? Text(
                                                                    globals
                                                                        .total_price,
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            78,
                                                                            75,
                                                                            75),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : Text(
                                                                    globals
                                                                        .glb_Due_Amount
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            78,
                                                                            75,
                                                                            75),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ))))
                                                : SizedBox(
                                                    width: 120,
                                                    height: 30,
                                                    child: MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: TextField(
                                                        readOnly: false,
                                                        controller:
                                                            cash_Controller,
                                                        textAlign:
                                                            TextAlign.center,
                                                        keyboardType: TextInputType
                                                            .number, // Show numeric keyboard
                                                        inputFormatters: <
                                                            TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'[0-9]')), // Allow digits only
                                                        ],
                                                        decoration: const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Cash Amount',
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        10)),

                                                        // onTap: () {
                                                        //   OnlinePament_Not_Available();
                                                        // },
                                                        onChanged: (content) {
                                                          Cash_Card(
                                                              cash_Controller
                                                                  .text,
                                                              1);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                      ],
                                    ),
                                  ),
                                  globals.glb_IS_DISCOUNT_NEED == "Y"
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                child: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: const Text(
                                                    "Concession Amount in % Cent.",
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
                                                  readOnly: false,
                                                  controller:
                                                      Concession_Controller,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText:
                                                        'Concession Amount',
                                                    labelStyle:
                                                        TextStyle(fontSize: 10),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 10.0),
                                                    alignLabelWithHint: true,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: false),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  onChanged: (content) {
                                                    Cash_calculation(content);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),

                                  // This is for Bill No Start

                                  globals.glob_IS_REQ_BARCODE_BILLNO == "Y"
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                child: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: const Text(
                                                    "Bill No.",
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
                                                  readOnly: false,
                                                  controller:
                                                      Bill_Validation_Controller,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: 'Enter Bill No',
                                                    labelStyle:
                                                        TextStyle(fontSize: 10),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 10.0),
                                                    alignLabelWithHint: true,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  inputFormatters: [FilteringTextInputFormatter.allow(
                                                      RegExp(r'^[PpHh]{1}\d{0,7}$'),
                                                    ),
                                                  ],

                                                  onChanged: (content) {
                                                    globals.Glb_Bill_Validation_Controller =
                                                        Bill_Validation_Controller
                                                            .text;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),

                                  // This is for Bill No End

                                  globals.glb_ConcessionAmount != 0.0 &&
                                          globals.glb_IS_DISCOUNT_NEED == "Y"
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
                                                    "Select Discount Authorisation",
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
                                                      Select_Booking_Area_locationDropdwon,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),

                                  globals.Glb_Is_Req_Wallet == "Y"
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
                                                    "Wallet",
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
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: TextField(
                                                    readOnly: false,
                                                    controller:
                                                        Wallet_Controller,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType
                                                        .number, // Show numeric keyboard
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'[0-9]')), // Allow digits only
                                                    ],
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Wallet Payment',
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        10)),
                                                    // onTap: () {
                                                    //   OnlinePament_Not_Available();
                                                    // },
                                                    onChanged: (content) {
                                                      Cash_Card(
                                                          Wallet_Controller
                                                              .text,
                                                          9);

                                                      setState(() {
                                                        globals.onlinePrice =
                                                            int.parse(
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
                                        )
                                      : Container(),
                                  globals.Glb_IS_CARD_NEED == "Y"
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
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: TextField(
                                                    readOnly: false,
                                                    controller: card_Controller,
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType
                                                        .number, // Show numeric keyboard
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'[0-9]')), // Allow digits only
                                                    ],
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Card Payment',
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        10)),
                                                    // onTap: () {
                                                    //   OnlinePament_Not_Available();
                                                    // },
                                                    onChanged: (content) {
                                                      Cash_Card(
                                                          card_Controller.text,
                                                          4);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),

//Due_Authorisation_word
                                  globals.glb_IS_REQ_DUE == "Y"
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                child: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
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
                                                    border:
                                                        OutlineInputBorder(),
                                                    // labelText: 'Due Amount',
                                                    labelStyle:
                                                        TextStyle(fontSize: 10),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 10.0),
                                                    alignLabelWithHint: true,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: false),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  onChanged: (content) {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),

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

//...................................................................
                                  Spacer(),
                                  Divider(),
                                  Row(
                                    children: [
                                      Container(
                                        width: 200,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: const Text(
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
                                          '\u{20B9} ' + globals.total_price,
                                          style: const TextStyle(
                                              color: Colors.pink,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

//here saving button with lot of conditions Start

                  globals.glb_IS_DISCOUNT_NEED == "Y"
                      ? globals.Selected_Auth == null &&
                              globals.glb_ConcessionPlusCash == 0.0 &&
                              globals.glb_ConcessionPlusCash == ""
                          ? Container(
                              width: screenWidth * 1.0,
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
                                    // Accept_Permission();
                                  }),
                            )
                          : globals.Selected_Auth == null &&
                                  globals.glb_ConcessionPlusCash != 0.0 &&
                                  globals.glb_ConcessionPlusCash != ""
                              ? Container(
                                  width: screenWidth * 1.0,
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
                                  width: screenWidth * 1.0,
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
                      : globals.glb_IS_REQ_DUE == "Y"
                          ? globals.Selected_Due_Auth_Id == "" &&
                                  globals.glb_Due_Amount == 0
                              ? Container(
                                  width: screenWidth * 1.0,
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
                                      width: screenWidth * 1.0,
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
                                      width: screenWidth * 1.0,
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
                              width: screenWidth * 1.0,
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
                            ),
//here saving button with lot of conditions Closed
                ],
              ),
            ),
          ),
        ));
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

Successtoaster5() {
  return Fluttertoast.showToast(
      msg: "Online Payment Work Processing",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 225, 26, 26),
      textColor: Colors.white,
      fontSize: 16.0);
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

Saving_Message() {
  return Fluttertoast.showToast(
      msg: "Bill Generating,\n don't click the back button",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 12, 192, 123),
      textColor: Colors.white,
      fontSize: 16.0);
}
