import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'patient_details..dart';
import 'reason_reject.dart';
import 'home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as globals;
import 'models.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';

var BookingStatusLatLong = "";

class Phleb_Pending extends StatefulWidget {
  @override
  _Phleb_Pending createState() => _Phleb_Pending();
}

class _Phleb_Pending extends State<Phleb_Pending> {
  var myOrderList = [];

  int activeStep = 3;
  DateTime selectedDate = DateTime.now();
  int upperBound = 4;
  int _currentStep = 0;

  cancel() {
    _currentStep > 0
        ? setState(() => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Phlebo_Cancellation(),
            )))
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Phlebo_Cancellation(),
            ));
  }

  PhleboStatus(int value) async {
    var isLoading = true;
    Map data = {
      "tokenno":
          "AgBQBOvXLdwKAhlG1bamFxx8p9GkS3Q1riNmjYx2dWf4RPevTnu6mtCTPGllXP6wTfnKBqeGJaLLBON/VHoCtZdO75UR+w==",
      "assignid": globals.assign_phlebotomist_id,
      "status": value == 0
          ? "1"
          : value == 1
              ? "2"
              : value == 2
                  ? "3"
                  : Container(),
      "orderid": globals.order_id,
      "connection": globals.Connection_Flag
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url +
            '/mobile/api/PhleboHomeCollection/PhleboAcceptOrders'),
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
      Map<String, dynamic> user = resposne['result'][0];
      globals.glb_IS_DISCOUNT_NEED = user['IS_DISCOUNT_NEED'].toString();
      globals.glob_IS_REQ_BARCODE_BILLNO =
          user['IS_REQ_BARCODE_BILLNO'].toString();
      globals.glb_IS_REQ_DUE = user['IS_REQ_DUE'].toString();
      globals.Glb_Is_Req_Wallet = user['Is_Req_Wallet'].toString();

      globals.Glb_Payment_Key = user['Payment_Key'].toString();
      globals.Glb_Payment_Marchant_Name =
          user['Payment_Marchant_Name'].toString();
      globals.Glb_Payment_Marchant_Contact_No =
          user['Payment_Marchant_Contact_No'].toString();
      globals.Glb_Payment_Marchant_Email_Id =
          user['Payment_Marchant_Email_Id'].toString();

      globals.Glb_IS_REQ_BARCODE_Scan_Manual =
          user['IS_REQ_BARCODE_Scan_Manual'].toString();

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhleboHome(0),
          ));
    } else {}
  }

  PhleboStatus_3(int value) async {
    var isLoading = true;
    Map data = {
      "tokenno":
          "AgBQBOvXLdwKAhlG1bamFxx8p9GkS3Q1riNmjYx2dWf4RPevTnu6mtCTPGllXP6wTfnKBqeGJaLLBON/VHoCtZdO75UR+w==",
      "assignid": globals.assign_phlebotomist_id,
      "status": value == 0
          ? "1"
          : value == 1
              ? "2"
              : value == 2
                  ? "3"
                  : Container(),
      "orderid": globals.order_id,
      "connection": globals.Connection_Flag
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url +
            '/mobile/api/PhleboHomeCollection/PhleboAcceptOrders'),
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
      Map<String, dynamic> user = resposne['result'][0];
      globals.glb_IS_DISCOUNT_NEED = user['IS_DISCOUNT_NEED'].toString();
      globals.glb_IS_REQ_DUE = user['IS_REQ_DUE'].toString();
      globals.glob_IS_REQ_BARCODE_BILLNO =
          user['IS_REQ_BARCODE_BILLNO'].toString();

      globals.Glb_Is_Req_Wallet = user['Is_Req_Wallet'].toString();

      globals.Glb_Payment_Key = user['Payment_Key'].toString();
      globals.Glb_Payment_Marchant_Name =
          user['Payment_Marchant_Name'].toString();
      globals.Glb_Payment_Marchant_Contact_No =
          user['Payment_Marchant_Contact_No'].toString();
      globals.Glb_Payment_Marchant_Email_Id =
          user['Payment_Marchant_Email_Id'].toString();

      globals.Glb_IS_REQ_BARCODE_Scan_Manual =
          user['IS_REQ_BARCODE_Scan_Manual'].toString();

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Phlebo_Pat_Details(),
          ));
    } else {}
  }

  Widget Application_Widget(var data, BuildContext context) {
    Push_Notification_Method1(BuildContext context) async {
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
        "STATUS_FLAG": "1",
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
      setState(() => PhleboStatus(0));
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        if (jsonDecode(response.body)["message"] != "success") {
          return false;
        }
      }
    }

    Push_Notification_Method2(BuildContext context) async {
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
        "STATUS_FLAG": "2",
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
      setState(() => PhleboStatus(1));
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        if (jsonDecode(response.body)["message"] != "success") {
          setState(() => PhleboStatus(1));
          return false;
        }
      }
    }

    Push_Notification_Method3(BuildContext context) async {
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
        "STATUS_FLAG": "3",
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
      setState(() => PhleboStatus_3(2));
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        if (jsonDecode(response.body)["message"] != "success") {
          return false;
        }
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
      setState(() => PhleboStatus_3(2));
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        if (jsonDecode(response.body)["message"] != "success") {
          return false;
        }
      }
    }

    NOTIFICATION() {
      data.status <= 3
          ? data.status == 0
              ? setState(() => Push_Notification_Method1(context))
              : data.status == 1
                  ? setState(() => Push_Notification_Method2(context))
                  : data.status == 2
                      ? setState(() => Push_Notification_Method3(context))
                      : data.status == 3
                          ? setState(() => Push_Notification_Method4(context))
                          : Container()
          : Container();
    }

    continued() {
      globals.Glb_DUE_RECOVERED = data.QR_IMG.toString();
      globals.glb_QR_IMG = data.QR_IMG.toString();;
      globals.glb_umr_no = data.umr_no;
      globals.LOC_ID = data.LOC_ID.toString();
      globals.glb_REFERAL_SOURCE_ID = data.REFERAL_SOURCE_ID.toString();
      globals.flag_check = "";
      globals.customer_name = data.customer_name.toString();
      globals.order_no = data.order_no.toString();
      globals.order_id = data.order_id.toString();
      globals.customer_mobile_no = data.customer_mobile_no.toString();
      globals.order_date = data.order_date.toString();
      globals.schedule_dt = data.schedule_dt.toString();
      globals.CHANNEL = data.CHANNEL.toString();
      globals.REFERAL_DOCTOR = data.REFERAL_DOCTOR.toString();
      globals.customer_address = data.customer_address.toString();
      globals.service_name = data.service_name.toString();

      globals.PAID_AMOUNT_VALIDATION = data.PAID_AMOUNT.toString();

      globals.PAID_AMOUNT = data.PAID_AMOUNT.toString();
      globals.outstanding_due = data.outstanding_due.toString();
      globals.customer_gender = data.customer_gender.toString();
      globals.customer_age = data.customer_age.toString();
      globals.assign_phlebotomist_id = data.assign_phlebotomist_id.toString();
      globals.REFERAL_SOURCE_ID = data.REFERAL_SOURCE_ID.toString();
      globals.CLIENT_ID = data.CLIENT_ID.toString();
      // globals.CLIENT_ID = data.DISCOUNT_POLICY_ID.toString();
      globals.Billing_servicevacs = "";
      globals.Billing_servicespec = "";
      globals.Billing_serviceids = "";
      globals.Billing_servicePrice = "";
      globals.existing_dataset = [];

      globals.total_price = "";
      globals.barcode = "";
      globals.vac_count = "";
      globals.customer_id = data.customer_id.toString();
      NOTIFICATION();
    }

