import 'package:flutter/material.dart';

class FlagDataPage extends StatefulWidget {
  @override
  _FlagDataPageState createState() => _FlagDataPageState();
}

class _FlagDataPageState extends State<FlagDataPage> {
  // Map to store data against each flag
  Map<String, dynamic> flagDataMap = {};

  // Method to fetch data from the API (simulated here)
  Future<dynamic> fetchDataFromApi(String flag) async {
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));
    return {'data': 'Data for flag $flag'};
  }

  // Method to handle button click
  void handleButtonClick(String flag) async {
    if (flagDataMap.containsKey(flag)) {
      // If data for this flag already exists, use it
      setState(() {
        // Bind data from the list
        _currentData = flagDataMap[flag];
      });
    } else {
      // If data for this flag doesn't exist, fetch from API
      var data = await fetchDataFromApi(flag);
      setState(() {
        // Add to map and bind to UI
        flagDataMap[flag] = data;
        _currentData = data;
      });
    }
  }

  dynamic _currentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flag Data Example')),
      body: Column(
        children: [
          // Sample buttons with different flags
          ElevatedButton(
            onPressed: () => handleButtonClick('flag1'),
            child: Text('Fetch Flag 1 Data'),
          ),
          ElevatedButton(
            onPressed: () => handleButtonClick('flag2'),
            child: Text('Fetch Flag 2 Data'),
          ),
          // Display data
          if (_currentData != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Data: ${_currentData['data']}'),
            ),
        ],
      ),
    );
  }
}