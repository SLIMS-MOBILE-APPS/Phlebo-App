import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'new_order.dart';
import 'registration.dart';
import 'specialilty.dart';

import 'drawer.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'models.dart';

int selectedIndex = 0;
var selecteFromdt = '';
var selecteTodt = '';
TextEditingController Mobile_Controller = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Family_Members extends StatefulWidget {
  const Family_Members({Key? key}) : super(key: key);

  @override
  State<Family_Members> createState() => _Family_MembersState();
}

class _Family_MembersState extends State<Family_Members> {
  Widget Application_Widget(var data, BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                child: Card(
                  elevation: 5,
                  child: InkWell(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.person,
                                color: Color.fromARGB(255, 132, 214, 202)),
                            SizedBox(
                              width: 10,
                            ),
                            data.user_name.length <= 25
                                ? MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(data.user_name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  )
                                : MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(textScaleFactor: 1.0),
                                    child: Text(data.user_name.substring(0, 25),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                            Spacer(),
                            MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text(data.umr_no,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Icon(Icons.double_arrow,
                                color: Color.fromARGB(255, 214, 132, 132)),
                          ],
                        ),
                      ),
                      onTap: () {
                        globals.family_members_user_name =
                            data.user_name.toString();
                        globals.family_members_user_dob =
                            data.user_dob.toString();
                        globals.family_members_age = data.age.toString();
                        globals.family_members_user_phone =
                            data.user_phone.toString();
                        globals.family_members_gender = data.gender.toString();
                        globals.family_members_user_email =
                            data.user_email.toString();
                        globals.family_members_user_address =
                            data.user_address.toString();
                        globals.family_members_umr_no = data.umr_no.toString();
                        globals.family_members_area_name =
                            data.area_name.toString();
                        globals.family_members_uid = data.uid.toString();

                        globals.LOCATION_ID_new_order = "";
                        globals.Selected_Title = "";
                        globals.ID = "";
                        globals.REFRL_ID = "";

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Spaciality()));
                      }),
                ),
              ),
            ),

            // Divider(
            //   thickness: 1.0,
            //   color: Colors.grey[300],
            // ),
            // Spacer(),
          ],
        ));
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

  Future<List<Family_Data_Model>> _fetchSaleTransaction() async {
    var jobsListAPIUrl = null;
    var dsetName = '';
    List listresponse = [];

    Map data = {
      "Token": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
      "Mobile": globals.Mobile_Number,
      "connection": globals.Connection_Flag
    };

    dsetName = 'result';
    jobsListAPIUrl =
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetPatients');

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
          .map((strans) => Family_Data_Model.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    var date = "";
    DateTime selectedDate = DateTime.now();
    String _formattodate = new DateFormat.yMMMd().format(selectedDate);

    Widget verticalList3 = Container(
      color: Color.fromARGB(255, 101, 140, 178),
      height: MediaQuery.of(context).size.height * 0.82,
      child: FutureBuilder<List<Family_Data_Model>>(
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff123456),
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Icon to display
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => New_Order()),
                );
              },
            ),
            title: Row(
              children: [
                SizedBox(
                  width: 60,
                ),
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: Text(
                    "Family Members",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Spacer(),
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: Text(
                    _formattodate,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          drawer: DrawerForAll(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                verticalList3,
                // Spacer(),
                Container(
                  child: SizedBox(
                    width: 350,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xff123456),
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text('Add New',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            )),
                      ),
                      onPressed: () {
                        print(Mobile_Controller.text);
                        print(passwordController.text);
                        globals.Mobile_Number;
                        globals.selected_date = "";
                        globals.age = "";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registration()));
                      },
                    ),
                  ),
                ),
              ],
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
