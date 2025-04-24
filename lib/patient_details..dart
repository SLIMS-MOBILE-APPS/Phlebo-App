import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'bill_details.dart';
import 'reason_cancellation.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'models.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

TextEditingController PatnameController = TextEditingController();
TextEditingController vaccutainer_count_Controller = TextEditingController();
TextEditingController textEditingController = TextEditingController();
var Orderalling = "";

class Phlebo_Pat_Details extends StatefulWidget {
  @override
  _Phlebo_Pat_Details createState() => _Phlebo_Pat_Details();
}

class _Phlebo_Pat_Details extends State<Phlebo_Pat_Details> {
  int Vaccutainer_Value = 0;
  var text;
  @override
  void initState() {
    // Call the superclass' initState method
    super.initState();
    // textEditingController.text = "";
    Orderalling = "";
  }

  int Total_Vaccutainer_Value = 0;

  bool isChecked = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

  Cancel_Permission() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
        content: Center(
          heightFactor: 1,
          child: Container(
            height: 70,
            child: Column(
              children: [
                const Text(
                  'Are you sure you want cancel?',
                  style: TextStyle(color: Colors.red),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Phlebo_Test_Cancellation()),
                          );
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Add_Test_Permission() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
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
                    'Do you want to Add test?',
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

                          _scaffoldKey.currentState!.openEndDrawer();
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

  Cancel(BuildContext context) async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return Center(
    //       child: CircularProgressIndicator(), // or any other loader widget
    //     );
    //   },
    // );

    var isLoading = true;

    Map data = {
      "IP_USER_ID": globals.SESSION_ID,
      "IP_BILL_ID": globals.order_id,
      "IP_SERVICE_ID": globals.Cancel_SERVICE_ID,
      "connection": globals.Connection_Flag
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/CANCEL_SERVICE'),
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
      Orderalling = "";
      globals.Cancel_SERVICE_ID = "";
      globals.Billing_servicevacs = "";
      globals.Billing_servicespec = "";
      globals.Billing_serviceids = "";
      globals.Billing_servicePrice = "";
      globals.total_price = "";
      globals.barcode = "";
      globals.vac_count = "";
      globals.existing_dataset = [];

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Phlebo_Pat_Details()));
      // if (resposne["message"] == "DATA FOUND") {
      //   Orderalling = "";
      //   globals.Cancel_SERVICE_ID = "";
      //   globals.Billing_servicevacs = "";
      //   globals.Billing_servicespec = "";
      //   globals.Billing_serviceids = "";
      //   globals.Billing_servicePrice = "";
      //   globals.total_price = "";
      //   globals.barcode = "";
      //   globals.vac_count = "";
      //   globals.existing_dataset = [];

      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => Phlebo_Pat_Details()));
      //   // Navigator.pop(context); // Dismiss the loader
      // } else {}
    }
  }

  Add_Test_After_Click_Function() async {
    globals.flag_check = "";
    globals.existing_dataset = [];
    var isLoading = true;
    globals.schedule_address == null ? '' : globals.schedule_address;

    Map data = {
      "sessionID": globals.SESSION_ID,
      "tokenno": globals.PASSWORD,
      "testid": globals.Service_Id_Add_Test,
      "username": globals.USER_ID,
      "orderno": globals.order_id,
      "itemnetamount": globals.Service_Id_Add_Price,
      "ScheduleDate": "",
      "ScheduleAddress": globals.schedule_address,
      "ordertype": "1",
      "servicestatus": "M",
      "connection": globals.Connection_Flag
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url +
            '/mobile/api/PhleboHomeCollection/AddMobileServicestoorder'),
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
      globals.Billing_serviceids = "";
      globals.Billing_servicespec = "";
      globals.Billing_servicevacs = "";
      globals.vac_count = '';
      globals.barcode = '';
      globals.Billing_servicePrice = "";
      globals.existing_dataset = [];
      globals.total_price = "";
      globals.existing_dataset = [];
      if (resposne["message"] == "DATA FOUND") {
        globals.Service_Id_Add_Test = "";
        if (jsonDecode(response.body)['result'][0]['message'] == "" ||
            jsonDecode(response.body)['result'][0]['message'] == null) {
          PatnameController.text = "";

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Phlebo_Pat_Details()));
        } else {
          errormsg1();
        }
      } else {}
    }
  }

  var list = [];

  Widget Add_Test_Widget(var data, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: width / 1,
            height: height / 25,
            child: InkWell(
                onTap: () {
                  globals.Service_Id_Add_Test = data.SERVICE_ID.toString();
                  globals.Service_Id_Add_Price = data.PRICE.toString();

                  Add_Test_After_Click_Function();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(data.SERVICE_NAME.toString())),
                ))),
        Divider()
      ],
    );
  }

  ListView Add_Test_ListView(data, BuildContext context) {
    if (data != null) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Add_Test_Widget(data[index], context);
          });
    }
    return ListView();
  }

  Future<List<Searcing_Test_Data_Model>>
      _Add_Test_fetchSaleTransaction() async {
    var jobsListAPIUrl = null;
    var dsetName = '';
    List listresponse = [];

    Map data = {
      "columnName": "SERVICE_NAME",
      "prefixtext": PatnameController.text,
      "sessionID": globals.session_id,
      "locID": globals.LOC_ID,
      "cmpID":
          globals.CLIENT_ID == "null" ? "0" : globals.CLIENT_ID, //client id,
      "patientype": "0",
      "channelID": globals.REFERAL_SOURCE_ID, //channel id
      "refdocID": "0",
      "flag": "Debit",
      "cncsnruleID": "0",
      "dscntplcysrvID": globals.DISCOUNT_POLICY_ID,
      "cmpwardID": "0",
      "Homeserviceflag": "",
      "connection": globals.Connection_Flag
    };

    dsetName = 'result';
    jobsListAPIUrl = Uri.parse(
        globals.API_url + '/mobile/api/Patient/GetDiscntApplicableServices');

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
          .map((strans) => Searcing_Test_Data_Model.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  _Add_Test_fetchSaleTransaction1() {}

  Widget Application_Widget(var data, BuildContext context, int index) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    Delete_Permission() {
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
                      'Do you want to remove this test?',
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
                            globals.Cancel_SERVICE_ID =
                                data.SERVICE_ID.toString();

                            Cancel(context);
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

    void _onTextChanged(String value) {
      if (value.isNotEmpty) {
        setState(() {
          globals.readonly = true;
        });
      } else {
        setState(() {
          globals.readonly = false;
        });
      }
    }

    int Total_Vaccutainer_Value = 0; // Initialize total value

    return Container(
        child: Column(
      children: [
        Container(
            // height: height / 5.9,
            // width: width / 1.05,

            width: screenWidth * 1.0, // 80% of the screen width
            height: screenHeight * 0.2, // 30% of the screen height

            child: data.CLASS_SERVICE_ID == null
                ? Center(
                    child:
                        Text("No Data Found", style: TextStyle(fontSize: 24)))
                : Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //workprogresss
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      child: Column(
                                        children: List.generate(
                                            1,
                                            (index) => CheckboxListTile(
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  dense: true,
                                                  value: data.checkval,
                                                  onChanged: (value) {
                                                    globals.flag_check = "Y";
                                                    setState(() {});
                                                    data.checkval = value;

                                                    if (globals.existing_dataset
                                                        .contains(data)) {
                                                      globals.existing_dataset
                                                          .remove(data);
                                                    } else {
                                                      // globals.existing_dataset
                                                      //     .addAll(globals.packageList);
                                                      globals.existing_dataset
                                                          .add(data);
                                                    }
                                                  },
                                                )
                                            // : Container()

                                            ),
                                      ),
                                    ),
                                    Container(
                                      // width: 130,
                                      child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: data.CLASS_SERVICE_ID == 0 &&
                                                  data.SERVICE_TYPE_ID == 6
                                              ? Text(
                                                  data.SERVICE_NAME.toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                )
                                              : data.CLASS_SERVICE_ID == 0
                                                  ? Text(
                                                      data.SERVICE_NAME
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )
                                                  : Text(
                                                      data.SERVICE_NAME
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blue,
                                                      ),
                                                    )),
                                    ),
                                    Spacer(),
                                    data.CLASS_SERVICE_ID == 0
                                        ? IconButton(
                                            onPressed: () {
                                              Delete_Permission();
                                            },
                                            icon: Icon(
                                              Icons.cancel_presentation,
                                              color: Color.fromARGB(
                                                  255, 232, 13, 21),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Row(
                              children: [
                                data.SPECIMEN_NAME == null
                                    ? Container(
                                        width: 40,
                                      )
                                    : MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Container(
                                            width: 40,
                                            child: Text("Specimen:",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                )),
                                          ),
                                        ),
                                      ),
                                data.SPECIMEN_NAME == null
                                    ? Container(
                                        width: 40,
                                      )
                                    : MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: Container(
                                          // width: 40,
                                          child: Text(
                                              data.SPECIMEN_NAME.toString(),
                                              style: TextStyle(
                                                fontSize: 8,
                                              )),
                                        ),
                                      ),
                                Spacer(),
                                data.VACCUTAINER_NAME == null
                                    ? Container(
                                        width: 50,
                                      )
                                    : MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: Container(
                                          width: 50,
                                          child: Text("Vaccutainer:",
                                              style: TextStyle(
                                                fontSize: 8,
                                              )),
                                        ),
                                      ),
                                data.VACCUTAINER_NAME == null
                                    ? Container(
                                        width: 110,
                                      )
                                    : MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: Container(
                                          // width: 110,
                                          child: Text(
                                              data.VACCUTAINER_NAME.toString(),
                                              style: TextStyle(
                                                fontSize: 8,
                                              )),
                                        ),
                                      ),
                                MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: data.SRV_NET_PRICE == null
                                      ? Text(
                                          '\u{20B9} ' "0",
                                          style: TextStyle(
                                            fontSize: 8,
                                          ),
                                        )
                                      : Text(
                                          '\u{20B9} ' +
                                              data.SRV_NET_PRICE.toString(),
                                          style: TextStyle(
                                            fontSize: 8,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Scaner Work
                              globals.Glb_IS_REQ_BARCODE_Scan_Manual == "N"
                                  ? data.ScandingBardCode.toString() != ""
                                      ? Text(
                                          data.ScandingBardCode.toString(),
                                          style: TextStyle(fontSize: 12),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            textEditingController.clear();
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: TextField(
                                                    controller:
                                                        textEditingController,
                                                    onChanged: (value) {
                                                      if (value.length <= 8 &&
                                                          RegExp(r'^[0-9]*$')
                                                              .hasMatch(
                                                                  value)) {
                                                        textEditingController
                                                                .value =
                                                            TextEditingValue(
                                                          text: value,
                                                          selection: TextSelection
                                                              .collapsed(
                                                                  offset: value
                                                                      .length),
                                                        );
                                                        if (value.length == 8) {
                                                          setState(() {
                                                            data.ScandingBardCode =
                                                                value;
                                                          });
                                                        }
                                                      } else if (value.length >
                                                          8) {
                                                        textEditingController
                                                                .value =
                                                            TextEditingValue(
                                                          text: value.substring(
                                                              0, 8),
                                                          selection:
                                                              TextSelection
                                                                  .collapsed(
                                                                      offset:
                                                                          8),
                                                        );
                                                      }
                                                    },
                                                    keyboardType: TextInputType
                                                        .number, // Set keyboard type to only allow numbers
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      height: 2.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                          child: Text('Close'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              barcodeResults
                                                                  .add({
                                                                'barcodeResult':
                                                                    data.ScandingBardCode,
                                                                'serviceId': data
                                                                    .SERVICE_ID
                                                                    .toString()
                                                              });
                                                              Navigator.pop(
                                                                  context);

                                                              Phlebo_Pat_Details();
                                                            });
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text('BC Enter Here'),
                                        )
                                  : Container(),
                              globals.Glb_IS_REQ_BARCODE_Scan_Manual == "Y"
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QRViewExample(
                                                        serviceId: data
                                                            .SERVICE_ID
                                                            .toString(),
                                                      )));
                                        });
                                      },
                                      icon: Icon(
                                        Icons.qr_code_scanner,
                                        color: Colors.blue,
                                      ),
                                    )
                                  : Container(),
                              //Scaner Work
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
      ],
    ));
  }

  ListView Application_ListView(data, BuildContext context) {
    if (barcodeResults.length > 0) {
      for (var map1 in data) {
        for (var map2 in barcodeResults) {
          if (map1.SERVICE_ID.toString() == map2['serviceId']) {
            map1.ScandingBardCode = map2['barcodeResult'];
          }
        }
      }
    }
    if (data != null) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Application_Widget(data[index], context, index);
          });
    }

    return ListView();
  }

  Future<List<Test_Displays_Data_Model>>
      _Add_Test_Display_fetchSaleTransaction() async {
    var jobsListAPIUrl = null;
    var dsetName = '';
    List listresponse = [];

    Map data = {
      "tokenno": globals.PASSWORD,
      "orderid": globals.order_id,
      "userid": globals.USER_ID,
      "connection": globals.Connection_Flag
    };

    dsetName = 'result';
    jobsListAPIUrl = Uri.parse(
        globals.API_url + '/mobile/api/Patient/GetMobileOrderAjustsample');

    var response = await http.post(jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

//Package Work Start

      // Map<String, dynamic> responseData = jsonDecode(response.body);

      // for (int i = 0; i < responseData["result"].length; i++) {
      //   Map<String, dynamic> user2 = resposne['result'][i];
      //   globals.Glb_CLASS_SERVICE_ID = user2['CLASS_SERVICE_ID'].toString();
      //   if (globals.Glb_CLASS_SERVICE_ID == "33103") {
      //     Map<String, dynamic> item = resposne['result'][i];
      //     globals.packageList.add(item);
      //   }
      // }

      //Package Work Closed

      Map<String, dynamic> user1 = resposne['result'][0];
      globals.glb_IMG_PATH = user1['IMG_PATH'].toString();
      Orderalling = "Z";
      // Map<String, dynamic> user =
      //     (resposne['result'][0]["message"] != "Invalid Order")
      //         ? resposne['result'][0]
      //         : Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => Phlebo_Dashboard())); //breakfunc();

      var amount = 0;

      globals.existing_dataset = [];

      List jsonResponse = resposne["result"];

      return jsonResponse
          .map((strans) => Test_Displays_Data_Model.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  bool _checkbox = false;
  breakfunc() {
    breakfunc();

    return false;
  }

  abc() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    Widget Add_Test_verticalList = Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: FutureBuilder<List<Searcing_Test_Data_Model>>(
          future: (PatnameController.text.length >= 3)
              ? _Add_Test_fetchSaleTransaction()
              : _Add_Test_fetchSaleTransaction1(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent();
              }
              var data = snapshot.data;
              return SizedBox(child: Add_Test_ListView(data, context));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
              color: Colors.red,
            ));
          }),
    );

    Widget verticalList36 = Container(
      child: FutureBuilder<List<Test_Displays_Data_Model>>(
          future: (globals.existing_dataset.length == 0)
              ? _Add_Test_Display_fetchSaleTransaction()
              : abc(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent();
              }

              var data = snapshot.data;
              return SizedBox(child: Application_ListView(data, context));
            } else if (snapshot.hasError) {
              return NoContent();
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );

    void callClassMethod(String searchText) {
      // Check if the entered text has at least 3 characters
      if (searchText.length >= 3) {
        setState(() {});
      }
    }

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
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            backgroundColor: Color(0xff123456),
            actions: <Widget>[
              globals.PAID_AMOUNT_VALIDATION != "0.0"
                  ? Container()
                  : TextButton(
                      onPressed: () {
                        PatnameController.text = "";
                        Add_Test_Permission();
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.plus_one,
                            color: Colors.white,
                          ),
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(
                              "Add Test",
                              style: TextStyle(
                                  fontFamily: 'Fjalla One',
                                  fontSize: 10,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ))
            ],
            title: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text('Patient Details')),
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
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text("Select Services"))
                  ],
                ),
              ),
              body: SingleChildScrollView(
                child: Column(children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: SizedBox(
                  //     width: 300,
                  //     height: 50,
                  //     child: TextField(
                  //       controller: nameController,
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(),
                  //         labelText: 'Search Services',
                  //       ),
                  //       // onChanged: (text) {
                  // setState(() {});
                  //       // }
                  //     ),
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: TextField(
                        controller: PatnameController,
                        onChanged: (text) {
                          callClassMethod(text);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Search Services',
                        ),
                      ),
                    ),
                  ),
                  Container(
                      child: (PatnameController.text.length >= 3)
                          ? Add_Test_verticalList
                          : Container())
                ]),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(255, 101, 140, 178),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Container(
                      width: screenWidth * 1.0, // 80% of the screen width
                      height: screenHeight * 0.25, // 30% of the screen height

                      // height: height / 2.9,
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 30, child: Icon(Icons.person)),
                                  globals.customer_name.length <= 25
                                      ? MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(globals.customer_name))
                                      : MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(globals.customer_name
                                              .substring(0, 25)),
                                        ),
                                  Spacer(),
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                        globals.customer_age.split(',')[0] +
                                            " Years,"),
                                  ),
                                  globals.customer_gender == "1"
                                      ? MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: Text("Male")))
                                      : Text("Female"),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 30),
                                  MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(globals.order_no)),
                                  Spacer(),
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
                                              .copyWith(textScaleFactor: 1.0),
                                          child:
                                              Text(globals.customer_mobile_no,
                                                  style: TextStyle(
                                                    color: Colors.blue[200],
                                                  )),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 30),
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      "Booked Date:",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Spacer(),
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      globals.order_date,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 30),
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: const Text(
                                      "Schedule Date:",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Spacer(),
                                  MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(
                                      globals.schedule_dt,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(globals.CHANNEL)),
                                      Text(globals.REFERAL_DOCTOR)
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 30),
                                  Container(
                                    // height: screenHeight * 0.2,
                                    width: screenWidth * 0.8,
                                    child: MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: Text(globals.customer_address,
                                            style: TextStyle(fontSize: 12))),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: 70,
                              //   child: Card(
                              //       color: Color.fromARGB(255, 210, 223, 213),
                              //       elevation: 6,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(15.0),
                              //       ),
                              //       child: Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.start,
                              //         children: [
                              //           Spacer(),
                              //           // dfdgdgdfgsg
                              //           TextButton(
                              //               onPressed: () {
                              //                 PatnameController.text = "";
                              //                 Add_Test_Permission();
                              //               },
                              //               child: Column(
                              //                 children: [
                              //                   Icon(Icons.plus_one),
                              //                   MediaQuery(
                              //                     data: MediaQuery.of(context)
                              //                         .copyWith(
                              //                             textScaleFactor: 1.0),
                              //                     child: Text(
                              //                       "Add Test",
                              //                       style: TextStyle(
                              //                           fontFamily:
                              //                               'Fjalla One'),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ))
                              //         ],
                              //       )),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(height: screenHeight * 0.52, child: verticalList36),
                  globals.existing_dataset.length == 0
                      ? Container(
                          width: screenWidth * 1.0,
                          color: Colors.grey,
                          child: TextButton(
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0),
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {}),
                        )
                      : Container(
                          width: screenWidth * 1.0,
                          color: Color(0xff123456),
                          child: TextButton(
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0),
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  Getselectdata(context);
                                });
                              }),
                        )
                ],
              ),
            ),
          ),
        ));
  }
}

