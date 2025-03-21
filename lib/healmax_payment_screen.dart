import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'bill_details.dart';
import 'dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'nm_payment_screen.dart';

TextEditingController cash_Controller = TextEditingController();
TextEditingController card_Controller = TextEditingController();

class healmax_payment_screen extends StatefulWidget {
  @override
  _healmax_payment_screen createState() => _healmax_payment_screen();
}

class _healmax_payment_screen extends State<healmax_payment_screen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

    if (cash_Controller.text == "0" && card_Controller.text == "0") {
      cash_card = "0";
    }

    var Card_Cash_Value = 0;
    globals.PaymentMode = mode;
    if (mode == 4) {
      cash_Controller.text = "";
    } else {
      card_Controller.text = "";
    }

    Card_Cash_Value = int.parse(cash_card);

    globals.glb_Due_Amount = int.parse(globals.total_price) - Card_Cash_Value;

    if (Card_Cash_Value > int.parse(globals.total_price)) {
      cash_Controller.text = "";
      card_Controller.text = "";

      setState(() {
        globals.glb_Due_Amount = int.parse(globals.total_price);
      });

      Card_Cash_Message();
    } else {
      globals.glb_Card_Cash_Saving_Amount = Card_Cash_Value;
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

  bool isButtonDisabled = false;
  Future<void> FunctionForWaiting() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true;
      });
      Pay_Function(context);
      print("clicked");
      Future.delayed(Duration(seconds: 15), () {
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

  @override
  void initState() {
    globals.glb_Due_Amount = int.parse(globals.total_price);
    cash_Controller.text = "";
    card_Controller.text = "";
    globals.glb_Card_Cash_Saving_Amount = 0;

    globals.glb_ConcessionAmount = 0;
    globals.glb_ConcessionPlusCash = 0;
    globals.glb_ConcessionPercentage = 0;
    globals.Selected_Auth = null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    const Text('HealMax Transaction'),
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
                  Container(
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
                                  SizedBox(
                                    width: 120,
                                    height: 30,
                                    child: MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: TextField(
                                        readOnly: false,
                                        controller: cash_Controller,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType
                                            .number, // Show numeric keyboard
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(
                                                  r'[0-9]')), // Allow digits only
                                        ],
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Cash Amount',
                                            labelStyle:
                                                TextStyle(fontSize: 10)),

                                        onChanged: (content) {
                                          Cash_Card(cash_Controller.text, 1);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType
                                                  .number, // Show numeric keyboard
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
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
                                                Cash_Card(
                                                    card_Controller.text, 4);
                                              },
                                            ),
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
                  Container(
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
