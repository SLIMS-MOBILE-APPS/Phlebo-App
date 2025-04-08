import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'dashboard.dart';
import 'function.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

String base64Image = "";

class DrawerForAll extends StatefulWidget {
  const DrawerForAll({super.key});

  @override
  State<DrawerForAll> createState() => _DrawerForAllState();
}

class _DrawerForAllState extends State<DrawerForAll> {
  // final ImagePicker _picker = ImagePicker();
  File? file;
  List<File?> files = [];
  @override
  ImageSave() async {
    var isLoading = true;

    Map<String, dynamic> body = {
      "TokenNo": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
      "user_name": globals.USER_NAME,
      "user_email": "Phlebo",
      "user_mobile": "",
      "user_dob": "",
      "user_gender": "",
      "user_address": "base64Image",
      "user_Title": "",
      "area_id": "",
      "city_id": "",
      "age": "",
      "sessionID": "",
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(
            globals.API_url + '/mobile/api/Patient/SaveNewPatientDetails'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne["message"] == "FOUND") {
        globals.age = "";

        Successtoaster();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Family_Members()),
        // );
        // clearText();
      } else {
        // errormsg_data_save();
      }
    }
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 19, 102, 170),
              ),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Row(
                  children: [
                    Text(
                      'Logged in as Phlebo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () async {
                          // XFile? photo = await _picker.pickImage(
                          //     source: ImageSource.camera,
                          //     maxHeight: 1920,
                          //     maxWidth: 1080,
                          //     // imageQuality: 100,
                          //     preferredCameraDevice: CameraDevice.rear);

                          // if (photo == null) {
                          // } else {
                          //   setState(() {
                          //     file = File(photo.path);
                          //     files.add(File(photo.path));
                          //     final BYTes = File(photo.path).readAsBytesSync();
                          //     base64Image = base64Encode(BYTes);
                          //
                          //     //  BYTes= base64.decode(base64Image);
                          //   });
                          // }
                        },
                        icon: Icon(Icons.camera_alt_outlined)),
                  ],
                ),
              ),
            ),
          ),

          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage('images/home visit.png'),
                      fit: BoxFit.fitWidth)),
            ),
            accountEmail: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text(globals.USER_NAME)),
            accountName: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Text(
                globals.DISPLAY_NAME,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
          ),
          ListTile(
            onTap: () {
              globals_clear_Function();
              globals.flag_check = "";
              globals.REFRL_ID = "";
              globals.Selected_Title = "";
              globals.LOCATION_ID_new_order = "";
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Phlebo_Dashboard()),
              );
            },
            leading: Icon(
              Icons.dashboard,
              color: Color.fromARGB(255, 19, 102, 170),
            ),
            title: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text('Dashboard')),
          ),

          // ListTile(
          //   onTap: () {
          //     globals_clear_Function();
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => New_Order()),
          //     );
          //   },
          //   leading: Icon(Icons.add_circle,
          //       color: Color.fromARGB(255, 19, 102, 170)),
          //   title: MediaQuery(
          //       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //       child: Text('New Order')),
          // ),
          // Divider(
          //   height: 1,
          //   thickness: 1,
          // ),
          // ListTile(
          //   onTap: () {
          //     globals_clear_Function();
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => add_referral()),
          //     );
          //   },
          //   leading: Icon(Icons.add_circle,
          //       color: Color.fromARGB(255, 19, 102, 170)),
          //   title: MediaQuery(
          //       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //       child: Text('Add Referral')),
          // ),
          // Divider(
          //   height: 1,
          //   thickness: 1,
          // ),
          // ListTile(
          //   leading: Icon(Icons.phone_android_outlined,
          //       color: Color.fromARGB(255, 19, 102, 170)),
          //   title: Row(
          //     children: [
          //       MediaQuery(
          //           data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //           child: Text('Active Device:')),
          //       MediaQuery(
          //         data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //         child: Text(
          //           'No Device',
          //           style: TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            onTap: () async {
              globals_clear_Function();
              SharedPreferences prefs = await SharedPreferences.getInstance();

              // Remove multiple data entries
              prefs.remove('USER_NAME');
              prefs.remove('REFERENCE_ID');
              prefs.remove('DISPLAY_NAME');
              prefs.remove('PASSWORD');
              prefs.remove('LOCATION_NAME');
              prefs.remove('LOCATION_ID');
              prefs.remove('session_id');
              prefs.remove('AGENCY_ID');
              prefs.remove('USER_ID');
              prefs.remove('CONNECTION_STRING');
              prefs.remove('API_URL');
              prefs.remove('REPORT_URL');
              prefs.remove('COMPANY_LOGO');
              prefs.remove('CLIENT_NAME');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Phlebo_login()),
              );
            },
            leading: Icon(Icons.settings_power_outlined,
                color: Color.fromARGB(255, 19, 102, 170)),
            title: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text('Logout')),
          ),

          Divider(
            height: 1,
            thickness: 1,
          ),
          SizedBox(
            height: 280,
          ),
          Center(child: Text("version: 1.7.8+72")),
          ListView.builder(
            itemCount: files.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return files[index] == null
                  ? const Text("No Image Selected")
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 30, 2),
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 83, 115, 148),
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: <Widget>[
                                Image.file(
                                  files[index]!,
                                  fit: BoxFit.cover,
                                  height: 230, // Adjust the height as needed
                                  width: 270, // Adjust the width as needed
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Show a confirmation dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Save"), // Dialog title
                                    content: Text(
                                        "Do you want to save?"), // Dialog content
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // Dismiss the dialog and do nothing
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            "Cancel"), // Cancel button text
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Call the ImageSave function
                                          ImageSave();
                                          // Dismiss the dialog
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Save"), // Save button text
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Save'), // Text displayed on the button
                          )
                        ],
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}
