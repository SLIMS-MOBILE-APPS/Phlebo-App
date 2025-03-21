import 'package:flutter/material.dart';
import 'package:phleboapp/specialilty.dart';
import 'tenet_neworder_transaction.dart';
import 'transaction_new_order.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

TextEditingController Select_Serv_nameController = TextEditingController();

var myList = [];

var myList_Dublicate = [];

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    DeleteRecord(obj) {
      for (int i = 0; i <= myList.length - 1; i++) {
        if (obj["SERVICE_ID"] == myList[i]["SERVICE_ID"]) {
          myList.remove(myList[i]);
        }
        setState(() {
          Search();
        });
      }
    }

    All_Test_Widget(var data, BuildContext context) {
      Delete_Permission(data) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
            // title: const Text(
            //     'AlertDialog Title'),
            //title: SizedBox(height: 10),
            content: Center(
              heightFactor: 1,
              child: Container(
                height: 70,
                child: Column(
                  children: [
                    MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
                              DeleteRecord(data);
                              Navigator.pop(context);
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

      return SingleChildScrollView(
        child: Container(
          child: Column(
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
                          height: 130,
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 35,
                                        child: IconButton(
                                          onPressed: () {
                                            Delete_Permission(i);
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(
                                            i["SERVICE_NAME"],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      MediaQuery(
                                        data: MediaQuery.of(context)
                                            .copyWith(textScaleFactor: 1.0),
                                        child: Text(
                                          i["PRICE"].toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Spacer(),
                                      Container(
                                        width: 125,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(
                                            "Discount:",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                      i["OFFER_CONCESSION"] == null
                                          ? MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: Text(
                                                "0",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          : MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: Text(
                                                i["OFFER_CONCESSION"]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Spacer(),
                                      Container(
                                        width: 125,
                                        child: MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(
                                            "Net Amount:",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: Text(
                                                "0",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          : MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: Text(
                                                i["SRV_NET_PRICE"].toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 35,
                                        ),
                                        MediaQuery(
                                          data: MediaQuery.of(context)
                                              .copyWith(textScaleFactor: 1.0),
                                          child: Text(
                                            "Specimen Name:",
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        (i["SPECIMEN_NAME"] == null
                                            ? MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(""))
                                            : MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(
                                                  i["SPECIMEN_NAME"],
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              )),
                                        Spacer(),
                                        (i["VACCUTAINER"] == null
                                            ? Text("")
                                            : MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(
                                                  i["VACCUTAINER"],
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              )),
                                      ],
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     // Checkbox(
                                  //     //   // checkColor: Colors.blue,
                                  //     //   // focusColor: Colors.blue,
                                  //     //   activeColor: Colors.blue,
                                  //     //   onChanged: (bool? value) {},
                                  //     //   value: true,
                                  //     // ),
                                  //     Spacer(),
                                  //     IconButton(
                                  //       onPressed: () {
                                  //         Delete_Permission(i);
                                  //       },
                                  //       icon: Icon(
                                  //         Icons.cancel,
                                  //         color: Colors.red,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
            ],
          ),
        ),
      );
    }

    function_widet() {
      return All_Test_Widget(myList, context);
    }

    Getpackagedata(service_id) async {
      Map data = {
        "srvidnew": service_id.toString(),
        "tariffid": "",
        "connection": globals.Connection_Flag
      };
      print(data.toString());
      final response = await http.post(
          Uri.parse(globals.API_url +
              '/mobile/api/PhleboHomeCollection/GetInculdesSub'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        var pkgdata = jsonDecode(response.body)["result"];
        for (int i = 0; i < pkgdata.length; i++) {
          // Check if an item with the same SERVICE_ID already exists in myList
          bool exists = myList.any(
              (element) => element["SERVICE_ID"] == pkgdata[i]["SERVICE_ID"]);

          if (exists) {
            // Remove the item with the same SERVICE_ID from myList
            myList.removeWhere(
                (element) => element["SERVICE_ID"] == pkgdata[i]["SERVICE_ID"]);
            myList.add({
              'SERVICE_ID': pkgdata[i]["SERVICE_ID"],
              'SPECIMEN_NAME': pkgdata[i]["SPECIMEN_NAME"],
              'SERVICE_NAME': pkgdata[i]["SERVICE_NAME"],
              'PRICE': pkgdata[i]["PRICE"],
              'OFFER_CONCESSION': pkgdata[i]["OFFER_CONCESSION"],
              'SRV_NET_PRICE': pkgdata[i]["SRV_NET_PRICE"],
              'VACCUTAINER': pkgdata[i]["VACCUTAINER"],
              'SPECIMEN_ID': pkgdata[i]["SPECIMEN_ID"],
              'VACCUTAINER_ID': pkgdata[i]["VACCUTAINER_ID"],
              'SERVICECLASS_ID': pkgdata[i]["SERVICECLASS_ID"],
              'SRV_PKG_ID': pkgdata[i]["SRV_PKG_ID"]
            });
          } else {
            // Add the item only if it doesn't already exist
            myList.add({
              'SERVICE_ID': pkgdata[i]["SERVICE_ID"],
              'SPECIMEN_NAME': pkgdata[i]["SPECIMEN_NAME"],
              'SERVICE_NAME': pkgdata[i]["SERVICE_NAME"],
              'PRICE': pkgdata[i]["PRICE"],
              'OFFER_CONCESSION': pkgdata[i]["OFFER_CONCESSION"],
              'SRV_NET_PRICE': pkgdata[i]["SRV_NET_PRICE"],
              'VACCUTAINER': pkgdata[i]["VACCUTAINER"],
              'SPECIMEN_ID': pkgdata[i]["SPECIMEN_ID"],
              'VACCUTAINER_ID': pkgdata[i]["VACCUTAINER_ID"],
              'SERVICECLASS_ID': pkgdata[i]["SERVICECLASS_ID"],
              'SRV_PKG_ID': pkgdata[i]["SRV_PKG_ID"]
            });
          }
        }

        if (resposne["message"] == "DATA FOUND") {
          //  function_widet();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        } else {}
      }
    }

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
          'SERVICECLASS_ID': obj.SERVICECLASS_ID,
          'SRV_PKG_ID': 0
        });
        // myList_Dublicate.addAll(myList);
      } else {
        return errormsg();
        //keep toaster
      }
      if (obj.SERVICE_TYPE_ID == 6 || obj.SERVICE_TYPE_ID == 7) {
        Getpackagedata(obj.SERVICE_ID);
      }
      function_widet();
    }

    Continue() {
      var amount = 0;
      var specimen_id = '';
      var vaccutainer_id = '';
      for (int i = 0; i <= myList.length - 1; i++) {
        if (myList[i]['SPECIMEN_ID'].toString() == null ||
            myList[i]['SPECIMEN_ID'].toString() == 'null') {
          specimen_id += '0' + ',';
        } else {
          specimen_id += myList[i]['SPECIMEN_ID'].toString() + ',';
        }
        if (myList[i]['VACCUTAINER_ID'].toString() == null ||
            myList[i]['VACCUTAINER_ID'].toString() == 'null') {
          vaccutainer_id += '0' + ',';
        } else {
          vaccutainer_id += myList[i]['VACCUTAINER_ID'].toString() + ',';
        }

        globals.VACCUTAINER_CUNT_for_New_Order += '1' + ',';
        globals.Barcode_for_New_Order += 'on' + ',';
        globals.SERVICE_ID_by_new_order_with_all_Service_id +=
            myList[i]['SERVICE_ID'].toString() + ",";
        if (myList[i]["SRV_PKG_ID"].toString() == "0") {
          globals.SERVICE_ID_by_new_order +=
              myList[i]['SERVICE_ID'].toString() + ",";
        }
        globals.SPECIMEN_ID_by_new_order = specimen_id;
        //(myList[i]['SPECIMEN_ID'].toString() + ",");
        globals.VACCUTAINER_ID_by_new_order = vaccutainer_id;
        //   myList[i]['VACCUTAINER_ID'].toString() + ",";
        globals.SERVICE_NAME_by_new_order +=
            myList[i]['SERVICE_NAME'].toString() + ",";

        globals.SPECIMEN_NAME_by_new_order +=
            myList[i]['SPECIMEN_NAME'].toString() + ",";

        globals.VACCUTAINER_by_new_order +=
            myList[i]['VACCUTAINER'].toString() + ",";
        if (myList[i]["SRV_PKG_ID"].toString() == "0") {
          globals.Billing_pricenew += myList[i]['PRICE'].toString() + ',';
        }

        // (myList[i]["SRV_NET_PRICE"].toString() == null ||
        //         myList[i]["SRV_NET_PRICE"].toString() == "null")
        //     ? myList[i]['PRICE'].toString() + ','
        //     : myList[i]["SRV_NET_PRICE"].toString() + ',';

        amount = amount +
            double.parse((myList[i]['SRV_NET_PRICE'].toString() == null ||
                        myList[i]['SRV_NET_PRICE'].toString() == "null")
                    ? myList[i]['PRICE'].toString()
                    : myList[i]['SRV_NET_PRICE'].toString())
                .toInt();
      }
      globals.Price_new_order = amount;
    }
//............................................Search_Purpose.

    Widget Search_Widget(var data, BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300,
              height: 40,
              child: InkWell(
                  onTap: () {
                    Select_Serv_nameController.text = "";

                    Add_NewTest(data);
                    // setState(() {
                    //   Search();
                    // });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Search()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text(data.SERVICE_NAME.toString())),
                  ))),
          Divider()
        ],
      );
    }

    ListView Search_ListView(data, BuildContext context) {
      if (data != null) {
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Search_Widget(data[index], context);
            });
      }
      return ListView();
    }

    Future<List<Search_Data_Model>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "columnName": "SERVICE_NAME",
        "prefixtext": Select_Serv_nameController.text,
        "sessionID": globals.session_id,
        "locID": globals
            .LOCATION_ID_new_order, //Location id coming from speciality screen
        "cmpID": globals.COMPANY_ID.toString() == ""
            ? "0"
            : globals.COMPANY_ID.toString(), //client id
        "patientype": "0",
        "channelID": globals.ID,
        //channel ID this is coming from spciality screen, drowpdown
        "refdocID": globals
            .REFRL_ID, //Refr ID this is coming from spciality screen, Selecting option
        "flag": "Debit",
        "cncsnruleID": "10",
        "dscntplcysrvID": globals.discount_policy_id,
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
            .map((strans) => Search_Data_Model.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget Search_verticalList = Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: FutureBuilder<List<Search_Data_Model>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              return SizedBox(child: Search_ListView(data, context));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );

//............................................Search_Purpose

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
          appBar: AppBar(
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.add_circle_outline_sharp),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
            backgroundColor: Color(0xff123456),
            automaticallyImplyLeading: false,
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
                myList.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Spaciality()),
                );
              },
            ),
            // Builder(
            //   builder: (BuildContext context) {
            //     return IconButton(
            //       icon: Container(
            //         decoration: const BoxDecoration(
            //             image: DecorationImage(
            //                 image: AssetImage('images/home visit.png'),
            //                 fit: BoxFit.fitWidth)),
            //       ),
            //       onPressed: () {
            //         Scaffold.of(context).openDrawer();
            //       },
            //       tooltip:
            //           MaterialLocalizations.of(context).openAppDrawerTooltip,
            //     );
            //   },
            // ),
            title: Row(
              children: [
                MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text("Select Services"))
              ],
            ),
          ),
          drawer: DrawerForAll(),
          endDrawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: TextField(
                            controller: Select_Serv_nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Search Services',
                            ),
                            onChanged: (text) {
                              (Select_Serv_nameController.text.length >= 3)
                                  ? setState(
                                      () {
                                        Search();
                                      },
                                    )
                                  : Container();
                            }),
                      ),
                    ),
                  ),
                  Container(child: Search_verticalList)
                ]),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Color.fromARGB(255, 101, 140, 178),
              child: Column(children: [
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
                                    globals.family_members_user_name.length <=
                                            35
                                        ? MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: Text(globals
                                                .family_members_user_name))
                                        : MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: Text(globals
                                                .family_members_user_name
                                                .substring(0, 35)),
                                          ),
                                    Spacer(),
                                    MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Text(globals.family_members_age
                                              .split(',')[0] +
                                          " Years,"),
                                    ),
                                    globals.family_members_gender == "1"
                                        ? MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
                                            child: Text("Male"))
                                        : MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(textScaleFactor: 1.0),
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
                                                style: TextStyle(fontSize: 10))
                                            : Text(globals
                                                .family_members_user_email)),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        String Number =
                                            globals.family_members_user_phone;
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
                                  child:
                                      Text(globals.family_members_area_name)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                myList.length == 0
                    ? Container(
                        height: 485,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Column(
                            children: [
                              Builder(
                                  builder: (context) => (InkWell(
                                        onTap: () => Scaffold.of(context)
                                            .openEndDrawer(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14)),
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                          height: 160,
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, bottom: 15),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.add_circle_outline,
                                                  size: 50,
                                                ),
                                                MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text(
                                                    "No services selected",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text(
                                                    "Cliek here to Add",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )))
                            ],
                          ),
                        ),
                      )
                    : Container(height: 485, child: function_widet()),
                myList.length == 0
                    ? Container(
                        width: 360,
                        color: Color.fromARGB(255, 152, 161, 170),
                        child: TextButton(
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {}),
                      )
                    : Container(
                        width: 360,
                        color: Color(0xff123456),
                        child: TextButton(
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Continue();
                              myList;
                              globals.Glb_NAVIGATION == "TENET"
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              tenet_neworder_transaction()),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Phlebo_Transaction_by_New_Order()),
                                    );
                            }),
                      )
              ]),
            ),
          )),
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

