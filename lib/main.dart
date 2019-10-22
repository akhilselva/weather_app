import 'package:flutter/material.dart';
import './ui/home.dart';

main(){
  runApp(MaterialApp(
    title: "Weather Info",
    home: Home(),
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
  ));
}

