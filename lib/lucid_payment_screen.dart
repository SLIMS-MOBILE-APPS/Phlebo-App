// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dashboard.dart';
// import 'globals.dart' as globals;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:math';
// import 'package:intl/intl.dart';
//
// //..........................
//
// import 'package:billDeskSDK/sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'SDKResponseHandler.dart';
//
// class Lucid_PatientInfoCard extends StatefulWidget {
//   @override
//   _Lucid_PatientInfoCardState createState() => _Lucid_PatientInfoCardState();
// }
//
// class _Lucid_PatientInfoCardState extends State<Lucid_PatientInfoCard> {
//   String? selectedPaymentMethod;
//   final List<String> paymentMethods = ['Cash', 'Online'];
//   final TextEditingController cashController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     Widget All_Test_Widget(var data) {
//       return SingleChildScrollView(
//         child: Column(
//           children: [
//             if (data.length > 0)
//               for (var i in data)
//                 Container(
//                   width: MediaQuery.of(context).size.width *
//                       0.7, // 80% of screen width
//                   height: MediaQuery.of(context).size.height *
//                       0.05, // 5% of screen height
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(
//                         color: Colors.white,
//                       ),
//                       borderRadius: BorderRadius.all(Radius.circular(20))),
//                   child: Row(
//                     children: [
//                       MediaQuery(
//                         data: MediaQuery.of(context)
//                             .copyWith(textScaleFactor: 1.0),
//                         child: Container(
//                           width: 180,
//                           child: Text(
//                             i.SERVICE_NAME,
//                             style: TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                       // MediaQuery(
//                       //   data: MediaQuery.of(context)
//                       //       .copyWith(textScaleFactor: 1.0),
//                       //   child: Container(
//                       //     width: 30,
//                       //     child: Text(
//                       //       i.ScandingBardCode.toString(),
//                       //       style: TextStyle(
//                       //         fontSize: 12,
//                       //       ),
//                       //     ),
//                       //   ),
//                       // ),
//                       Spacer(),
//                       MediaQuery(
//                         data: MediaQuery.of(context)
//                             .copyWith(textScaleFactor: 1.0),
//                         child: Text(
//                           "\u{20B9}" + i.PRICE.toString(),
//                           style: TextStyle(
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//           ],
//         ),
//       );
//     }
//
//     String generateTransactionNumber() {
//       var random = Random();
//       var now = DateTime.now();
//
//       // Define your prefix if needed
//       String prefix = "TXN";
//
//       // Format the current date and time
//       String formattedDate = DateFormat('yyyyMMddHHmmss').format(now);
//
//       // Generate a random number between 1000 and 9999
//       int randomNumber = 1000 + random.nextInt(9000);
//
//       // Combine all parts to form the transaction number
//       String transactionNumber = "$prefix$formattedDate$randomNumber";
//
//       return transactionNumber;
//     }
//
//     void _callNumber(String phoneNumber) async {
//       String number = phoneNumber;
//       await FlutterPhoneDirectCaller.callNumber(number);
//     }
//
//     Getprint(obj) async {
//       String encodedPart = base64.encode(utf8.encode(
//         'bill_id=' +
//             obj.toString() +
//             '&Connection=' +
//             globals.Connection_Flag +
//             '&Client_name=' +
//             globals.Client_Name +
//             '&Logo=' +
//             globals.Logo,
//       ));
//
//       // Construct the full URL
//       String url = '${globals.API_url}/index.html?$encodedPart';
//
//       // Launch the URL
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Failed to launch URL: ${globals.Connection_Flag} $obj';
//       }
//     }
//
//     _launchSDK(String merchantId, String bdorderid, String authToken,
//         String returnUrl) {
//       final flowConfig = {
//         "merchantId": merchantId,
//         "bdOrderId": bdorderid,
//         "childWindow": false,
//         "returnUrl":
//             "http://103.145.36.186/BillDeskNew/SLIMS/BillDeskStatus", //returnUrl,
//         "authToken": authToken
//       };
//
//       final sdkConfigMap = {
//         "flowConfig": flowConfig,
//         "flowType": "payments",
//         "merchantLogo": ""
//       };
//       ResponseHandler responseHandler = SdkResponseHandler();
//       final sdkConfig = SdkConfig(
//         sdkConfigJson: SdkConfiguration.fromJson(sdkConfigMap),
//         responseHandler: responseHandler,
//         isAPIEnv: true,
//         isDevModeAllowed: true,
//         isJailBreakAllowed: false,
//       );
//
//       SDKWebView.openSDKWebView(sdkConfig);
//       print("Invoked Billdesk SDK with: ");
//       print("flowConfig : $flowConfig");
//     }
//
//     Future<void> Bill_Desk_Transaction(BuildContext context) async {
//       Map data = {
//         "ClientID": "hydlucid", //"bduatv2apt",
//         "MerchantID": "HYDLUCID", //"BDUATV2APT",
//         "SecretKey":
//             "pHfE7xa2JG3MN7lFzUn2PgU1HqgDZG48", //"lsGOPQ6csl3weZ2hhgbp5TxSb2vd0iP3",
//         "ProxyUrl": "",
//         "Amount": globals.total_price
//       };
//
//       final jobsListAPIUrl =
//           Uri.parse('http://103.145.36.186/BillDesk/SLIMS/BillDesk');
//
//       final response = await http.post(
//         jobsListAPIUrl,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(data),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print('Response Body: ${response.body}');
//
//         String jsonString = responseData;
//
//         // Define a regular expression to find 'txnid' value
//         RegExp regExp = RegExp(r'"mercid":"([^"]+)"');
//         RegExp regExp1 = RegExp(r'"bdorderid":"([^"]+)"');
//         RegExp regExp2 = RegExp(r'"authorization":"([^"]+)"');
//         RegExp regExp3 = RegExp(r'"href":"([^"]+)"');
//
//         // Find the first match
//         RegExpMatch? match = regExp.firstMatch(jsonString);
//         RegExpMatch? match1 = regExp1.firstMatch(jsonString);
//         RegExpMatch? match2 = regExp2.firstMatch(jsonString);
//         RegExpMatch? match3 = regExp3.firstMatch(jsonString);
//
//         if (match != null) {
//           // Extract the txnid value
//           String mercid = match.group(1)!;
//           globals.merchantId_Value = mercid;
//           print("mercid: $mercid");
//         } else {
//           print("mercid not found");
//         }
//
//         if (match1 != null) {
//           // Extract the txnid value
//           String bdorderid = match1.group(1)!;
//           globals.bdOrderId_Value = bdorderid;
//           print("bdorderid: $bdorderid");
//         } else {
//           print("bdorderid not found");
//         }
//
//         if (match2 != null) {
//           // Extract the txnid value
//           String authorization = match2.group(1)!;
//           globals.authToken_Value = authorization;
//           print("authorization: $authorization");
//         } else {
//           print("authorization not found");
//         }
//
//         if (match3 != null) {
//           // Extract the txnid value
//           String href = match3.group(1)!;
//           globals.returnUrl_Value = href;
//           print("href: $href");
//         } else {
//           print("href not found");
//         }
//
//         _launchSDK(
//           globals.merchantId_Value,
//           globals.bdOrderId_Value,
//           globals.authToken_Value,
//           globals.returnUrl_Value,
//         );
//       }
//     }
//
//     bool isButtonDisabled = false;
//     Future<void> FunctionForWaiting() async {
//       if (!isButtonDisabled) {
//         setState(() {
//           isButtonDisabled = true; // Disable the button
//         });
//
//         Bill_Desk_Transaction(context);
//
//         // Pay_Function(context);
//         print("clicked");
//         Future.delayed(Duration(seconds: 15), () {
//           // Enable the button again after the delay
//           setState(() {
//             isButtonDisabled = false;
//           });
//         });
//       }
//     }
//
//     Accept_Permission() {
//       showDialog<String>(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(32.0))),
//           contentPadding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
//           content: Center(
//             heightFactor: 1,
//             child: Container(
//               height: 70,
//               child: Column(
//                 children: [
//                   MediaQuery(
//                     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//                     child: const Text(
//                       'Please click Yes to proceed ahead',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: MediaQuery(
//                               data: MediaQuery.of(context)
//                                   .copyWith(textScaleFactor: 1.0),
//                               child: Text("No"))),
//                       TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//
//                             FunctionForWaiting();
//
//                             // _onLoading();
//                           },
//                           child: MediaQuery(
//                               data: MediaQuery.of(context)
//                                   .copyWith(textScaleFactor: 1.0),
//                               child: const Text("Yes"))),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     Future<bool> _showExitDialog(BuildContext context) async {
//       final result = await showDialog<bool>(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(
//               'Alert',
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//             content: Text(
//                 "While using the phlebo app, please only use the app\'s back button."),
//             // actions: <Widget>[
//             //   TextButton(
//             //     onPressed: () {
//             //      await Navigator.of(context).pop(false);
//             //     },
//             //     child: Text('OK'),
//             //   ),
//             // ],
//           );
//         },
//       );
//
//       return result ?? false;
//     }
//
//     return GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: WillPopScope(
//           onWillPop: () async {
//             return await _showExitDialog(context);
//           },
//           child: Scaffold(
//             appBar: AppBar(
//               title: Text('Transaction'),
//               backgroundColor: Color(0xff123456),
//               flexibleSpace: Container(
//                   child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 25),
//                 child: Builder(
//                   builder: (context) => IconButton(
//                     icon: Image(image: NetworkImage(globals.Logo)),
//                     onPressed: () {},
//                   ),
//                 ),
//               )),
//               leading: BackButton(
//                 color: Colors.white, // You can change the color if needed
//                 onPressed: () {
//                   Navigator.pop(
//                       context); // Navigates back to the previous screen
//                 },
//               ),
//             ),
//             body: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Card(
//                     elevation: 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8, 0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 border: Border.all(),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(20))),
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       8.0, 16.0, 8.0, 0),
//                                   child: Container(
//                                     height: 65,
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           height: 60,
//                                           child: Column(
//                                             children: [
//                                               Column(
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       const SizedBox(
//                                                           width: 30,
//                                                           child: Icon(
//                                                               Icons.person)),
//                                                       globals.customer_name
//                                                                   .length <=
//                                                               35
//                                                           ? MediaQuery(
//                                                               data: MediaQuery.of(
//                                                                       context)
//                                                                   .copyWith(
//                                                                       textScaleFactor:
//                                                                           1.0),
//                                                               child: Text(
//                                                                 globals
//                                                                     .customer_name,
//                                                                 style: TextStyle(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ))
//                                                           : MediaQuery(
//                                                               data: MediaQuery.of(
//                                                                       context)
//                                                                   .copyWith(
//                                                                       textScaleFactor:
//                                                                           1.0),
//                                                               child: Text(
//                                                                 globals
//                                                                     .customer_name
//                                                                     .substring(
//                                                                         0, 35),
//                                                                 style: TextStyle(
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                             ),
//                                                       const Spacer(),
//                                                       MediaQuery(
//                                                         data: MediaQuery.of(
//                                                                 context)
//                                                             .copyWith(
//                                                                 textScaleFactor:
//                                                                     1.0),
//                                                         child: Text(
//                                                             globals.customer_age
//                                                                         .split(
//                                                                             ',')[
//                                                                     0] +
//                                                                 " Years,",
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold)),
//                                                       ),
//                                                       globals.customer_gender == "1"
//                                                           ? MediaQuery(
//                                                               data: MediaQuery.of(context)
//                                                                   .copyWith(
//                                                                       textScaleFactor:
//                                                                           1.0),
//                                                               child: Text("Male",
//                                                                   style: TextStyle(
//                                                                       fontWeight: FontWeight
//                                                                           .bold)))
//                                                           : MediaQuery(
//                                                               data: MediaQuery.of(context)
//                                                                   .copyWith(
//                                                                       textScaleFactor:
//                                                                           1.0),
//                                                               child: Text(
//                                                                   "Female",
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight.bold))),
//                                                     ],
//                                                   ),
//                                                   Row(
//                                                     children: [
//                                                       const SizedBox(
//                                                         width: 30,
//                                                       ),
//                                                       MediaQuery(
//                                                           data: MediaQuery.of(
//                                                                   context)
//                                                               .copyWith(
//                                                                   textScaleFactor:
//                                                                       1.0),
//                                                           child: Text(
//                                                               globals.order_no,
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .grey))),
//                                                       const Spacer(),
//                                                       InkWell(
//                                                         onTap: () {
//                                                           String Number = globals
//                                                               .customer_mobile_no;
//                                                           _callNumber(Number);
//                                                         },
//                                                         child: Row(
//                                                           children: [
//                                                             Icon(
//                                                               Icons
//                                                                   .phone_in_talk,
//                                                               size: 15,
//                                                               color: Colors
//                                                                   .blue[200],
//                                                             ),
//                                                             MediaQuery(
//                                                               data: MediaQuery.of(
//                                                                       context)
//                                                                   .copyWith(
//                                                                       textScaleFactor:
//                                                                           1.0),
//                                                               child: Text(
//                                                                   globals
//                                                                       .customer_mobile_no,
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: Colors
//                                                                             .blue[
//                                                                         200],
//                                                                   )),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Divider(),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       SizedBox(
//                                         width: 30,
//                                       ),
//                                       Container(
//                                           height: 208,
//                                           child: All_Test_Widget(
//                                               globals.existing_dataset)),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
//                           child: Container(
//                             height: 220,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Select Payment Method',
//                                       style: TextStyle(
//                                         fontSize: 20.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 20.0),
//                                 DropdownButtonFormField<String>(
//                                   value: selectedPaymentMethod,
//                                   items: paymentMethods.map((String method) {
//                                     return DropdownMenuItem<String>(
//                                       value: method,
//                                       child: Text(method),
//                                     );
//                                   }).toList(),
//                                   onChanged: (String? newValue) {
//                                     setState(() {
//                                       selectedPaymentMethod = newValue;
//                                     });
//                                   },
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: 'Payment Method',
//                                   ),
//                                 ),
//                                 SizedBox(height: 20.0),
//                                 selectedPaymentMethod != null
//                                     ? Padding(
//                                         padding: const EdgeInsets.all(4.0),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Container(
//                                               width: 100,
//                                               child: MediaQuery(
//                                                 data: MediaQuery.of(context)
//                                                     .copyWith(
//                                                         textScaleFactor: 1.0),
//                                                 child: Text(
//                                                   selectedPaymentMethod ==
//                                                           "Cash"
//                                                       ? "Cash Payment"
//                                                       : "Online Payment",
//                                                   style: TextStyle(
//                                                     fontSize: 15,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Container(
//                                                 width: 150,
//                                                 padding: EdgeInsets.all(
//                                                     8.0), // Optional: Add padding if needed
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                     color: Color.fromARGB(
//                                                         255,
//                                                         211,
//                                                         206,
//                                                         206), // Set your border color
//                                                     width:
//                                                         2.0, // Set your border width
//                                                   ),
//                                                 ),
//                                                 child: Center(
//                                                   child: Text(
//                                                     '\u{20B9} ' +
//                                                         globals.total_price,
//                                                     style: TextStyle(
//                                                         color: Color.fromARGB(
//                                                             255, 78, 75, 75),
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                 )),
//                                           ],
//                                         ),
//                                       )
//                                     : Container()
//                               ],
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 200,
//                                 child: MediaQuery(
//                                   data: MediaQuery.of(context)
//                                       .copyWith(textScaleFactor: 1.0),
//                                   child: const Text(
//                                     "Total Payable Amount: ",
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         color: Colors.pink,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                               Spacer(),
//                               MediaQuery(
//                                 data: MediaQuery.of(context)
//                                     .copyWith(textScaleFactor: 1.0),
//                                 child: Text(
//                                   '\u{20B9} ' + globals.total_price,
//                                   style: const TextStyle(
//                                       color: Colors.pink,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: 350,
//                           color: selectedPaymentMethod != null
//                               ? Color(0xff123456)
//                               : Colors.grey,
//                           child: TextButton(
//                               child: MediaQuery(
//                                 data: MediaQuery.of(context)
//                                     .copyWith(textScaleFactor: 1.0),
//                                 child: const Text(
//                                   "Pay",
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 // Bill_Desk_Transaction(context);
//                                 Accept_Permission();
//                                 // selectedPaymentMethod != null
//                                 //     ? Accept_Permission()
//                                 //     : null;
//                                 // PineLab_Transaction(context);
//                               }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
//
// Saving_Message() {
//   return Fluttertoast.showToast(
//       msg: "Bill Generating,\n don't click the back button",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Color.fromARGB(255, 12, 192, 123),
//       textColor: Colors.white,
//       fontSize: 16.0);
// }
//
// Successtoaster1() {
//   return Fluttertoast.showToast(
//       msg: "Sample Collected Successfully",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Color.fromARGB(255, 93, 204, 89),
//       textColor: Colors.white,
//       fontSize: 16.0);
// }