class Search_Data_Model {
  final SERVICE_ID;
  final SERVICE_CD;
  final SERVICE_NAME;
  final VACCUTAINER;
  final DOSAGE_QTY;
  final SPECIMEN_ID;
  final SPECIMEN_NAME;
  final VACCUTAINER_NAME;
  final VACCUTAINER_ID;
  final VAR_BAR_CD;
  final SERVICE_TYPE_ID;
  final SERVICE_TYPE_NAME;
  final SERVICE_GROUP_ID;
  final SERVICE_GROUP;
  final SERVICECLASS_ID;
  final CONSULTATION_TYPE_ID;
  final DOCTOR_ID;
  final PATIENT_CLASS_ID;
  final EFFECT_FROM_D;
  final EFFECT_TO_DT;
  final RECORD_STATUS;
  final IS_FOREIGN_SERVICE;
  final IS_NUR_STATION;
  final PRICE;
  final ORG_PRICE;
  final DOCTOR_PRICE;
  final OFFER_CONCESSION;
  final SRV_NET_PRICE;
  final IS_OFFER_SRV;
  final MARKET_RATE;
  final TARIFF_ID;
  final CONCESSION;
  final IS_CLINICAL_HIST_REQ;
  final IS_MANDATORY_PRE_RE;
  final SCHEDULE_MASTER_ID;
  final NOTE_NAME;
  final CHISTORY_TEXT;
  final GENDER_ID;
  final PROC_LOGISTICS;
  final REPORT_DISPATCH_TIME;
  final HISTORY_TYPE;
  final HISTORY_TYPE_ID;
  final CNCSN_PERCENT;
  final CNCSN_AMT;
  final REF_CONC;
  final REF_CONC_AMT;
  final IS_FAVOURITE;
  final IS_QUANTITY_EDIT;
  final CONSENT_LETTER_PATH;
  final IS_SCHEDULE_MASTER;
  final TARIFF_NAME;
  final CGST_AMT;
  final SGST_AMT;
  final IGST_AMT;
  final DISC_PERCENTAGE;
  final GST_PCT;
  final CGST_PCT;
  final SGST_PCT;
  final IGST_PCT;
  final HOME_VISIT_SERVICE;
  final PKG_OR_NOT;
  final PKG_SRV_NAME;
  final RAD_SRV;
  final TEST_TYPE_NAME;

