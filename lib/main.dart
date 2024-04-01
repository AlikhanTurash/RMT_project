import 'package:flutter/material.dart';
import 'package:google_maps_app/main_page.dart';
import 'map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo test',
      home: MainPage(),
    );
  }
}
