import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'new_order.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'home.dart';
import 'package:new_version_plus/new_version_plus.dart';

var datasetval = [];
var dashboardcalling = "";

class Phlebo_Dashboard extends StatefulWidget {
  const Phlebo_Dashboard({Key? key}) : super(key: key);

  @override
  State<Phlebo_Dashboard> createState() => _Phlebo_DashboardState();
}

class _Phlebo_DashboardState extends State<Phlebo_Dashboard> {
  var date = "";
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2026),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        globals.selectDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  int selectedIndex = 0;
  var selecteFromdt = '';
  var selecteTodt = '';
  bool pressAttention = false;
  @override
  void checkForUpdates(BuildContext context) async {
    VersionStatus? status = await NewVersionPlus().getVersionStatus();
    if (status?.localVersion != status?.storeVersion) {
      // Update the flag to indicate that the dialog has been shown

      NewVersionPlus().showUpdateDialog(
        context: context,
        dismissAction: () async {
          Navigator.of(context).pop(true);
        },
        dialogTitle: 'Update',
        dialogText:
            "A new version of the app is now available. Download the latest version from the Store.",
        versionStatus: status!,
      );
    }
  }

  void initState() {
    // Call the superclass' initState method
    super.initState();
    NewVersionPlus().getVersionStatus().then((status) {
      if (status?.localVersion != status?.storeVersion) {
        // Check if the dialog hasn't been shown before
        checkForUpdates(context);
      }
    });
    dashboardcalling = "";
  }

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    var date = "";
    DateTime selectedDate = DateTime.now();

    String _formattodate = new DateFormat.yMMMd().format(selectedDate);

    Widget Application_Widget(var data, BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      return SingleChildScrollView(
          child: GestureDetector(
              child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: InkWell(
            onTap: () {},
            child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Color.fromARGB(234, 189, 206, 198),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(
                              "WELCOME\n     TO ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.05,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.account_box_sharp),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(globals.USER_NAME,
                                style: TextStyle(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.05)),
                          ),
                        )
                      ],
                    ),
                  ]),
                )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            height: height / 8,
            width: width / 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Builder(
                builder: (context) => IconButton(
                  icon: Image(image: NetworkImage(globals.Logo)),
                  onPressed: () {},
                ),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Color.fromARGB(234, 189, 206, 198),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 4, 5, 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height / 13,
                            width: width / 1.2,
                            child: Card(
                              color: Colors.grey[200],
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color:
                                          Color.fromARGB(68, 160, 144, 144))),
                              child: Center(
                                child: globals.selectDate == ""
                                    ? MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: Text(
                                            "${selectedDate.toLocal()}"
                                                .split(' ')[0],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      )
                                    : Text(
                                        globals.selectDate,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                              ),
                            ),
                          )
                        ]),
                  ),
                  InkWell(
                    onTap: () {
                      data.PHLEBO_PENDING_CNT > 0
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhleboHome(0)),
                            )
                          : Container();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 9, 13, 3),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Icon(
                              Icons.directions_bike,
                              color: Color.fromARGB(255, 243, 137, 38),
                              size: screenWidth * 0.08,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text('Pending',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: screenWidth * 0.04)),
                            ),
                          ),
                          Spacer(),
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(data.PHLEBO_PENDING_CNT.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: screenWidth * 0.04)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Color.fromARGB(255, 216, 214, 214),
                    indent: 5,
                    endIndent: 5,
                  ),
                  InkWell(
                    onTap: () {
                      data.COMPLETED_CNT > 0
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhleboHome(1)),
                            )
                          : Container();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 3, 13, 3),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Icon(
                              Icons.verified_user,
                              color: Colors.blue[400],
                              size: screenWidth * 0.08,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text('Completed',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: screenWidth * 0.04)),
                            ),
                          ),
                          Spacer(),
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(data.COMPLETED_CNT.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: screenWidth * 0.04)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Color.fromARGB(255, 216, 214, 214),
                    indent: 5,
                    endIndent: 5,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     data.CANCEL_CNT > 0
                  //         ? Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => PhleboHome(2)),
                  //           )
                  //         : Container();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.fromLTRB(8, 3, 13, 3),
                  //     child: Row(
                  //       children: [
                  //         Padding(
                  //             padding: const EdgeInsets.only(left: 7),
                  //             child: FaIcon(
                  //               FontAwesomeIcons.trash,
                  //               color: Colors.blue[100],
                  //             )),
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 12),
                  //           child: MediaQuery(
                  //             data: MediaQuery.of(context)
                  //                 .copyWith(textScaleFactor: 1.0),
                  //             child: Text('Cancel',
                  //                 style: TextStyle(
                  //                     color: Colors.black,
                  //                     fontWeight: FontWeight.w400,
                  //                     fontSize: 15)),
                  //           ),
                  //         ),
                  //         Spacer(),
                  //         MediaQuery(
                  //           data: MediaQuery.of(context)
                  //               .copyWith(textScaleFactor: 1.0),
                  //           child: Text(data.CANCEL_CNT.toString(),
                  //               style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.w400,
                  //                   fontSize: 15)),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   thickness: 0.5,
                  //   color: Color.fromARGB(255, 216, 214, 214),
                  //   indent: 5,
                  //   endIndent: 5,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     data.REJECT_CNT > 0
                  //         ? Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => PhleboHome(3)),
                  //           )
                  //         : Container();
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.fromLTRB(8, 3, 13, 9),
                  //     child: Row(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 7),
                  //           child: Icon(
                  //             Icons.highlight_remove_outlined,
                  //             color: Colors.red,
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 12),
                  //           child: MediaQuery(
                  //             data: MediaQuery.of(context)
                  //                 .copyWith(textScaleFactor: 1.0),
                  //             child: Text('Rejected',
                  //                 style: TextStyle(
                  //                     color: Colors.black,
                  //                     fontWeight: FontWeight.w400,
                  //                     fontSize: 15)),
                  //           ),
                  //         ),
                  //         Spacer(),
                  //         MediaQuery(
                  //           data: MediaQuery.of(context)
                  //               .copyWith(textScaleFactor: 1.0),
                  //           child: Text(data.REJECT_CNT.toString(),
                  //               style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.w400,
                  //                   fontSize: 15)),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   thickness: 0.5,
                  //   color: Color.fromARGB(255, 216, 214, 214),
                  //   indent: 5,
                  //   endIndent: 5,
                  // ),

                  data.IS_REQ_NEWORDER == "Y"
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => New_Order()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 3, 13, 9),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Icon(
                                    Icons.new_label,
                                    color: Color.fromARGB(255, 11, 175, 33),
                                    size: screenWidth * 0.08,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text('New Order',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: screenWidth * 0.04)),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.double_arrow,
                                  color: Color.fromARGB(255, 214, 132, 132),
                                  size: screenWidth * 0.08,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
          child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Color.fromARGB(234, 189, 206, 198),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 4, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height / 17,
                              width: width / 1.2,
                              child: Card(
                                color: Colors.grey[200],
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color:
                                            Color.fromARGB(68, 160, 144, 144))),
                                child: Center(
                                    child: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Text("Total Orders",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                )),
                              ),
                            )
                          ]),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                data.TOTAL_CNT.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ])));
    }

    ListView Application_ListView(data, BuildContext context) {
      if (data != null) {
        return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Application_Widget(data[index], context);
            });
      }
      return ListView();
    }

    Future<List<Dashboard_Data_Model>> _fetchSaleTransaction() async {
      datasetval = [];
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "IP_USER_ID": globals.USER_ID,
        "IP_FROM_DT": globals.selectDate == ""
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : globals.selectDate,
        "IP_TO_DT": globals.selectDate == ""
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : globals.selectDate,
        "IP_TOKEN_NO": globals.PASSWORD,
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl = Uri.parse(globals.API_url +
          '/mobile/api/PhleboHomeCollection/Phlebo_Counts_Dashboard');

      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        Map<String, dynamic> user = resposne['result'][0];
        dashboardcalling = "Z";

        globals.Glb_NAVIGATION = user['NAVIGATION'].toString();
        globals.PHLEBO_PENDING_CNT = user['PHLEBO_PENDING_CNT'].toString();
        globals.REJECT_CNT = user['REJECT_CNT'].toString();
        globals.CANCEL_CNT = user['CANCEL_CNT'].toString();
        globals.COMPLETED_CNT = user['COMPLETED_CNT'].toString();
        globals.TOTAL_CNT = user['TOTAL_CNT'].toString();
        globals.SESSION_ID = user['SESSION_ID'].toString();
        globals.glb_IS_REQ_DUE = user['IS_REQ_DUE'].toString();
        globals.glb_IS_DISCOUNT_NEED = user['IS_DISCOUNT_NEED'].toString();
        globals.glb_IS_REQ_Reject = user['IS_REQ_Reject'].toString();
        globals.Glb_Is_Req_Wallet = user['Is_Req_Wallet'].toString();
        globals.Glb_IS_CARD_NEED = user['IS_CARD_NEED'].toString();
        globals.Glb_Payment_Key = user['Payment_Key'].toString();
        globals.Glb_Payment_Marchant_Name =
            user['Payment_Marchant_Name'].toString();
        globals.Glb_Payment_Marchant_Contact_No =
            user['Payment_Marchant_Contact_No'].toString();
        globals.Glb_Payment_Marchant_Email_Id =
            user['Payment_Marchant_Email_Id'].toString();

        globals.Glb_IS_REQ_BARCODE_Scan_Manual =
            user['IS_REQ_BARCODE_Scan_Manual'].toString();

        List jsonResponse = resposne["result"];
        datasetval = jsonDecode(response.body)["result"];
        return jsonResponse
            .map((strans) => Dashboard_Data_Model.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalList3 = Container(
      height: MediaQuery.of(context).size.height * 1,
      child: FutureBuilder<List<Dashboard_Data_Model>>(
          future: (dashboardcalling != "Z") ? _fetchSaleTransaction() : null,
          builder: (context, snapshot) {
            if (snapshot.hasData && datasetval.length > 0) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              return SizedBox(child: Application_ListView(data, context));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );
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
              backgroundColor: Color.fromARGB(255, 19, 102, 170),
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
              title: Row(
                children: [
                  SizedBox(width: 7),
                  Spacer(),
                  globals.selectDate == ""
                      ? MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: Text("${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        )
                      : MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: Text(
                            globals.selectDate,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                  SizedBox(width: 40),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Phlebo_Dashboard()),
                        );
                      },
                      icon: Icon(Icons.refresh),
                      color: Colors.white),
                  IconButton(
                      onPressed: () {
                        dashboardcalling = "";
                        _selectDate(context);
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                      color: Colors.white),
                ],
              ),
            ),
            drawer: DrawerForAll(),
            body: Container(child: verticalList3)),
      ),
    );
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