  Search_Data_Model({
    required this.SERVICE_ID,
    required this.SERVICE_CD,
    required this.SERVICE_NAME,
    required this.VACCUTAINER,
    required this.DOSAGE_QTY,
    required this.SPECIMEN_ID,
    required this.SPECIMEN_NAME,
    required this.VACCUTAINER_NAME,
    required this.VACCUTAINER_ID,
    required this.VAR_BAR_CD,
    required this.SERVICE_TYPE_ID,
    required this.SERVICE_TYPE_NAME,
    required this.SERVICE_GROUP_ID,
    required this.SERVICE_GROUP,
    required this.SERVICECLASS_ID,
    required this.CONSULTATION_TYPE_ID,
    required this.DOCTOR_ID,
    required this.PATIENT_CLASS_ID,
    required this.EFFECT_FROM_D,
    required this.EFFECT_TO_DT,
    required this.RECORD_STATUS,
    required this.IS_FOREIGN_SERVICE,
    required this.IS_NUR_STATION,
    required this.PRICE,
    required this.ORG_PRICE,
    required this.DOCTOR_PRICE,
    required this.OFFER_CONCESSION,
    required this.SRV_NET_PRICE,
    required this.IS_OFFER_SRV,
    required this.MARKET_RATE,
    required this.TARIFF_ID,
    required this.CONCESSION,
    required this.IS_CLINICAL_HIST_REQ,
    required this.IS_MANDATORY_PRE_RE,
    required this.SCHEDULE_MASTER_ID,
    required this.NOTE_NAME,
    required this.CHISTORY_TEXT,
    required this.GENDER_ID,
    required this.PROC_LOGISTICS,
    required this.REPORT_DISPATCH_TIME,
    required this.HISTORY_TYPE,
    required this.HISTORY_TYPE_ID,
    required this.CNCSN_PERCENT,
    required this.CNCSN_AMT,
    required this.REF_CONC,
    required this.REF_CONC_AMT,
    required this.IS_FAVOURITE,
    required this.IS_QUANTITY_EDIT,
    required this.CONSENT_LETTER_PATH,
    required this.IS_SCHEDULE_MASTER,
    required this.TARIFF_NAME,
    required this.CGST_AMT,
    required this.SGST_AMT,
    required this.IGST_AMT,
    required this.DISC_PERCENTAGE,
    required this.GST_PCT,
    required this.CGST_PCT,
    required this.SGST_PCT,
    required this.IGST_PCT,
    required this.HOME_VISIT_SERVICE,
    required this.PKG_OR_NOT,
    required this.PKG_SRV_NAME,
    required this.RAD_SRV,
    required this.TEST_TYPE_NAME,
  });

