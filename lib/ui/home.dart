import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/ui/forecast.dart';
import 'package:weather_app/utilities.dart' as utilities;
import 'more_info.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String location = utilities.defaultLocation;
  var getLocation = TextEditingController();
  updateLocation() {
    setState(() {
      location = getLocation.text;
    });
  }
  var weatherInfo;
  @override

  void initState() {
    //We will get the default location (if set) here!
    super.initState();
    loadDefaultLocation();
  }

  loadDefaultLocation() async{
    SharedPreferences savedLocation=await SharedPreferences.getInstance();
    if(savedLocation.getString("location")!=null && savedLocation.getString("location")!="")/*Will be "" during first install*/{
      setState(() {
        location=savedLocation.getString("location");
      });
    }
    weatherInfo=getWeatherInfo(utilities.appId, location);
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
            "images/blue-iphone-wallpaper-lock-screen-wallpaper-40465.jpg"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: utilities.appBarColor(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Weather",
                style: utilities.containerTextStyle(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Container(
                  decoration: utilities.containerBoxDecoration(),
                  width: 150,
                  child: TextField(
                    onEditingComplete: () {
                      //debugPrint(getLocation.text);
                      FocusScope.of(context).unfocus();
                      updateLocation();
                      refresh(location);
                    }, //To remove keyboard after typing...
                    textCapitalization: TextCapitalization.words,
                    //Styling
                    style: utilities.containerTextStyle(),
                    cursorColor: utilities.textColor(),
                    controller: getLocation,
                    decoration: InputDecoration(
                      hintText: "Location",
                      hintStyle: utilities.containerTextStyle(),
                      prefixIcon: Icon(
                        Icons.search,
                        color: utilities.textColor(),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              //Icon(Icons.menu)
            ],
          ),
        ),
        body: Builder(
          builder:(BuildContext context){
            return ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(40),
                  child: Text(
                    location == ""
                        ? "Please enter location"
                        : location == null ? utilities.defaultLocation : location,
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ).merge(utilities.containerTextStyle()),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container( //Weather Info set
                    child: FutureBuilder( //change_log 20-Oct-2019
                        future: weatherInfo,
                        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                          if (snapshot.hasData && snapshot.data.containsKey("main")) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.network(
                                  'http://openweathermap.org/img/w/${snapshot.data["weather"][0]["icon"]}.png',
                                  height: 35,
                                ),
                                Text(
                                  "It's Currently ${snapshot.data["main"]["temp"].toString()}\u{2103} at ${snapshot.data["name"].toString()}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      color: utilities.textColor()),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Min : ${snapshot.data["main"]["temp_min"].toString()}\u{2103}\n"
                                        "Max : ${snapshot.data["main"]["temp_max"].toString()}\u{2103}\n"
                                        "Humidity : ${snapshot.data["main"]["humidity"].toString()}%",
                                    style: utilities.containerTextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    FlatButton(
                                      child: Icon(Icons.refresh,color: utilities.textColor(),),
                                      color: Colors.transparent,
                                      onPressed: (){
                                        debugPrint("From FlatButton-$location");
                                        refresh(location);
                                      },
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.end,
                                )
                              ],
                            );
                          } else {
                            return Center(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: snapshot.data==null?Text("Loading...",style: utilities.moreInfoTextStyle().merge(TextStyle(letterSpacing: 10)),):Text(
                                    snapshot.data.toString(),
                                    style: utilities.containerTextStyle(),
                                  )),
                            );
                          }
                        }),

                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(10),
                    decoration: utilities.containerBoxDecoration()),
              ),
              //BUTTONS//
              Padding(
                padding: EdgeInsets.all(50),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: FlatButton(
                        color: Colors.black26,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MoreInfo(
                              location: location,
                            );
                          }));
                        },
                        child: Text(
                          "More info",
                          style: utilities.containerTextStyle(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: FlatButton(
                        color: Colors.black26,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return Forecast(
                                  location: location,
                                );
                              }));
                        },
                        child: Text(
                          "Forecast",
                          style: utilities.containerTextStyle(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: FlatButton(
                        color: Colors.black26,
                        onPressed: () {
                          utilities.setDefaultLocation(getLocation.text);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Set!",style: utilities.containerTextStyle(),textAlign: TextAlign.center,),
                            backgroundColor: Colors.transparent,
                          ));
                        },
                        child: Text(
                          "Set location as default",
                          style: utilities.containerTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );},
        ),
      ),
    );
  }

  refresh(String loco){
    print("From refresh fn-$loco");
    setState(() {
      weatherInfo=getWeatherInfo(utilities.appId, loco);
    });
  }
}

/*Widget locationWeatherInfo(String appId, String location) {
  return
}*/

Future<Map> getWeatherInfo(String appId, String location) async {
  String apiURL =
      "http://api.openweathermap.org/data/2.5/weather?q=$location&APPID=$appId&units=metric";
  http.Response response = await http.get(apiURL);
  return jsonDecode(response.body);
}

Future<Map> getForecastInfo(String appId, String location) async {
  String apiURL =
      "https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$appId&units=metric";
  http.Response response = await http.get(apiURL);
  return jsonDecode(response.body);
}


