// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dashboard.dart';
// import 'globals.dart' as globals;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:billDeskSDK/sdk.dart';
// import 'package:get/get.dart';
//
// class SdkResponseHandler implements ResponseHandler {
//   @override
//   void onError(SdkError sdkError) {
//     _showErrorDialog('SDK Internal Error', sdkError.toString());
//   }
//
//   void showTransactionCompletedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         barrierDismissible:
//         true;
//         return AlertDialog(
//           title: Text('Success'),
//           content: Text('Transaction Completed Successfully'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => Phlebo_Dashboard()),
//                 );
//                 // Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> onTransactionResponse(TxnInfo txnInfoMap) async {
//     String merchantId = txnInfoMap.txnInfoMap["merchantId"].toString();
//     String orderId = txnInfoMap.txnInfoMap["orderId"].toString();
//
//     Map<String, dynamic> data = {
//       "ClientID": "bduat2k296",
//       "MerchantID": merchantId,
//       "SecretKey": "lsGOPQ6csl3weZ2hhgbp5TxSb2vd0iP3",
//       "orderid": orderId,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse('http://103.145.36.186/BillDesk/SLIMS/BillCheckDesk'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(data),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         _extractTransactionData(responseData);
//       } else {
//         _showErrorDialog("Error", "Failed to verify transaction");
//       }
//     } catch (e) {
//       print("Error: $e");
//       _showErrorDialog("Error", e.toString());
//     }
//   }
//
//   void Pay_Function(BuildContext context) async {
//     Map<String, dynamic> data = {
//       "Token": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
//       "patientId": globals.USER_ID, //Phlebo_user_id
//       "userName": globals.customer_id, //patient_id
//       "test_id": globals.Billing_serviceids,
//       "item_net_amount": globals.Billing_servicePrice,
//       "schdate": globals.schedule_dt,
//       "orderType": "1",
//       "refdocID": "0",
//       "channelID": globals.REFERAL_SOURCE_ID,
//       "bill_no": globals.order_no,
//       "bill_id": globals.order_id,
//       "bill_type_id": "7",
//       "dscntplcyID": "",
//       "cmpID": "",
//       "temprefdocID": "0",
//       "schaddress": "hyderabad",
//       "payment_mode": globals.glb_selectedPaymentMethod.toString() == "Cash"
//           ? "2"
//           : globals.glb_selectedPaymentMethod.toString() == "Card"
//               ? "1"
//               : "10",
//       "paid_amnt": globals.total_price, //globals.total_price,
//       "card_no": "", //here i am passing pament id.
//       "Bank_name": "",
//       "etap_no":
//           "version: 1.6.6+61", //this is the version of the pay store upload
//       "authorised_name": "",
//       "policy_reason_id": "",
//       "agency_id": "",
//       "area_id": "",
//       "due_amount": "0",
//       "due_authorization_id": "0",
//       "sessionID": globals.SESSION_ID,
//       "class_service_id": "",
//       "service_class_id": "",
//       "disc_authorization_id": "",
//       "eze_tap_transaction_id": "",
//       "transaction_type_flag": globals.glb_selectedPaymentMethod.toString(),
//       "transaction_reponse":
//           globals.Glb_Payment_Id, //here i am passing pament id.,
//       // "IP_VAC_CNT": globals.glb_Total_Vaccutainer_Value,
//       // "IP_TUBE_CNT": "",
//       // "Ip_SRVS_VAC_COUNTS": "",
//       "Ip_Concession_Amount": "0",
//       "Ip_Concession_Percentage": "0",
//       "Ip_Total_Amount": globals.total_price,
//       "IP_Manual_Barcode": "0",
//       "connection": globals.Connection_Flag
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(globals.API_url + '/mobile/api/Patient/GetBillGenerationNew'),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/x-www-form-urlencoded"
//         },
//         body: data,
//         encoding: Encoding.getByName("utf-8"),
//       );
//
//       if (response.statusCode == 200) {
//         Map<String, dynamic> resposne = jsonDecode(response.body);
//         Map<String, dynamic> user = resposne['result'][0];
//         globals.order_url = user['order_url'].toString();
//         var bill_id = user['order_id'].toString();
//
//         globals.glb_bill_id = bill_id;
//         if (resposne["message"] == "Data Found") {
//           Completed_Function(context);
//         }
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Getprint(obj) async {
//     var url = globals.API_url +
//         '/index.html?bill_id=' +
//         obj.toString() +
//         '&Connection=' +
//         globals.Connection_Flag +
//         '&Client_name=' +
//         globals.Client_Name.toString() +
//         '&Logo=' +
//         globals.Logo.toString();
//     '';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw globals.Connection_Flag + obj.toString();
//     }
//   }
//
//   void Completed_Function(BuildContext context) async {
//     ProgressDialog progressDialog = ProgressDialog(context);
//     progressDialog.style(message: 'Loading...'); // Customize the loader message
//     progressDialog.show(); // Show the loader
//     Map<String, dynamic> data = {
//       "tokenno":
//           "AgBQBOvXLdwKAhlG1bamFxx8p9GkS3Q1riNmjYx2dWf4RPevTnu6mtCTPGllXP6wTfnKBqeGJaLLBON/VHoCtZdO75UR+w==",
//       "serviceid": globals.Billing_serviceids,
//       "userid": globals.USER_ID,
//       "orderid": globals.order_id,
//       "specimenid": globals.Billing_servicespec,
//       "vaccutainerid": globals.Billing_servicevacs,
//       "vaccutainercount": globals.vac_count,
//       "barcode": globals.barcode,
//       "lattitude": globals.Glb_Bill_Validation_Controller,
//       "langitude": "",
//       "sessionID": globals.SESSION_ID,
//       "connection": globals.Connection_Flag
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(
//             '${globals.API_url}/mobile/api/PhleboHomeCollection/PhleboMobileSampleCollectionSave'),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/x-www-form-urlencoded",
//         },
//         body: data,
//         encoding: Encoding.getByName("utf-8"),
//       );
//
//       if (response.statusCode == 200) {
//         final resposne = jsonDecode(response.body);
//         progressDialog.hide(); // Hide the loader
//         if (resposne["message"] == "DATA FOUND") {
//           Getprint(globals.glb_bill_id);
//           // Navigator.pushReplacement(
//           //   context,
//           //   MaterialPageRoute(builder: (context) => Phlebo_Dashboard()),
//           // );
//           _showSuccessToast("Sample Collected Successfully");
//           showTransactionCompletedDialog(context);
//
//           globals.glb_bill_id = "";
//           globals.glb_PercentageAmount = 0;
//           globals.glb_ConcessionPercentage = 0;
//           globals.Billing_servicevacs = "";
//           globals.Billing_servicespec = "";
//           globals.Billing_serviceids = "";
//           globals.SESSION_ID = "";
//           globals.Billing_servicePrice = "";
//           globals.order_id = "";
//           globals.total_price = "";
//           globals.glb_IS_DISCOUNT_NEED = "";
//           globals.glob_IS_REQ_BARCODE_BILLNO = "";
//           globals.barcode = "";
//           globals.vac_count = "";
//           globals.Service_Id_Add_Price = "";
//           globals.PaymentMode = 0;
//           globals.Glb_Bill_Validation_Controller = "";
//           globals.glb_ConcessionAmount = 0;
//           globals.glb_ConcessionPlusCash = 0;
//         }
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   // Helper Methods
//   void _showErrorDialog(String title, String message) {
//     Get.defaultDialog(
//       title: title,
//       middleText: message,
//       confirm: ElevatedButton(
//         onPressed: () => Get.back(),
//         child: const Text('Dismiss'),
//       ),
//     );
//   }
//
//   void _showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           elevation: 0.0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: EdgeInsets.all(20.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
//                 SizedBox(height: 20.0),
//                 Text("Loading...\nDon't click the back button",
//                     style: TextStyle(fontSize: 16.0)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _showSuccessToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }
//
//   void _extractTransactionData(dynamic responseData) {
//     // Regular expressions to extract specific fields
//     String jsonString = responseData.toString();
//
//     RegExp regExpAuthStatus = RegExp(r'"auth_status":"([^"]+)"');
//     RegExp regExpTransactionId = RegExp(r'"transactionid":"([^"]+)"');
//     RegExp regExpOrderId = RegExp(r'"orderid":"([^"]+)"');
//     RegExp regExpTransactionDate = RegExp(r'"transaction_date":"([^"]+)"');
//
//     globals.Glb_auth_status_Value = _extractValue(jsonString, regExpAuthStatus);
//     globals.Glb_transactionid = _extractValue(jsonString, regExpTransactionId);
//     globals.Glb_glb_orderid = _extractValue(jsonString, regExpOrderId);
//     globals.Glb_transaction_date =
//         _extractValue(jsonString, regExpTransactionDate);
//
//     if (globals.Glb_auth_status_Value == "0300") {
//       Pay_Function(Get.context!);
//     } else {
//       _showErrorToast("Transaction failed");
//     }
//   }
//
//   String _extractValue(String jsonString, RegExp regExp) {
//     RegExpMatch? match = regExp.firstMatch(jsonString);
//     return match != null ? match.group(1)! : "N/A";
//   }
//
//   void _showErrorToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }
// }
