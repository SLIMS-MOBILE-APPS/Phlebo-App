import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'select_services.dart';
import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

var functionCalls = "";
int selectedIndex = 0;
var selecteFromdt = '';
var selecteTodt = '';
String? gender;
TextEditingController spe_upd_nameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController dateInput = TextEditingController();
TextEditingController Referal_Name_Controller = TextEditingController();

class Spaciality extends StatefulWidget {
  const Spaciality({Key? key}) : super(key: key);

  @override
  State<Spaciality> createState() => _SpacialityState();
}

class _SpacialityState extends State<Spaciality> {
  Accept_Permission() {
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

  var _selectedItem;
  var _selectedItem1;
  var _selectedItem2;
  var _selectedItem3;
  var _selectedItem5;

  late Map<String, dynamic> map;
  late Map<String, dynamic> params;
  List data = []; //edi
  List data1 = []; //edi
  List data2 = []; //edi
  List data3 = []; //edi

  List data5 = []; //edii

  Select_Booking_Area() async {
    params = {
      "sessionID": globals
          .SESSION_ID, //SESSION_ID..........this is coming from Dashboard
      "agencyid":
          globals.AGENCY_ID //AGENCY_ID.........this is coming from phlebo login
      ,
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url +
            '/mobile/api/PhleboHomeCollection/GetAgencyareas'),
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
      globals.REF_DOCTOR_DESIGNATION = "";

      globals.COMPANY_NAME = "";
      functionCalls = "true";
    } else {
      globals.REF_DOCTOR_DESIGNATION = "";

      globals.COMPANY_NAME = "";
      functionCalls == "false";
    }
    setState(() {
      data = map["result"] as List;
    });

    return "Sucess";
  }

  Select_Location() async {
    params = {
      "sessionid":
          globals.SESSION_ID //SESSION_ID..........this is coming from Dashboard
      ,
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url +
            '/mobile/api/PhleboHomeCollection/GetOnlineLocation'),
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
      Map<String, dynamic> resposne = jsonDecode(response.body);
      Map<String, dynamic> user = resposne['result'][0];
      globals.REF_DOCTOR_DESIGNATION = "";

      globals.COMPANY_NAME = "";
      functionCalls = "true";
    } else {
      globals.REF_DOCTOR_DESIGNATION = "";

      globals.COMPANY_NAME = "";
      functionCalls == "false";
    }
    setState(() {
      data1 = map["result"] as List;
    });

