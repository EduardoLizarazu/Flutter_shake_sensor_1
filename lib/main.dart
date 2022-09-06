import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _increase = 0;
  Future<String> getData() async {
    var response = await http.get(Uri.parse("https://restcountries.com/v2/all"),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body)[_increase];
      String nameCountry = map["name"];
      String flagCountry = map["flags"]["png"];
      print(nameCountry);
      print(flagCountry);
      setState(() {
        _increase++;
      });
      return 'okey';
    }
    throw Exception('Failed to load the api');
  }

  // Builder
  double dx = 100, dy = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            StreamBuilder<GyroscopeEvent>(
              stream: SensorsPlatform.instance.gyroscopeEvents,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  dx = dx + (snapshot.data!.y * 10);
                  dy = dy + (snapshot.data!.x * 10);
                }
                return Transform.translate(
                    offset: Offset(dx, dy),
                    child: const CircleAvatar(
                      radius: 20,
                    ));
              },
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(350, 50),
                  primary: Colors.grey[900],
                  shadowColor: Colors.white60,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.transparent)),
                ),
                onPressed: getData,
                child: const Text("Press Me!")),
          ],
        ));
  }
}
