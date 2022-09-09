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
  TextEditingController nameFlagCountry = TextEditingController();
  int _increase = 0;
  String flagCountry =
      "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg";
  Future<String> getData() async {
    var response = await http.get(Uri.parse("https://restcountries.com/v2/all"),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body)[_increase];
      String nameCountry = map["name"];
      flagCountry = map["flags"]["png"];
      print(nameCountry);
      print(flagCountry);
      setState(() {
        _increase++;
      });
      nameFlagCountry.text = nameCountry.toString();
      return "Okey";
    }
    throw Exception('Failed to load the api');
  }

  // void Aselarador() {
  //   accelerometerEvents.listen(
  //     (AccelerometerEvent event) {
  //       var x = event.x;
  //       var y = event.y;
  //       var z = event.z;
  //     },
  //   );
  // }

  // Builder
  double dx = 100, dy = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: [
          StreamBuilder<GyroscopeEvent>(
            stream: SensorsPlatform.instance.gyroscopeEvents,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.x >= 1 || snapshot.data!.y >= 1) {
                  print("I'm moving");
                  getData();
                }
              }
              return Transform.translate(
                  offset: Offset(dx, dy),
                  child: const CircleAvatar(
                    radius: 20,
                  ));
            },
          ),
          Image(
            image: NetworkImage(flagCountry),
          ),
          TextFormField(
            controller: nameFlagCountry,
            readOnly: true,
            decoration: InputDecoration(hintText: "", border: InputBorder.none),
          ),
        ]));
  }
}
