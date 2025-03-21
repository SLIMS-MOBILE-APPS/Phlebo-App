import 'dart:async';
import 'bill_details.dart';
import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class PatientInfoCard extends StatefulWidget {
  @override
  _PatientInfoCardState createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  String? selectedPaymentMethod;
  final List<String> paymentMethods = ['Cash', 'Card', 'UPI'];
  final TextEditingController cashController = TextEditingController();
  Timer? periodicTimer;
  Timer? stopTimer;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  // void initState() {
  //   Navigator.pop(context); // Dismiss the loader
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    Widget All_Test_Widget(var data) {
      return SingleChildScrollView(
        child: Column(
          children: [
            if (data.length > 0)
              for (var i in data)
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.7, // 80% of screen width
                  height: MediaQuery.of(context).size.height *
                      0.05, // 5% of screen height
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    children: [
                      MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Container(
                          width: 180,
                          child: Text(
                            i.SERVICE_NAME,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      // MediaQuery(
                      //   data: MediaQuery.of(context)
                      //       .copyWith(textScaleFactor: 1.0),
                      //   child: Container(
                      //     width: 30,
                      //     child: Text(
                      //       i.ScandingBardCode.toString(),
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Spacer(),
                      MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text(
                          "\u{20B9}" + i.PRICE.toString(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
          ],
        ),
      );
    }

    String generateTransactionNumber() {
      var random = Random();
      var now = DateTime.now();

      // Define your prefix if needed
      String prefix = "TXN";

      // Format the current date and time
      String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);

      // Generate a random number between 1000 and 9999
      int randomNumber = 1000 + random.nextInt(9000);

      // Combine all parts to form the transaction number
      String transactionNumber = "$prefix$formattedDate$randomNumber";

      return transactionNumber;
    }

    void _callNumber(String phoneNumber) async {
      String number = phoneNumber;
      await FlutterPhoneDirectCaller.callNumber(number);
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

    Completed_Function(BuildContext context) async {
      // ProgressDialog progressDialog = ProgressDialog(context);
      // progressDialog.style(
      //     message: 'Loading...'); // Customize the loader message
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
            if (!mounted) return;
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
          }
        }
      } catch (e) {
        print('Error: $e');
      }
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
        "payment_mode": selectedPaymentMethod == "Cash"
            ? "2"
            : selectedPaymentMethod == "Card"
                ? "1"
                : "10",
        "paid_amnt": globals.total_price, //globals.total_price,
        "card_no": "", //here i am passing pament id.
        "Bank_name": "",
        "etap_no":
            "version: 1.6.6+61", //this is the version of the pay store upload
        "authorised_name": "",
        "policy_reason_id": "",
        "agency_id": "",
        "area_id": "",
        "due_amount": "0",
        "due_authorization_id": "0",
        "sessionID": globals.SESSION_ID,
        "class_service_id": "",
        "service_class_id": "",
        "disc_authorization_id": "",
        "eze_tap_transaction_id": "",
        "transaction_type_flag": selectedPaymentMethod.toString(),
        "transaction_reponse":
            globals.Glb_Payment_Id, //here i am passing pament id.,
        // "IP_VAC_CNT": globals.glb_Total_Vaccutainer_Value,
        // "IP_TUBE_CNT": "",
        // "Ip_SRVS_VAC_COUNTS": "",
        "Ip_Concession_Amount": "0",
        "Ip_Concession_Percentage": "0",
        "Ip_Total_Amount": globals.total_price,
        "IP_Manual_Barcode": "0",
        "connection": globals.Connection_Flag
      };

      try {
        final response = await http.post(
          Uri.parse(
              globals.API_url + '/mobile/api/Patient/GetBillGenerationNew'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> resposne = jsonDecode(response.body);
          Map<String, dynamic> user = resposne['result'][0];
          globals.order_url = user['order_url'].toString();
          var bill_id = user['order_id'].toString();

          globals.glb_bill_id = bill_id;
          if (resposne["message"] == "Data Found") {
            Completed_Function(context);
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    PineLab_Transaction_Saving(
        BuildContext context, flag, REQ_TYPE, Com_ID) async {
      var IP_FLAG = flag;
      var IP_REQ_TYPE = REQ_TYPE;
      var IP_COMUNICATION_ID = Com_ID;

      Map data = {
        "IP_REQUEST_STRING": "User ID" +
            globals.USER_ID +
            "MerchantID:29610,SecurityToken: a4c9741b-2889-47b8-be2f-ba42081a246e,ClientID: 1002105,StoreID: 1221258" +
            globals.glb_transaction_list.toString(),
        "IP_COMUNICATION_ID": "", // IP_COMUNICATION_ID,
        "IP_SESSION_ID": globals.SESSION_ID,
        "IP_AMOUNT": globals.total_price,
        "IP_FLAG": IP_FLAG,
        "IP_REQ_TYPE": IP_REQ_TYPE,
        "OP_TRAN_ID": "0", //globals.glb_transactionlogid",
        "OP_TRAN_NO": "0", //globals.glb_transactionNumber,
        "IP_DEVICEID": "1492313670", // this is device number,
        "IP_TERMINAL_NAME": globals.service_name,
        "IP_PLUTUS_REFERENCE_ID":
            globals.glb_Approved_Value == "" ? "0" : globals.glb_Approved_Value,
        "IP_PAYMENT_MODE_ID": selectedPaymentMethod == "Cash"
            ? "2"
            : selectedPaymentMethod == "Card"
                ? "1"
                : "10",
        "IP_UMR_NO": globals.glb_umr_no,
        "IP_ADMN_NO": globals.order_no,
        "IP_MOBILE_NO": globals.customer_mobile_no,
        "IP_PATIENT_NAME": globals.customer_name,
        "IP_PATIENT_ID": "",
        "IP_CARD_TYPE": selectedPaymentMethod.toString(),
        "IP_ACQUIRER_NAME": "Phlebo App",
        "connection": globals.Connection_Flag
      };

      print(data.toString());
      final response = await http.post(
          Uri.parse(globals.API_url +
              '/mobile/api/PhleboHomeCollection/BILLDESH_API'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
      }
    }

    // void stopPineLabTransaction() {
    //   if (periodicTimer != null && periodicTimer!.isActive) {
    //     periodicTimer!.cancel();
    //     print("Periodic timer stopped");
    //   }
    //   if (stopTimer != null && stopTimer!.isActive) {
    //     stopTimer!.cancel();
    //   }
    // }

    Future<void> showPaymentStatusDialog(BuildContext context) async {
      // Close the current dialog
      // Navigator.of(context).pop();

      // Wait for the current dialog to close completely
      // await Future.delayed(Duration(milliseconds: 300));
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Payment Status',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              "Invalid Transaction,\nYour transaction could not be processed. Please try again.",
              style: TextStyle(fontSize: 12),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  // Navigator.of(context, rootNavigator: true).pop();
                  //  Navigator.pop(context); // Close the current popup
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientInfoCard()),
                  );
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

    PineLab_Transaction_Request_Approved(
        BuildContext context, Approved_Value) async {
      Map data = {
        "MerchantID": "29610",
        "SecurityToken": "a4c9741b-2889-47b8-be2f-ba42081a246e",
        "ClientID": "1002105",
        "StoreID": "1221258",
        "PlutusTransactionReferenceID": Approved_Value
      };

      print(data.toString());
      final response = await http.post(
          Uri.parse(
              'https://www.plutuscloudserviceuat.in:8201/API/CloudBasedIntegration/V1/GetCloudBasedTxnStatus'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);

        if (jsonDecode(response.body)["ResponseMessage"] == "TXN APPROVED") {
          List<dynamic> transactionData = resposne["TransactionData"];
          globals.glb_transaction_list = resposne["TransactionData"];

          Pay_Function(context);
          var flag = "A";
          var REQ_TYPE = "IU";
          var Com_ID = "0";
          PineLab_Transaction_Saving(context, flag, REQ_TYPE, Com_ID);
          String amount;
          for (var data in transactionData) {
            if (data['Tag'] == 'Amount') {
              amount = data['Value'];

              globals.glb_amount = amount;
              break;
            }
          }

          String transactionlogid;
          for (var data in transactionData) {
            if (data['Tag'] == 'TransactionLogId') {
              transactionlogid = data['Value'];
              globals.glb_transactionlogid = transactionlogid;
              break;
            }
          }

          return false;
        } else if (jsonDecode(response.body)["ResponseMessage"] ==
                "INVALID TRANSACTION NUMBER" ||
            jsonDecode(response.body)["ResponseMessage"] ==
                "INVALID PLUTUS TXN REF ID") {
          showPaymentStatusDialog(context);
          return false;
        }

        // Stop the loader after processing the response
        // _hideLoader(context);

        return resposne == "TXN APPROVED";
      } else {
        // Handle non-200 response codes if necessary
        // _hideLoader(context);
        return false;
      }
    }

    Cancel_Permission() {
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
                      'Do you want to Cancel',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientInfoCard()),
                            );
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

    void _showRequestApproved_Popup(BuildContext context, approvedValue) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Row(
              children: [
                Icon(Icons.payment, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Payment Confirmation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Please do not refresh or close the app.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Confirm the payment on Pine Lab. Once completed, tap "Approve". To cancel the transaction, tap "Cancel".',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  PineLab_Transaction_Request_Approved(context, approvedValue);
                  var flag = "A";
                  var REQ_TYPE = "I";
                  var Com_ID = "0";
                  PineLab_Transaction_Saving(context, flag, REQ_TYPE, Com_ID);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Approve',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Cancel_Permission();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          );
        },
      );
    }

    // void startPineLabTransaction(BuildContext context, String approvedValue) {
    //   const duration = Duration(seconds: 1);

    //   _showLoader(context);

    //   periodicTimer = Timer.periodic(duration, (Timer timer) {
    //     _showRequestApproved(context, approvedValue);
    //     // var flag = "A";
    //     // var REQ_TYPE = "IU";
    //     // var Com_ID = "0";
    //     // PineLab_Transaction_Saving(context, flag, REQ_TYPE, Com_ID);
    //     // PineLab_Transaction_Request_Approved(context, approvedValue);
    //   });

    //   // Create a timer to stop the periodic timer after 5 minutes (300 seconds)
    //   stopTimer = Timer(Duration(minutes: 1), () {
    //     periodicTimer?.cancel();
    //     _hideLoader(context);
    //     showPaymentStatusDialog(context);
    //   });
    // }

    int numericValue = int.parse(globals.total_price.toString());

    PineLab_Transaction_Request(BuildContext context) async {
      globals.glb_Approved_Value = "";

      var flag = "P";
      var REQ_TYPE = "I";
      var Com_ID = "0";
      PineLab_Transaction_Saving(
          context, flag, REQ_TYPE, Com_ID); //1st time called
      String transactionNumber = generateTransactionNumber();
      globals.glb_transactionNumber = generateTransactionNumber();
      Map data = {
        "TransactionNumber": transactionNumber,
        "SequenceNumber": "1",
        "AllowedPaymentMode": selectedPaymentMethod == "Cash"
            ? "2"
            : selectedPaymentMethod == "Card"
                ? "1"
                : "10", // 1 for card and 10 UPI
        "Amount": (numericValue * 100).toString(),
        "ClientID": "1002105", // this is client id
        "StoreID": "1221258",
        "UserID": "",
        "MerchantID": "29610",
        "SecurityToken": "a4c9741b-2889-47b8-be2f-ba42081a246e",
        "IMEI": "1492313670", // this is device number
        "AutoCancelDurationInMinutes": "1"
      };

      print(data.toString());
      final response = await http.post(
          Uri.parse(
              'https://www.plutuscloudserviceuat.in:8201/API/CloudBasedIntegration/V1/UploadBilledTransaction'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);

        var ResponseMessage_Value = resposne['ResponseMessage'].toString();
        var PlutusTransactionReferenceID_Value =
            resposne['PlutusTransactionReferenceID'].toString();

        globals.glb_Approved_Value =
            resposne['PlutusTransactionReferenceID'].toString();

        if (jsonDecode(response.body)["ResponseMessage"] == "APPROVED") {
          var flag = "P";
          var REQ_TYPE = "IU";
          var Com_ID = "0";
          PineLab_Transaction_Saving(
              context, flag, REQ_TYPE, Com_ID); //2nd time called
          _showRequestApproved_Popup(
              context, PlutusTransactionReferenceID_Value);
          return false;
        }
      }
    }

    bool isButtonDisabled = false;
    Future<void> FunctionForWaiting() async {
      if (!isButtonDisabled) {
        setState(() {
          isButtonDisabled = true; // Disable the button
        });
        selectedPaymentMethod == "Cash"
            ? Pay_Function(context)
            : PineLab_Transaction_Request(context);

        // Pay_Function(context);
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          return await _showExitDialog(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Transaction'),
            backgroundColor: Color(0xff123456),
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
            // actions: [
            //   Builder(
            //     builder: (BuildContext context) {
            //       return IconButton(
            //         icon: Container(
            //           decoration: const BoxDecoration(
            //             image: DecorationImage(
            //               image: AssetImage('images/home visit.png'),
            //               fit: BoxFit.fitWidth,
            //             ),
            //           ),
            //         ),
            //         onPressed: () {
            //           Scaffold.of(context).openEndDrawer();
            //         },
            //         tooltip:
            //             MaterialLocalizations.of(context).openAppDrawerTooltip,
            //       );
            //     },
            //   ),
            // ],
          ),
          // endDrawer: DrawerForAll(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0),
                            child: Container(
                              height: 65,
                              child: Column(
                                children: [
                                  Container(
                                    height: 60,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                const SizedBox(
                                                    width: 30,
                                                    child: Icon(Icons.person)),
                                                globals.customer_name.length <=
                                                        35
                                                    ? MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                textScaleFactor:
                                                                    1.0),
                                                        child: Container(
                                                          width: 150,
                                                          child: Text(
                                                            globals
                                                                .customer_name,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ))
                                                    : MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                textScaleFactor:
                                                                    1.0),
                                                        child: Container(
                                                          width: 150,
                                                          child: Text(
                                                            globals
                                                                .customer_name
                                                                .substring(
                                                                    0, 35),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                const Spacer(),
                                                MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text(
                                                      globals.customer_age
                                                              .split(',')[0] +
                                                          " Years,",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                globals.customer_gender == "1"
                                                    ? MediaQuery(
                                                        data: MediaQuery.of(context)
                                                            .copyWith(
                                                                textScaleFactor:
                                                                    1.0),
                                                        child: Text("Male",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)))
                                                    : MediaQuery(
                                                        data: MediaQuery.of(context)
                                                            .copyWith(
                                                                textScaleFactor:
                                                                    1.0),
                                                        child: Text("Female",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
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
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Text(
                                                        globals.order_no,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey))),
                                                const Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    String Number = globals
                                                        .customer_mobile_no;
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
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                textScaleFactor:
                                                                    1.0),
                                                        child: Text(
                                                            globals
                                                                .customer_mobile_no,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .blue[200],
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                Container(
                                    height: 208,
                                    child: All_Test_Widget(
                                        globals.existing_dataset)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                    child: Container(
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Select Payment Method',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          DropdownButtonFormField<String>(
                            value: selectedPaymentMethod,
                            items: paymentMethods.map((String method) {
                              return DropdownMenuItem<String>(
                                value: method,
                                child: Text(method),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPaymentMethod = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Payment Method',
                            ),
                          ),
                          SizedBox(height: 20.0),
                          selectedPaymentMethod != null
                              ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(
                                            selectedPaymentMethod == "Cash"
                                                ? "Cash Payment"
                                                : selectedPaymentMethod ==
                                                        "Card"
                                                    ? "Card Payment"
                                                    : "UPI Payment",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: 150,
                                          padding: EdgeInsets.all(
                                              8.0), // Optional: Add padding if needed
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255,
                                                  211,
                                                  206,
                                                  206), // Set your border color
                                              width:
                                                  2.0, // Set your border width
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '\u{20B9} ' + globals.total_price,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 78, 75, 75),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
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
                  ),
                  Container(
                    width: 350,
                    color: selectedPaymentMethod != null
                        ? Color(0xff123456)
                        : Colors.grey,
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
                          selectedPaymentMethod != null
                              ? Accept_Permission()
                              : null;
                          // PineLab_Transaction(context);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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

InvalidTransactionNumber() {
  return Fluttertoast.showToast(
      msg: "Invalid Transaction",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 17, 188, 17),
      textColor: Colors.white,
      fontSize: 20.0);
}

INVALID_PLUTUS_TXN_REF() {
  return Fluttertoast.showToast(
      msg: "INVALID PLUTUS TXN REF",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 17, 188, 17),
      textColor: Colors.white,
      fontSize: 20.0);
}

Transaction_Completed() {
  return Fluttertoast.showToast(
      msg: "Transaction Completed Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 17, 188, 17),
      textColor: Colors.white,
      fontSize: 20.0);
}