//workprogress
    void PatientStatusChecking() {
      if (globals.Glb_myOrderList[0]["status"] <= data.status) {
        // errormsg();

        continued();
      } else {
        continued();

        // errormsg1();
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
                      'Do you want to Accept this order?',
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
                            PatientStatusChecking();
                            //continued();

                            globals.existing_dataset = [];
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

    Start_Permission() {
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
                      'Do you want to Start this order?',
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
                            PatientStatusChecking();
                            //continued();
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

    Reached_Permission() {
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
                      'Are you sure you have reached?',
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
                            PatientStatusChecking();
                            //continued();
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

    Complete_Permission() {
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
                      'Do you want to Complete this order?',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            PatientStatusChecking();
                            //continued();
                          },
                          child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text("No"))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            continued();
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

    Reject_Permission() {
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
                      'Are you sure you want reject?',
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
                            globals.customer_name =
                                data.customer_name.toString();
                            globals.order_id = data.order_id.toString();

                            globals.order_no = data.order_no.toString();

                            globals.schedule_dt = data.schedule_dt.toString();

                            globals.customer_mobile_no =
                                data.customer_mobile_no.toString();

                            globals.CHANNEL = data.CHANNEL.toString();

                            globals.REFERAL_DOCTOR =
                                data.REFERAL_DOCTOR.toString();

                            globals.customer_address =
                                data.customer_address.toString();

                            globals.customer_age = data.customer_age.toString();

                            globals.customer_gender =
                                data.customer_gender.toString();

                            globals.order_date = data.order_date.toString();
                            globals.SESSION_ID = data.SESSION_ID.toString();

                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Phlebo_Cancellation()),
                            );
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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String dynamicText =
        data.service_name; // Replace this with your dynamic incoming text

    List<String> parts = dynamicText.split('*');

    Widget textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts.map((part) {
        return Text(
          part,
          style: TextStyle(fontSize: 11, color: Colors.black),
        );
      }).toList(),
    );
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


    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Container(
              width: screenWidth * 1.0, // 80% of the screen width
              // height: screenHeight * 0.5, // 30% of the screen height
              // height: height / 2.1,
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
                              Icon(Icons.person, size: 15),
                              data.customer_name.length <= 40
                                  ? MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(data.customer_name))
                                  : MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(
                                          data.customer_name.substring(0, 40))),
                              Spacer(),
                              SizedBox(
                                height: 30,
                                child: IconButton(
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0))),
                                          contentPadding: EdgeInsets.only(
                                              top: 20.0,
                                              left: 20.0,
                                              right: 20.0),
                                          content: Container(
                                            // height: 350,
                                            height: height / 1.8,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: height / 4,
                                                    child: Card(
                                                      elevation: 6,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 10.0,
                                                                    top: 5),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(Icons
                                                                        .person),
                                                                    data.customer_name.length <=
                                                                            16
                                                                        ? MediaQuery(
                                                                            data:
                                                                                MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                            child:
                                                                                Text(data.customer_name.toString(), style: TextStyle(fontSize: 12)),
                                                                          )
                                                                        : MediaQuery(
                                                                            data:
                                                                                MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                            child:
                                                                                Text(data.customer_name.toString().substring(0, 16), style: TextStyle(fontSize: 12)),
                                                                          ),
                                                                    Spacer(),
                                                                    MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              textScaleFactor: 1.0),
                                                                      child: Text(
                                                                          data.customer_age.split(',')[0] +
                                                                              " Years,",
                                                                          style:
                                                                              TextStyle(fontSize: 12)),
                                                                    ),
                                                                    data.customer_gender.toString() ==
                                                                            "1"
                                                                        ? MediaQuery(
                                                                            data:
                                                                                MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                            child:
                                                                                Text("Male", style: TextStyle(fontSize: 12)),
                                                                          )
                                                                        : MediaQuery(
                                                                            data:
                                                                                MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                            child:
                                                                                Text("Female", style: TextStyle(fontSize: 12)),
                                                                          ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              textScaleFactor: 1.0),
                                                                      child: Text(
                                                                          data.order_no
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 12)),
                                                                    ),
                                                                    Spacer(),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        String
                                                                            Number =
                                                                            data.customer_mobile_no;
                                                                        _callNumber(
                                                                            Number);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.phone_in_talk,
                                                                            size:
                                                                                15,
                                                                            color:
                                                                                Colors.blue[200],
                                                                          ),
                                                                          MediaQuery(
                                                                            data:
                                                                                MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                                            child: Text(data.customer_mobile_no.toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
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
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right:
                                                                        10.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              textScaleFactor: 1.0),
                                                                      child:
                                                                          Text(
                                                                        "Booked Date:",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              textScaleFactor: 1.0),
                                                                      child:
                                                                          Text(
                                                                        data.order_date,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              textScaleFactor: 1.0),
                                                                      child:
                                                                          Text(
                                                                        "Schedule Date:",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              textScaleFactor: 1.0),
                                                                      child:
                                                                          Text(
                                                                        data.schedule_dt,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 10.0,
                                                              right: 10.0,
                                                              top: 5.0,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              textScaleFactor: 1.0),
                                                                      child: Text(data
                                                                          .CHANNEL
                                                                          .toString()),
                                                                    ),
                                                                    MediaQuery(
                                                                      data: MediaQuery.of(
                                                                              context)
                                                                          .copyWith(
                                                                              textScaleFactor: 1.0),
                                                                      child: Text(data
                                                                          .REFERAL_DOCTOR
                                                                          .toString()),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 10.0,
                                                                    top: 5),
                                                            child: Container(
                                                              height: 40,
                                                              child: MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                        textScaleFactor:
                                                                            1.0),
                                                                child: Text(
                                                                    data.customer_address
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12)),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        MediaQuery(
                                                            data: MediaQuery.of(
                                                                    context)
                                                                .copyWith(
                                                                    textScaleFactor:
                                                                        1.0),
                                                            child: Text(
                                                                "Test Details"))
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 100,
                                                      width: 250,
                                                      child: Card(
                                                        elevation: 6,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          width /
                                                                              2,
                                                                      child: MediaQuery(
                                                                          data: MediaQuery.of(context).copyWith(
                                                                              textScaleFactor:
                                                                                  1.0),
                                                                          child:
                                                                              textWidget), //this is a widget
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0,
                                                              top: 5),
                                                      child: Container(
                                                        height: 20,
                                                        child: MediaQuery(
                                                          data: MediaQuery.of(
                                                                  context)
                                                              .copyWith(
                                                                  textScaleFactor:
                                                                      1.0),
                                                          child: Text(
                                                              data.CLINLICAL_SUMMARY
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.menu_sharp,
                                      color: Colors.blue[200],
                                    )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.order_no)),
                              Spacer(),
                              Container(
                                width: 20,
                                height: 20,
                                child: FloatingActionButton(
                                  child: FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 10,
                                  ),
                                  backgroundColor: Colors.green.shade800,
                                  onPressed: () {
                                    String phoneNumber = data.customer_mobile_no
                                        .toString(); // Replace with the actual phone number
                                    String text = Uri.encodeComponent("Hello");
                                    String url =
                                        "https://wa.me/$phoneNumber/?text=$text";
                                    launch(url);
                                  },
                                ),
                              ),
                              SizedBox(width: 25),
                              InkWell(
                                onTap: () {
                                  String Number = data.customer_mobile_no;
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
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(data.customer_mobile_no,
                                          style: TextStyle(
                                            color: Colors.blue[200],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text("Booked Date:")),
                              Spacer(),
                              MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.order_date.toString()))
                            ],
                          ),
                          Row(
                            children: [
                              MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text("Schedule Date:")),
                              Spacer(),
                              MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.schedule_dt))
                            ],
                          )
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text(data.CHANNEL.toString())),
                              MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: data.REFERAL_DOCTOR != "null" ||
                                          data.REFERAL_DOCTOR != null
                                      ? Text(data.REFERAL_DOCTOR)
                                      : Container())
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5),
                      child: Container(
                        height: 30,
                        child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(data.customer_address)),
                      ),
                    ),
                    Container(
                      width: screenWidth * 5.3,
                      height: screenHeight * 0.25,
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Stepper(
                          margin: EdgeInsets.all(0),
                          type: StepperType.horizontal,
                          controlsBuilder: (context, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    String Number = data.customer_mobile_no;
                                    _callNumber(Number);
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.phone),
                                      MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text('Phone')),
                                    ],
                                  ),
                                ),
                                data.status == 0
                                    ? MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: TextButton(
                                          onPressed: Accept_Permission,
                                          child: MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: Column(
                                              children: [
                                                Icon(Icons.handshake),
                                                MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Text('Accept')),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : data.status == 1
                                        ? MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: TextButton(
                                              onPressed: Start_Permission,
                                              child: MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Column(
                                                  children: [
                                                    Icon(Icons.pedal_bike),
                                                    MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                textScaleFactor:
                                                                    1.0),
                                                        child: Text('Start')),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : data.status == 2
                                            ? MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: TextButton(
                                                    onPressed:
                                                        Reached_Permission,
                                                    child: MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Icon(Icons.home),
                                                          MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      textScaleFactor:
                                                                          1.0),
                                                              child: Text(
                                                                  "Reached"))
                                                        ],
                                                      ),
                                                    )),
                                              )
                                            : data.status == 3
                                                ? MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: TextButton(
                                                        onPressed:
                                                            Complete_Permission,
                                                        child: MediaQuery(
                                                          data: MediaQuery.of(
                                                                  context)
                                                              .copyWith(
                                                                  textScaleFactor:
                                                                      1.0),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Icon(Icons
                                                                  .thumb_up),
                                                              MediaQuery(
                                                                  data: MediaQuery.of(
                                                                          context)
                                                                      .copyWith(
                                                                          textScaleFactor:
                                                                              1.0),
                                                                  child: Text(
                                                                      "Yes"))
                                                            ],
                                                          ),
                                                        )),
                                                  )
                                                : Container(),
                                globals.glb_IS_REQ_Reject == "Y"
                                    ? MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: TextButton(
                                            onPressed: Reject_Permission,
                                            child: MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(Icons.cancel_outlined),
                                                  MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: Text("Rejected"))
                                                ],
                                              ),
                                            )),
                                      )
                                    : Container(),
                              ],
                            );
                          },
                          physics: ScrollPhysics(),
                          currentStep: data.status,
                          onStepContinue: continued,
                          onStepCancel: cancel,
                          steps: <Step>[
                            Step(
                              title: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text('Accepted',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ))),
                              content: Container(
                                  alignment: Alignment.center,
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      "Do you want to Accept?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                              isActive: data.status >= 1,
                              state: data.status >= 1
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text('Started',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ))),
                              content: Container(
                                  alignment: Alignment.center,
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      "Do you want to Start?",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              isActive: data.status >= 2,
                              state: data.status >= 2
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text('Reached',
                                          style: TextStyle(
                                            fontSize: 12,
                                          )))),
                              content: Container(
                                  alignment: Alignment.center,
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      "Are you Reached the patient place? ",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              isActive: data.status >= 3,
                              state: data.status >= 3
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: Icon(
                                Icons.thumb_up,
                                color: Colors.green,
                                size: 12,
                              ),
                              content: Container(
                                  alignment: Alignment.center,
                                  child: MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text("Do you want to complete?"))),
                              isActive: data.status >= 4,
                              state: data.status >= 3
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView Application_ListView(data, BuildContext context) {
    if (data != null) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Application_Widget(data[index], context);
          });
    }
    return ListView();
  }

  Future<List<Pending_Data_Model>> _fetchSaleTransaction() async {
    var jobsListAPIUrl = null;
    var dsetName = '';
    List listresponse = [];

    Map data = {
      "tokenno": globals.PASSWORD,
      "userid": globals.USER_ID,
      "address": "",
      "pincode": "",
      "customername": "",
      "frdate": globals.selectDate == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : globals.selectDate,
      "todate": globals.selectDate == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : globals.selectDate,
      "connection": globals.Connection_Flag
    };

    dsetName = 'result';
    jobsListAPIUrl = Uri.parse(globals.API_url +
        '/mobile/api/PhleboHomeCollection/GetPhleboPendingOrders');

    var response = await http.post(jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
//workprogress
      globals.Glb_myOrderList = [];
      var pkgdata = jsonDecode(response.body)["result"];
      for (int i = 0; i <= pkgdata.length - 1; i++) {
        globals.Glb_myOrderList.add({
          'status': pkgdata[i]["status"],
          'order_id': pkgdata[i]["order_id"],
        });
      }

      Map<String, dynamic> user = resposne['result'][0];
      // globals.glb_Order_Checking_status = user['status'].toString();
      // globals.glb_REFERAL_SOURCE_ID = user['REFERAL_SOURCE_ID'].toString();
      BookingStatusLatLong = "Y";
      List jsonResponse = resposne["result"];

      return jsonResponse
          .map((strans) => Pending_Data_Model.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  @override
  void initState() {
    // Call the superclass' initState method
    super.initState();
    globals.Glb_myOrderList = [];
    BookingStatusLatLong = "";
  }

  Widget build(BuildContext context) {
    Widget verticalList3 = Container(
      color: Color.fromARGB(255, 101, 140, 178),
      child: FutureBuilder<List<Pending_Data_Model>>(
          future:
              (BookingStatusLatLong != "Y") ? _fetchSaleTransaction() : null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              return SizedBox(child: Application_ListView(data, context));
            } else if (snapshot.hasError) {
              return NoContent3();
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );

    return Container(child: verticalList3);
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

_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}

errormsg1() {
  return Fluttertoast.showToast(
      msg: "First complete first one",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg() {
  return Fluttertoast.showToast(
      msg: "you can continue",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}
