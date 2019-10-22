import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appId = "499093abb9ae71e744766738f864d7d6"; //API key for OpenWeatherMap
String defaultLocation = "Nagercoil";
//Date format func

String unixToNormal(int unixTime){
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(unixTime*1000).toUtc();
  var fmt=new DateFormat();
  var formattedDate=fmt.format(date);
  return formattedDate;
}

//Useful design functions

textColor() {
  return Colors.white;
}

appBarColor(){
  return Colors.black26;
}

containerTextStyle() {
  return TextStyle(
    fontWeight: FontWeight.w300,
    color: textColor(),
  );
}

containerBoxDecoration() {
  return BoxDecoration(
      color: Colors.black26, borderRadius: BorderRadius.circular(10));
}

moreInfoTextStyle(){
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: textColor(),
  );
}

//SharedPreferences stuff

setDefaultLocation(String name)async{
  SharedPreferences location= await SharedPreferences.getInstance();
  location.setString("location", name);
}

