import 'package:animation_1/spinner/circle_spinner.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CircleSpinner(),
      debugShowCheckedModeBanner: false,
    );
  }
}