    return "Sucess";
  }

  Select_Channel() async {
    params = {
      "sessionid":
          globals.SESSION_ID //SESSION_ID..........this is coming from Dashboard
      ,
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetChanelDetails'),
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
      Map<String, dynamic> resposne = jsonDecode(response.body);
      Map<String, dynamic> user = resposne['result'][0];

      globals.REF_DOCTOR_DESIGNATION = "";

      globals.COMPANY_NAME = "";
      functionCalls = "true";
    } else {
      globals.REF_DOCTOR_DESIGNATION = "";

      globals.COMPANY_NAME = "";
      functionCalls == "false";
    }
    setState(() {
      data2 = map["result"] as List;
    });

    return "Sucess";
  }

  Select_Discount_Policy() async {
    params = {
      "pageNum": "1",
      "pageSize": "100",
      "refferalSourceID":
          globals.ID, //ID ................this is coming from select chennel
      "columnName": "",
      "prefixText": "",
      "sessionID": globals
          .SESSION_ID, //SESSION_ID..........this is coming from Dashboard
      "locID": globals
          .LOCATION_ID_new_order, //LOCATION_ID........................this is coming from select location
      "advanceSearch": "",
      "referralID": globals
          .REFRL_ID //REFRL_ID........................this is coming from select Referal Doctor
      ,
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetDiscounts'),
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
      globals.REF_DOCTOR_DESIGNATION = "";

      globals.COMPANY_NAME = "";
      functionCalls = "true";
    } else {
      globals.REF_DOCTOR_DESIGNATION = "";

      globals.COMPANY_NAME = "";
      functionCalls == "false";
    }
    setState(() {
      data5 = map["result"] as List;
    });

    return "Sucess";
  }

  @override
  void initState() {
    Select_Booking_Area();
    Select_Location();
    Select_Channel();
    Select_Discount_Policy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //......................................client selection

    Widget Application_Widget(var data, BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300,
              height: 40,
              child: InkWell(
                  onTap: () {
                    spe_upd_nameController.text = "";
                    globals.COMPANY_NAME = data.COMPANY_NAME.toString();

                    globals.COMPANY_ID = data.COMPANY_ID.toString();

                    setState(() {
                      Spaciality();
                    });
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text(data.COMPANY_NAME.toString())),
                  ))),
          Divider()
        ],
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

    Future<List<Client_Selection_Data_Model>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "autherisationsrcId": "",
        "authtranId": "",
        "pageNum": "1",
        "pageSize": "100",
        "refferalSourceID": globals
            .ID, //ID......................this is coming from select chennel
        "columnName": "Company_Name",
        "prefixText": spe_upd_nameController.text,
        "sessionID": globals
            .SESSION_ID, //SESSION_ID..........this is coming from Dashboard
        "locationID": globals
            .LOCATION_ID_new_order, //LOCATION_ID...............this is coming from select location
        "tpaID": "",
        "flag": globals.ID == "18"
            ? "Corporate"
            : globals.ID == "19"
                ? "Insurance"
                : "",
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl =
          Uri.parse(globals.API_url + '/mobile/api/Patient/GetHospitalClients');

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
            .map((strans) => Client_Selection_Data_Model.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget Client_Selection_verticalList3 = Container(
      child: FutureBuilder<List<Client_Selection_Data_Model>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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

    Select_Client_Fun() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          content: Container(
            height: 300,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: TextField(
                        controller: spe_upd_nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Search here Client',
                        ),
                        onChanged: (text) {
                          setState(() {
                            Spaciality;
                          });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    child: Client_Selection_verticalList3,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

//......................................client selection finished

    //......................................Refferal Doctor Start

    Widget Refferal_Application_Widget(var data, BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300,
              height: 40,
              child: InkWell(
                  onTap: () {
                    Referal_Name_Controller.text = "";

                    globals.REF_DOCTOR_DESIGNATION =
                        data.REF_DOCTOR_DESIGNATION.toString();
                    globals.REFRL_ID = data.REFRL_ID.toString();

                    setState(() {
                      Spaciality();
                    });
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text(data.REFERAL_NAME.toString())),
                  ))),
          Divider()
        ],
      );
    }

    ListView Refferal_Application_ListView(data, BuildContext context) {
      if (data != null) {
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Refferal_Application_Widget(data[index], context);
            });
      }
      return ListView();
    }

    Future<List<Refferal__Data_Model>> _Refferal_fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "columnName": "", //What i pass here?
        "prefixtext": Referal_Name_Controller.text,
        "sessionID": globals
            .SESSION_ID //SESSION_ID..........this is coming from Dashboard
        ,
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl =
          Uri.parse(globals.API_url + '/mobile/api/Patient/GetTempDoctors');

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
            .map((strans) => Refferal__Data_Model.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget Refferal_Client_Selection_verticalList3 = Container(
      child: FutureBuilder<List<Refferal__Data_Model>>(
          future: _Refferal_fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              return SizedBox(
                  child: Refferal_Application_ListView(data, context));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );

    Refferal_Select_Client_Fun() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          content: Container(
            height: 300,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: TextField(
                        controller: Referal_Name_Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Search here Referal Name',
                        ),
                        onChanged: (text) {
                          setState(() {
                            Spaciality;
                          });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    child: Refferal_Client_Selection_verticalList3,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

//......................................Refferal Doctor Finished
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    var date = "";
    DateTime selectedDate = DateTime.now();
    String _formattodate = new DateFormat.yMMMd().format(selectedDate);

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
                    child: Text('Select Booking Area')),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                    globals.Selected_Title = _selectedItem;
                    Spaciality();
                  });
                },
                items: data.map((ldata) {
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['AREA_NAME'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['AREA_ID'].toString(),
                  );
                }).toList(),
              ),
            ),
          ),
        ));

    final Select_Location_locationDropdwon = SizedBox(
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
                menuMaxHeight: 300,
                value: _selectedItem1,
                hint: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text('Select Location')),
                onChanged: (value) {
                  setState(() {
                    _selectedItem1 = value;
                    globals.LOCATION_ID_new_order = _selectedItem1;
                    Spaciality();
                  });
                },
                items: data1.map((ldata) {
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['LOCATION_NAME'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['LOCATION_ID'].toString(),
                  );
                }).toList(),
                // style: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Montserrat"),
              ),
            ),
          ),
        ));

    final Select_Channel_locationDropdwon = SizedBox(
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
                value: _selectedItem2,
                hint: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text('Select Channel')),
                onChanged: (value) {
                  setState(() {
                    Spaciality;
                    _selectedItem2 = value;
                    globals.ID = _selectedItem2;
                    Select_Discount_Policy();
                  });
                },
                items: data2.map((ldata) {
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['REFERAL_SOURCE_DESC'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['ID'].toString(),
                  );
                }).toList(),
                // style: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Montserrat"),
              ),
            ),
          ),
        ));

    final Select_Employee_locationDropdwon = SizedBox(
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
                value: _selectedItem3,
                hint: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text('Select Employee')),
                onChanged: (value) {
                  setState(() {
                    _selectedItem3 = value;
                    globals.Selected_Pincode = _selectedItem3;
                    Spaciality();
                  });
                },
                items: data3.map((ldata) {
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['CREATE_BY'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['ROW'].toString(),
                  );
                }).toList(),
                // style: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Montserrat"),
              ),
            ),
          ),
        ));

    final Select_Discount_Policy_locationDropdwon = SizedBox(
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
                menuMaxHeight: 300,
                value: _selectedItem5,
                hint: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text('Select Discount Policy')),
                onChanged: (value) {
                  setState(() {
                    _selectedItem5 = value;
                    globals.discount_policy_id = _selectedItem5;

                    Spaciality();
                  });
                },
                items: data5.map((ldata) {
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['DISCOUNT_POLICY_NAME'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['DISCOUNT_POLICY_ID'].toString(),
                  );
                }).toList(),
                // style: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Montserrat"),
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
        appBar: AppBar(
          actions: [Builder(builder: (context) => Container())],
          backgroundColor: Color(0xff123456),
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
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text(
                  "Select Speciality",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        drawer: DrawerForAll(),
        endDrawer:
            // (globals.REFRL_ID != "")
            //     ?

            Drawer(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff123456),
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text("Select Referal Name"))
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  height: 650,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 270,
                        height: 50,
                        child: MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: 1.0),
                          child: TextField(
                              controller: Referal_Name_Controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Search here Client',
                              ),
                              onChanged: (text) {
                                setState(() {
                                  Spaciality();
                                });
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 550,
                          child: Refferal_Client_Selection_verticalList3,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // : Drawer(
        //     child: Scaffold(
        //       appBar: AppBar(
        //         backgroundColor: Color(0xff123456),
        //         automaticallyImplyLeading: false,
        //         title: Row(
        //           children: [
        //             MediaQuery(
        //                 data: MediaQuery.of(context)
        //                     .copyWith(textScaleFactor: 1.0),
        //                 child: Text("Select Client"))
        //           ],
        //         ),
        //       ),
        //       body: SingleChildScrollView(
        //         child: Padding(
        //           padding: const EdgeInsets.only(top: 15.0),
        //           child: Container(
        //             height: 650,
        //             child: Column(
        //               children: [
        //                 SizedBox(
        //                   width: 200,
        //                   height: 50,
        //                   child: MediaQuery(
        //                     data: MediaQuery.of(context)
        //                         .copyWith(textScaleFactor: 1.0),
        //                     child: TextField(
        //                         controller: nameController,
        //                         decoration: InputDecoration(
        //                           border: OutlineInputBorder(),
        //                           labelText: 'Search here Client',
        //                         ),
        //                         onChanged: (text) {
        //                           setState(() {
        //                             Spaciality();
        //                           });
        //                         }),
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Container(
        //                     height: 550,
        //                     child: Client_Selection_verticalList3,
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        body: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 198, 202, 206),
            child: Column(
              children: [
                Container(
                  height: 133,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 400,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 90,
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
                                                  child: Icon(Icons.person,
                                                      color: Colors.blue)),
                                              globals.family_members_user_name
                                                          .length <=
                                                      35
                                                  ? MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: Text(globals
                                                          .family_members_user_name),
                                                    )
                                                  : MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: Text(globals
                                                          .family_members_user_name
                                                          .substring(0, 35)),
                                                    ),
                                              Spacer(),
                                              MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(globals
                                                        .family_members_age
                                                        .split(',')[0] +
                                                    " Years,"),
                                              ),
                                              globals.family_members_gender ==
                                                      "1"
                                                  ? Text("Male")
                                                  : Text("Female"),
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
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(globals
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
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: Text(
                                                          globals
                                                              .family_members_user_phone,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .blue[200],
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 25,
                                              ),
                                              MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(globals
                                                    .family_members_umr_no),
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
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 461,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Select_Booking_Area_locationDropdwon,
                              SizedBox(
                                height: 20,
                              ),
                              Select_Location_locationDropdwon,
                              SizedBox(
                                height: 20,
                              ),
                              Select_Channel_locationDropdwon,
                              SizedBox(
                                height: 20,
                              ),
                              globals.ID == ""
                                  ? Container()
                                  : Builder(
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
                                              height: 43,
                                              width: 330,
                                              child: Row(
                                                children: [
                                                  globals.REF_DOCTOR_DESIGNATION ==
                                                          ""
                                                      ? MediaQuery(
                                                          data: MediaQuery.of(
                                                                  context)
                                                              .copyWith(
                                                                  textScaleFactor:
                                                                      1.0),
                                                          child: Text(
                                                              "Select Referral Doctor"),
                                                        )
                                                      : MediaQuery(
                                                          data: MediaQuery.of(
                                                                  context)
                                                              .copyWith(
                                                                  textScaleFactor:
                                                                      1.0),
                                                          child: Text(globals
                                                              .REF_DOCTOR_DESIGNATION),
                                                        ),
                                                  Spacer(),
                                                  Icon(Icons.arrow_drop_down)
                                                ],
                                              ),
                                            ),
                                          ))),
                              SizedBox(
                                height: 20,
                              ),
                              globals.ID == "3"
                                  ? Select_Employee_locationDropdwon
                                  : globals.ID == "18" || globals.ID == "19"
                                      ? Builder(
                                          builder: (context) => (InkWell(
                                                onTap: () =>
                                                    Scaffold.of(context)
                                                        .openEndDrawer(),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                14)),
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
                                                      globals.COMPANY_NAME == ""
                                                          ? MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      textScaleFactor:
                                                                          1.0),
                                                              child: Text(
                                                                  "Select Client"),
                                                            )
                                                          : MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      textScaleFactor:
                                                                          1.0),
                                                              child: Text(globals
                                                                  .COMPANY_NAME),
                                                            ),
                                                      Spacer(),
                                                      Icon(
                                                          Icons.arrow_drop_down)
                                                    ],
                                                  ),
                                                ),
                                              )))
                                      : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: SizedBox(
                    width: 350,
                    child: (globals.LOCATION_ID_new_order == "" ||
                            globals.Selected_Title == null ||
                            globals.ID == "" ||
                            globals.REFRL_ID == "")
                        ? TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 175, 178, 182),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                'Add Services',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            onPressed: () {
                              // Handle the case when the conditions are met
                            },
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xff123456),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(
                                'Add Services',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search()),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

