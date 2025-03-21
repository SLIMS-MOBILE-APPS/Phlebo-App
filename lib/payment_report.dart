import 'package:flutter/material.dart';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class Phlebo_Payment_Report extends StatefulWidget {
  @override
  _Phlebo_Payment_Report createState() => _Phlebo_Payment_Report();
}

class _Phlebo_Payment_Report extends State<Phlebo_Payment_Report> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 5; // Initial step set to 5.

  int upperBound = 6; // upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    Widget Application_Widget(var data, BuildContext context) {
      return Container();
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

    Future<List<Data_Model>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "tokenno":
            "AgBQBOvXLdwKAhlG1bamFxx8p9GkS3Q1riNmjYx2dWf4RPevTnu6mtCTPGllXP6wTfnKBqeGJaLLBON/VHoCtZdO75UR+w==",
        "userid": "12554",
        "billno": "",
        "fromdt": "2022-11-04",
        "todt": "2022-11-04",
        "patientname": "",
        "flagnew": "",
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl = Uri.parse(globals.API_url +
          '/mobile/api/PhleboHomeCollection/GetPhleboMobileCompletedOrders');

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
            .map((strans) => Data_Model.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalList3 = Container(
      color: Color.fromARGB(255, 198, 202, 206),
      height: MediaQuery.of(context).size.height * 0.7,
      child: FutureBuilder<List<Data_Model>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              // return SizedBox(child: Application_ListView(data, context));
              return NoContent3();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
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

class Data_Model {
  final collectio_id;

  Data_Model({
    required this.collectio_id,
  });

  factory Data_Model.fromJson(Map<String, dynamic> json) {
    return Data_Model(
      collectio_id: json['collectio_id'],
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
