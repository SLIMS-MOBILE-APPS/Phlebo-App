import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Fjalla One',
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _getInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Navigator(
              initialRoute: snapshot.data.toString(),
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/home':
                    return MaterialPageRoute(
                        builder: (_) => Phlebo_Dashboard());
                  case '/login':
                    return MaterialPageRoute(builder: (_) => Phlebo_login());
                  default:
                    return MaterialPageRoute(builder: (_) => Container());
                }
              },
            );
          } else {
            return LoadingScreen(); // Show loading screen while waiting for initialization
          }
        },
      ),
    );
  }

  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.USER_NAME = prefs.getString('USER_NAME') ?? '';
    globals.REFERENCE_ID = prefs.getString('REFERENCE_ID') ?? '';
    globals.DISPLAY_NAME = prefs.getString('DISPLAY_NAME') ?? '';
    globals.PASSWORD = prefs.getString('PASSWORD') ?? '';
    globals.LOCATION_NAME = prefs.getString('LOCATION_NAME') ?? '';
    globals.LOCATION_ID = prefs.getString('LOCATION_ID') ?? '';
    globals.session_id = prefs.getString('session_id') ?? '';
    globals.AGENCY_ID = prefs.getString('AGENCY_ID') ?? '';
    globals.USER_ID = prefs.getString('USER_ID') ?? '';
    globals.Connection_Flag = prefs.getString('CONNECTION_STRING') ?? '';
    globals.API_url = prefs.getString('API_URL') ?? '';
    globals.Report_URL = prefs.getString('REPORT_URL') ?? '';
    globals.Logo = prefs.getString('COMPANY_LOGO') ?? '';
    globals.Client_Name = prefs.getString('CLIENT_NAME') ?? '';
    globals.Glb_LOCATION_QR = prefs.getString('LOCATION_QR') ?? '';
    return (prefs.getString('USER_NAME') != null &&
            prefs.getString('USER_ID') != "")
        ? '/home'
        : '/login';
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      ),
    );
  }
}









// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'DOB Selector',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DOBSelector(),
//     );
//   }
// }

// class DOBSelector extends StatefulWidget {
//   @override
//   _DOBSelectorState createState() => _DOBSelectorState();
// }

// class _DOBSelectorState extends State<DOBSelector> {
//   TextEditingController _ageController = TextEditingController();
//   DateTime? _selectedDate;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('DOB Selector'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.all(20.0),
//               child: TextField(
//                 controller: _ageController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'Enter your age',
//                 ),
//                 onChanged: (age) {
//                   if (age.isNotEmpty) {
//                     int ageInYears = int.parse(age);
//                     DateTime now = DateTime.now();
//                     _selectedDate = DateTime(
//                       now.year - ageInYears,
//                       now.month,
//                       now.day,
//                     );
//                   } else {
//                     _selectedDate = null;
//                   }
//                   setState(() {});
//                 },
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final picked = await showDatePicker(
//                   context: context,
//                   initialDate: _selectedDate!,
//                   firstDate: DateTime(1900),
//                   lastDate: DateTime.now(),
//                 );
//                 if (picked != null) {
//                   setState(() {
//                     _selectedDate = picked;
//                     _ageController.text =
//                         "${DateTime.now().year - picked.year}";
//                   });
//                 }
//               },
//               child: Text('Select Birthdate'),
//             ),
//             if (_selectedDate != null)
//               Text(
//                 'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