  factory Search_Data_Model.fromJson(Map<String, dynamic> json) {
    return Search_Data_Model(
      SERVICE_ID: json['SERVICE_ID'],
      SERVICE_CD: json['SERVICE_CD'],
      SERVICE_NAME: json['SERVICE_NAME'],
      VACCUTAINER: json['VACCUTAINER'],
      DOSAGE_QTY: json['DOSAGE_QTY'],
      SPECIMEN_ID: json['SPECIMEN_ID'],
      SPECIMEN_NAME: json['SPECIMEN_NAME'],
      VACCUTAINER_NAME: json['VACCUTAINER_NAME'],
      VACCUTAINER_ID: json['VACCUTAINER_ID'],
      VAR_BAR_CD: json['VAR_BAR_CD'],
      SERVICE_TYPE_ID: json['SERVICE_TYPE_ID'],
      SERVICE_TYPE_NAME: json['SERVICE_TYPE_NAME'],
      SERVICE_GROUP_ID: json['SERVICE_GROUP_ID'],
      SERVICE_GROUP: json['SERVICE_GROUP'],
      SERVICECLASS_ID: json['SERVICECLASS_ID'],
      CONSULTATION_TYPE_ID: json['CONSULTATION_TYPE_ID'],
      DOCTOR_ID: json['DOCTOR_ID'],
      PATIENT_CLASS_ID: json['PATIENT_CLASS_ID'],
      EFFECT_FROM_D: json['EFFECT_FROM_D'],
      EFFECT_TO_DT: json['EFFECT_TO_DT'],
      RECORD_STATUS: json['RECORD_STATUS'],
      IS_FOREIGN_SERVICE: json['IS_FOREIGN_SERVICE'],
      IS_NUR_STATION: json['IS_NUR_STATION'],
      PRICE: json['PRICE'],
      ORG_PRICE: json['ORG_PRICE'],
      DOCTOR_PRICE: json['DOCTOR_PRICE'],
      OFFER_CONCESSION: json['OFFER_CONCESSION'],
      SRV_NET_PRICE: json['SRV_NET_PRICE'],
      IS_OFFER_SRV: json['IS_OFFER_SRV'],
      MARKET_RATE: json['MARKET_RATE'],
      TARIFF_ID: json[' TARIFF_ID'],
      CONCESSION: json['CONCESSION'],
      IS_CLINICAL_HIST_REQ: json['IS_CLINICAL_HIST_REQ'],
      IS_MANDATORY_PRE_RE: json['IS_MANDATORY_PRE_RE'],
      SCHEDULE_MASTER_ID: json['SCHEDULE_MASTER_ID'],
      NOTE_NAME: json['NOTE_NAME'],
      CHISTORY_TEXT: json['CHISTORY_TEXT'],
      GENDER_ID: json['GENDER_ID'],
      PROC_LOGISTICS: json['PROC_LOGISTICS'],
      REPORT_DISPATCH_TIME: json['REPORT_DISPATCH_TIME'],
      HISTORY_TYPE: json['HISTORY_TYPE'],
      HISTORY_TYPE_ID: json['HISTORY_TYPE_ID'],
      CNCSN_PERCENT: json['CNCSN_PERCENT'],
      CNCSN_AMT: json['CNCSN_AMT'],
      REF_CONC: json['REF_CONC'],
      REF_CONC_AMT: json['REF_CONC_AMT'],
      IS_FAVOURITE: json['IS_FAVOURITE'],
      IS_QUANTITY_EDIT: json['IS_QUANTITY_EDIT'],
      CONSENT_LETTER_PATH: json['CONSENT_LETTER_PATH'],
      IS_SCHEDULE_MASTER: json['IS_SCHEDULE_MASTER'],
      TARIFF_NAME: json['TARIFF_NAME'],
      CGST_AMT: json['CGST_AMT'],
      SGST_AMT: json['SGST_AMT'],
      IGST_AMT: json['IGST_AMT'],
      DISC_PERCENTAGE: json['DISC_PERCENTAGE'],
      GST_PCT: json['GST_PCT'],
      CGST_PCT: json['CGST_PCT'],
      SGST_PCT: json['SGST_PCT'],
      IGST_PCT: json['IGST_PCT'],
      HOME_VISIT_SERVICE: json['HOME_VISIT_SERVICE'],
      PKG_OR_NOT: json['PKG_OR_NOT'],
      PKG_SRV_NAME: json['PKG_SRV_NAME'],
      RAD_SRV: json['RAD_SRV'],
      TEST_TYPE_NAME: json['TEST_TYPE_NAME'],
    );
  }
}

errormsg() {
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

errormsg2() {
  return Fluttertoast.showToast(
      msg: "Previously added service",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}
