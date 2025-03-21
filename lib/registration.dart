import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'family_members.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController Pincode_Controller = TextEditingController();
  var functionCalls = "";
  int selectedIndex = 0;
  var selecteFromdt = '';
  var selecteTodt = '';
  String? gender;
  TextEditingController _ageController = TextEditingController();
  DateTime? _selectedDate;
  TextEditingController Registration_nameController = TextEditingController();
  TextEditingController Registration_emailController = TextEditingController();
  TextEditingController Registration_AgeController =
      TextEditingController(text: globals.age.toString());

  TextEditingController Registration_addressController =
      TextEditingController();
  TextEditingController dateInput = TextEditingController();
  bool _validate = false;
  bool _validate1 = false;
  DatePickerFunction() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          content: Container(
            height: 400,
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).copyWith().size.height / 4,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newdate) {
                        print("${newdate.toLocal()}".split(' ')[0]);
                        setState(() {
                          globals.selected_date =
                              "${newdate.toLocal()}".split(' ')[0].toString();
                        });
                      },
                      use24hFormat: true,
                      maximumDate: new DateTime.now(),
                      minimumYear: 1950,
                      maximumYear: 2050,
                      minuteInterval: 1,
                      mode: CupertinoDatePickerMode.date,
                    )),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 200,
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            age_function();
                            Registration_AgeController.text =
                                globals.age.toString();
                          },
                          child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: Text("Done"))),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  String? _selectedItem;
  String? _selectedItem1;

  void clearText() {
    Registration_nameController.clear();
    Registration_emailController.clear();
    Registration_addressController.clear();
    Registration_AgeController.clear();
    dateInput.clear();
  }

  late Map<String, dynamic> map;
  late Map<String, dynamic> params;
  // var functionCalls = "";
  List selectTitle = []; //edi
  List selectPincode = []; //edi

  getSWData1() async {
    params = {
      "Token": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
      "City_id": globals.LOCATION_ID,
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetAreaByCity'),
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
      functionCalls = "true";
    } else {
      functionCalls == "false";
    }
    setState(() {
      selectPincode = map["result"] as List;
    });
  }

  getSWData() async {
    params = {
      "Token":
          "AgBQBOvXLdwKAhlG1bamFxx8p9GkS3Q1riNmjYx2dWf4RPevTnu6mtCTPGllXP6wTfnKBqeGJaLLBON/VHoCtZdO75UR+w==",
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/mobile/api/Patient/GetPatientTitles'),
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
      functionCalls = "true";
    } else {
      functionCalls == "false";
    }
    setState(() {
      selectTitle = map["result"] as List;
    });

    return "Sucess";
  }

  @override
  void initState() {
    getSWData();
    getSWData1();
    globals.Selected_Title = "";
    dateInput.clear();
    globals.Area_NAME = "";
    globals.Selected_Pincode = "";
    super.initState();
  }

  var _formKey = GlobalKey<FormState>();
  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
  }

  validation_function() {
    _submit();
    bool isValid = false;
    // final ;
    // if (!isValid) {
    //   return;
    // }
    if (globals.Selected_Title == null || globals.Selected_Title == "") {
      errormsg_Titile();
    } else if (Registration_nameController.text == "") {
      errormsg_Name();
    } else if (globals.selected_date == "") {
      errormsg_SelectDate();
    }
    // else if (Registration_emailController.text == "" ||
    //     isValid == _formKey.currentState!.validate()) {
    //   errormsg_Email();
    // }
    else if (Registration_addressController.text == "") {
      errormsg_Address();
    } else if (globals.Selected_Pincode == null) {
      errormsg_SelectPincode();
    } else {
      registrationSave(globals.age, context);
    }
  }

  registrationSave(age, BuildContext context) async {
    var isLoading = true;

    Map<String, dynamic> body = {
      "TokenNo": "7c4324e9-b242-4be9-bf33-9f33f60832ab",
      "user_name": Registration_nameController.text,
      "user_email": Registration_emailController.text,
      "user_mobile": globals.Mobile_Number,
      "user_dob": globals.selected_date,
      "user_gender": globals.Selected_Title,
      "user_address": Registration_addressController.text,
      "user_Title": globals.Selected_Title,
      "area_id": globals.Selected_Pincode,
      "city_id": globals.Selected_Pincode,
      "age": age,
      "sessionID": globals.SESSION_ID,
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Family_Members()),
        );
        clearText();
      } else {
        errormsg_data_save();
      }
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
                          WaitingFunciton();
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

  bool isButtonDisabled = false;
  Future<void> WaitingFunciton() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true; // Disable the button
      });

      Registration_addressController.text.isEmpty
          ? _validate1 = true
          : _validate1 = false;
      Registration_nameController.text.isEmpty
          ? _validate = true
          : _validate = false;

      validation_function();

      Future.delayed(Duration(seconds: 5), () {
        // Enable the button again after the delay
        setState(() {
          isButtonDisabled = false;
        });
      });
    }
  }

  // bool isButtonDisabled = false;

  // void PatientREGIstraTIoN() {
  //   if (!isButtonDisabled) {
  //     setState(() {
  //       isButtonDisabled = true; // Disable the button
  //     });

  //     // Call your API here to book the test

  //     // Example delay to simulate API call
  //     Future.delayed(Duration(seconds: 2), () {
  //       // Enable the button again after the delay
  //       setState(() {
  //         isButtonDisabled = false;
  //       });
  //     });
  //   }
  // }

  age_function() {
    //the selected date
    var userSelectedDate = DateTime(
        DateTime.parse(globals.selected_date).year,
        DateTime.parse(globals.selected_date).month,
        DateTime.parse(globals.selected_date).day);

    //the duration difference form the selected date to now in days
    var days = DateTime.now().difference(userSelectedDate).inDays;

    //the duration difference in years (the current age)
    var age = days ~/ 360;
    setState(() {
      globals.age = age.toString();
      print(globals.age);
    });
  }

  Widget Select_Title_locationDropdwon() {
    return SizedBox(
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
                value: _selectedItem,

                hint: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: const Text('Select Title')),
                onChanged: (String? value) {
                  setState(() {
                    _selectedItem = value;
                    globals.Selected_Title = _selectedItem;
                  });
                  validator:
                  (value) => _selectedItem == null ? 'field required' : null;
                },

                items: selectTitle.map((ldata) {
                  print("Validation done");
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['title_desc'].toString(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['title_id'].toString(),
                  );
                }).toList(),
                // style: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Montserrat"),
              ),
            ),
          ),
        ));
  }

  // Widget Select_Center_Pincode_locationDropdwon() {
  //   return SizedBox(
  //       width: 340,
  //       height: 48,
  //       child: Card(
  //         elevation: 2.0,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
  //           child: DropdownButtonHideUnderline(
  //             child: DropdownButton(
  //               isDense: true,
  //               isExpanded: true,
  //               menuMaxHeight: 300,
  //               value: _selectedItem1,
  //               hint: MediaQuery(
  //                   data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
  //                   child: const Text('Select Center Pincode')),
  //               onChanged: (String? value) {
  //                 setState(() {
  //                   _selectedItem1 = value;
  //                   globals.Selected_Pincode = _selectedItem;
  //                 });
  //               },
  //               items: selectPincode.map((ldata) {
  //                 return DropdownMenuItem(
  //                   child: Text(
  //                     ldata['area_desc'].toString(),
  //                     style: const TextStyle(
  //                         fontSize: 14,
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.w400),
  //                   ),
  //                   value: ldata['area_id'].toString(),
  //                 );
  //               }).toList(),
  //             ),
  //           ),
  //         ),
  //       ));
  // }

  Widget build(BuildContext context) {
    List<String> MalevalidTitles = ["1", "4", "7", "9", "10", "11", "12", "23"];
    List<String> FemalevalidTitles = ["2", "3", "5", "8", "13", "24"];
    List<String> OthervalidTitles = ["25"];

    if (MalevalidTitles.contains(globals.Selected_Title)) {
      setState(() {
        globals.Selected_Title = "1";
      });
    } else if (FemalevalidTitles.contains(globals.Selected_Title)) {
      setState(() {
        globals.Selected_Title = "2";
      });
    } else if (OthervalidTitles.contains(globals.Selected_Title)) {
      setState(() {
        globals.Selected_Title = "3";
      });
    }

    // int _selectedValue = int.parse(globals.Selected_Title.toString());
    int _selectedValue = globals.Selected_Title.toString() == "null" ||
            globals.Selected_Title.toString() == ""
        ? 1
        : int.parse(globals.Selected_Title.toString());
//......................................Refferal Doctor Start

    Widget Pincode_Application_Widget(var data, BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300,
              height: 40,
              child: InkWell(
                  onTap: () {
                    Pincode_Controller.text = "";

                    globals.Area_NAME = data.area_name.toString();
                    globals.Selected_Pincode = data.area_id.toString();

                    setState(() {
                      Registration();
                    });
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: Text(data.area_name.toString())),
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
              return Pincode_Application_Widget(data[index], context);
            });
      }
      return ListView();
    }

    Future<List<Pincode__Data_Model>> _Refferal_fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "Token": Pincode_Controller.text,
        "City_id": globals.LOCATION_ID,
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl =
          Uri.parse(globals.API_url + '/mobile/api/Patient/GetAreaByCity');

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
            .map((strans) => Pincode__Data_Model.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget Pincode_Selection_verticalList3 = Container(
      child: FutureBuilder<List<Pincode__Data_Model>>(
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

//......................................Refferal Doctor Finished
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
          backgroundColor: const Color(0xff123456),
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
            icon: Icon(Icons.arrow_back), // Icon to display
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Family_Members()),
              );
            },
          ),
          title: Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: const Text(
                  "Patient Registration",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const Spacer(),
            ],
          ),
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
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text("Select Pincode"))
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
                            controller: Pincode_Controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Search here Pincode',
                            ),
                            onChanged: (text) {
                              if (text.length >= 3) {
                                setState(() {
                                  // Call your function or perform actions here
                                  // Spaciality();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 550,
                          child: Pincode_Selection_verticalList3,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 30,
                  color: const Color(0xff123456),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("Your registered   mobile no. ",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          const Icon(
                            Icons.phone_in_talk,
                            size: 15,
                            color: Colors.white,
                          ),
                          MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text(globals.Mobile_Number,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      )),
                  //   ),
                  // ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 580,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Select_Title_locationDropdwon(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: TextFormField(
                                // autofocus: true,
                                textCapitalization:
                                    TextCapitalization.characters,
                                keyboardType: TextInputType.name,
                                controller: Registration_nameController,

                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 19, 102, 170),
                                    ),
                                    labelText: 'Name:',
                                    errorText: _validate ? 'Enter Name' : null,
                                    errorBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.redAccent),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blueAccent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: const Color.fromARGB(
                                              255, 170, 168, 168),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onFieldSubmitted: (value) {
                                  //Validator
                                },
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    title: Text('Male',
                                        style: TextStyle(fontSize: 12)),
                                    value: 1,
                                    groupValue: _selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        // _selectedValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    title: Text('Female',
                                        style: TextStyle(fontSize: 12)),
                                    value: 2,
                                    groupValue: _selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        // _selectedValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    title: Text('Others',
                                        style: TextStyle(fontSize: 12)),
                                    value: 3,
                                    groupValue: _selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        // _selectedValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10.0),
                        //   child: Container(
                        //       width: 340,
                        //       height: 70,
                        //       decoration: BoxDecoration(
                        //           border: Border.all(
                        //             width: 1,
                        //             color: Color.fromARGB(255, 170, 168, 168),
                        //           ),
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(15))),
                        //       padding: const EdgeInsets.all(10),
                        //       child: Center(
                        //           child: Row(
                        //         children: [
                        //           Icon(
                        //             Icons.date_range,
                        //             color:
                        //                 const Color.fromARGB(255, 19, 102, 170),
                        //           ),
                        //           Container(
                        //               margin: const EdgeInsets.all(3.0),
                        //               padding: const EdgeInsets.all(6.0),
                        //               child: globals.selected_date == ""
                        //                   ? MediaQuery(
                        //                       data: MediaQuery.of(context)
                        //                           .copyWith(
                        //                               textScaleFactor: 1.0),
                        //                       child:
                        //                           Text("Select Date of Birth"))
                        //                   : MediaQuery(
                        //                       data: MediaQuery.of(context)
                        //                           .copyWith(
                        //                               textScaleFactor: 1.0),
                        //                       child:
                        //                           Text(globals.selected_date))),
                        //           Spacer(),
                        //           IconButton(
                        //               onPressed: () {
                        //                 DatePickerFunction();
                        //               },
                        //               icon: Icon(Icons.arrow_drop_down))
                        //         ],
                        //       ))),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10.0),
                        //   child: Container(
                        //     padding: const EdgeInsets.all(10),
                        //     child: TextFormField(
                        //       readOnly: true, // Set to read-only
                        //       controller: Registration_AgeController,
                        //       decoration: InputDecoration(
                        //         prefixIcon: const Icon(
                        //           Icons
                        //               .calendar_today, // Change the icon to represent age
                        //           color:
                        //               const Color.fromARGB(255, 19, 102, 170),
                        //         ),
                        //         labelText: 'Age:',
                        //         errorBorder: const OutlineInputBorder(
                        //           borderSide: const BorderSide(
                        //               width: 3, color: Colors.redAccent),
                        //         ),
                        //         focusedBorder: const OutlineInputBorder(
                        //           borderSide: const BorderSide(
                        //               width: 3, color: Colors.blueAccent),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //             borderSide: const BorderSide(
                        //               width: 1,
                        //               color: Color.fromARGB(255, 170, 168, 168),
                        //             ),
                        //             borderRadius: BorderRadius.circular(15)),
                        //       ),
                        //       keyboardType: TextInputType
                        //           .number, // Restrict input to numeric characters
                        //       onChanged: (value) {
                        //         age_function();
                        //       },
                        //       // Remove onFieldSubmitted as it's not needed in read-only mode
                        //     ),
                        //   ),
                        // ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: _ageController.text == ""
                                        ? 'Enter Age in Years'
                                        : 'Age in Years',
                                  ),
                                  onChanged: (age) {
                                    if (age.isNotEmpty) {
                                      int ageInYears = int.parse(age);
                                      DateTime now = DateTime.now();
                                      _selectedDate = DateTime(
                                        now.year - ageInYears,
                                        now.month,
                                        now.day,
                                      );
                                    } else {
                                      _selectedDate = null;
                                    }
                                    setState(() {
                                      globals.selected_date =
                                          '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';

                                      globals.age = age;
                                    });
                                  },
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _selectedDate = picked;
                                      _ageController.text =
                                          "${DateTime.now().year - picked.year}";
                                      globals.selected_date =
                                          '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.blue, // Button background color
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.5), // Shadow color
                                        spreadRadius: 2, // Spread radius
                                        blurRadius: 5, // Blur radius
                                        offset: Offset(0, 3), // Shadow offset
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 20), // Button padding
                                    child: Text(
                                      'Select Date of Birth',
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontSize: 18, // Text size
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_selectedDate != null)
                                Text(
                                  'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: TextFormField(
                                controller: Registration_emailController,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.mail,
                                      color: const Color.fromARGB(
                                          255, 19, 102, 170),
                                    ),
                                    labelText: 'Email:',
                                    errorBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.redAccent),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.blueAccent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 170, 168, 168),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                keyboardType: TextInputType.emailAddress,
                                onFieldSubmitted: (value) {
                                  //Validator
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
                              child: TextFormField(
                                controller: Registration_addressController,
                                // autofocus: true,
                                textCapitalization:
                                    TextCapitalization.characters,
                                keyboardType: TextInputType.streetAddress,

                                decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.directions,
                                      color: Color.fromARGB(255, 19, 102, 170),
                                    ),
                                    labelText: 'Address:',
                                    errorText:
                                        _validate1 ? 'Enter Address' : null,
                                    errorBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.redAccent),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      //<-- SEE HERE
                                      borderSide: BorderSide(
                                          width: 3, color: Colors.blueAccent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: const Color.fromARGB(
                                              255, 170, 168, 168),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onFieldSubmitted: (value) {
                                  //Validator
                                },
                              ),
                            ),
                          ),
                        ),
                        // Select_Center_Pincode_locationDropdwon(),
                        Builder(
                            builder: (context) => (InkWell(
                                  onTap: () =>
                                      Scaffold.of(context).openEndDrawer(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(14)),
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
                                        globals.Selected_Pincode == null ||
                                                globals.Selected_Pincode == ""
                                            ? MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text("Select Pincode"),
                                              )
                                            : MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(globals.Area_NAME
                                                    .toString()),
                                              ),
                                        Spacer(),
                                        Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: SizedBox(
                    width: 350,
                    child: TextButton(
                      // splashColor: Colors.red,
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xff123456),
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),

                      // textColor: Colors.white,
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: const Text('Save Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            )),
                      ),
                      onPressed: () {
                        Accept_Permission();
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

Successtoaster() {
  return Fluttertoast.showToast(
      msg: "Register Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_Titile() {
  return Fluttertoast.showToast(
      msg: "Please select Title",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_Name() {
  return Fluttertoast.showToast(
      msg: "Please Enter Name",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_Email() {
  return Fluttertoast.showToast(
      msg: "Please Enter Email",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_Gender() {
  return Fluttertoast.showToast(
      msg: "Please Select Gender",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_DateOfBirth() {
  return Fluttertoast.showToast(
      msg: "Please Select Date of Birth",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_Address() {
  return Fluttertoast.showToast(
      msg: "Please Enter Address",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_Pincode() {
  return Fluttertoast.showToast(
      msg: "Please Select Pincode",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_data_save() {
  return Fluttertoast.showToast(
      msg: "The operation couldn't be completed.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_TitleDrowpdown() {
  return Fluttertoast.showToast(
      msg: "Select Title Please.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_SelectDate() {
  return Fluttertoast.showToast(
      msg: "Select Date of Birth",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg_SelectPincode() {
  return Fluttertoast.showToast(
      msg: "Select Pincode Please.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

class Pincode__Data_Model {
  final city_id;
  final area_id;
  final area_cd;
  final area_name;
  final area_desc;
  final pincode;

  Pincode__Data_Model({
    required this.city_id,
    required this.area_id,
    required this.area_cd,
    required this.area_name,
    required this.area_desc,
    required this.pincode,
  });

  factory Pincode__Data_Model.fromJson(Map<String, dynamic> json) {
    return Pincode__Data_Model(
        city_id: json['city_id'],
        area_id: json['area_id'],
        area_cd: json['area_cd'],
        area_name: json['area_name'],
        area_desc: json['area_desc'],
        pincode: json['pincode']);
  }
}
