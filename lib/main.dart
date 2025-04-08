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