class Client_Selection_Data_Model {
  final COMPANY_NAME;
  final ROW;
  final COMPANY_ID;

  Client_Selection_Data_Model({
    required this.COMPANY_NAME,
    required this.ROW,
    required this.COMPANY_ID,
  });

  factory Client_Selection_Data_Model.fromJson(Map<String, dynamic> json) {
    return Client_Selection_Data_Model(
      COMPANY_NAME: json['COMPANY_NAME'],
      ROW: json['ROW'],
      COMPANY_ID: json['COMPANY_ID'],
    );
  }
}

class Refferal__Data_Model {
  final REF_DOCTOR_DESIGNATION;
  final REFRL_ID;
  final REFERAL_NAME;

  Refferal__Data_Model({
    required this.REF_DOCTOR_DESIGNATION,
    required this.REFRL_ID,
    required this.REFERAL_NAME,
  });

  factory Refferal__Data_Model.fromJson(Map<String, dynamic> json) {
    return Refferal__Data_Model(
        REF_DOCTOR_DESIGNATION: json['REF_DOCTOR_DESIGNATION'],
        REFRL_ID: json['REFRL_ID'],
        REFERAL_NAME: json['REFERAL_NAME']);
  }
}

_callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}

class Referral_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => (InkWell(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
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
                    globals.REF_DOCTOR_DESIGNATION == ""
                        ? MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("Select Referral Doctor"),
                          )
                        : MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(globals.REF_DOCTOR_DESIGNATION),
                          ),
                    Spacer(),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            )));
  }
}

class Client_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => (InkWell(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
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
                    globals.COMPANY_NAME == ""
                        ? MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("Select Client"),
                          )
                        : MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(globals.COMPANY_NAME),
                          ),
                    Spacer(),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            )));
  }
}