Getselectdata(context) {
  var spec_ids = "";
  var vac_ids = "";
  var service_ids = "";
  var prices = "";
  var amount = 0;
  var manualbarcode = "";
  for (int i = 0; i <= globals.existing_dataset.length - 1; i++) {
    if (globals.existing_dataset[i].SPECIMEN_ID.toString() == 'null' ||
        globals.existing_dataset[i].SPECIMEN_ID.toString() == null) {
      spec_ids += '0' + ',';
    } else {
      spec_ids += globals.existing_dataset[i].SPECIMEN_ID.toString() + ',';
    }
    if (globals.existing_dataset[i].VACCUTAINER_ID.toString() == 'null' ||
        globals.existing_dataset[i].VACCUTAINER_ID.toString() == null) {
      vac_ids += '0' + ',';
    } else {
      vac_ids += globals.existing_dataset[i].VACCUTAINER_ID.toString() + ',';
    }
    service_ids += globals.existing_dataset[i].SERVICE_ID.toString() + ',';
    prices += globals.existing_dataset[i].PRICE.toString() + ',';

    if (globals.existing_dataset[i].ScandingBardCode.toString() == '' ||
        globals.existing_dataset[i].VACCUTAINER_ID.toString() == null) {
      manualbarcode += '0' + ',';
    } else {
      manualbarcode +=
          globals.existing_dataset[i].ScandingBardCode.toString() + ",";
    }
    globals.glb_manualbarcode = manualbarcode;

    globals.SPECIMEN_IDS = globals.existing_dataset[i].SPECIMEN_IDS.toString();
    globals.SERVICE_IDS = globals.existing_dataset[i].SERVICE_IDS.toString();
    globals.PRICES = globals.existing_dataset[i].PRICES.toString();
    globals.PRICE = globals.existing_dataset[i].PRICE.toString();
    globals.SERVICE_NAME = globals.existing_dataset[i].SERVICE_NAME.toString();
    globals.SRV_NET_PRICE =
        globals.existing_dataset[i].SRV_NET_PRICE.toString();
    globals.DUE_BILL = globals.existing_dataset[i].DUE_BILL.toString();
    amount = amount +
        double.parse(globals.existing_dataset[i].PRICE.toString()).toInt();
  }

  globals.Billing_servicePrice = prices;

  globals.Billing_serviceids = service_ids;

  globals.Billing_servicespec = spec_ids;
  globals.Billing_servicevacs = vac_ids;

  globals.total_price = amount.toString();

  globals.VACCUTAINER_IDS = vac_ids;
  globals.vac_count = "";
  globals.barcode = "";
  for (int i = 0; i <= vac_ids.split(',').length - 2; i++) {
    globals.vac_count += '1' + ',';
    globals.barcode += 'on' + ',';
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Phlebo_Bill_Details()),
  );
}

List<Map<String, dynamic>> barcodeResults = [];

class QRViewExample extends StatefulWidget {
  final String serviceId;

  QRViewExample({required this.serviceId});

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  String barcodeResult = 'No barcode scanned';

  Future<void> scanBarcode() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    setState(() {
      barcodeResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xff123456),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blueAccent, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_scanner,
                        size: 80, color: Colors.blueAccent),
                    SizedBox(height: 10),
                    Text(
                      barcodeResult,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: scanBarcode,
                child: Text('Scan Barcode'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    globals.Glb_barcodeResult_Variable = barcodeResult;
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Phlebo_Pat_Details()),
                    );
                  });
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoContent extends StatelessWidget {
  const NoContent();

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

errormsg1() {
//  globals.flag_check = "";

  return Fluttertoast.showToast(
      msg: "This test already added",
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
