// MORE INFO PAGE

import 'package:flutter/material.dart';
import '../utilities.dart' as utilities;
import 'home.dart';

class MoreInfo extends StatefulWidget {
  final String location;
  MoreInfo({Key key, @required this.location}) : super(key: key);
  @override
  _MoreInfoState createState() => _MoreInfoState(location: location);
}

class _MoreInfoState extends State<MoreInfo> {
  final String location;
  var weatherInfo;
  _MoreInfoState({Key key, @required this.location});
  @override
  void initState(){
    super.initState();
    weatherInfo=getWeatherInfo(utilities.appId, location);
  }
  refresh(String loco){
    print("From refresh fn-$loco");
    setState(() {
      weatherInfo=getWeatherInfo(utilities.appId, loco);
    });
  }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: weatherInfo,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData && snapshot.data.containsKey("main")) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.pexels.com/photos/2516653/pexels-photo-2516653.jpeg?h=1366&w=768"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.black26,
              appBar: AppBar(
                backgroundColor: utilities.appBarColor(),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      location == ""
                          ? "Please enter location"
                          : location == null ? utilities.defaultLocation : location,
                      style: utilities.containerTextStyle(),
                    ),
                    FlatButton(
                      child: Icon(Icons.refresh,color: utilities.textColor(),),
                      onPressed:(){
                        refresh(location);
                      },
                    )
                  ],
                ),
              ),
              body :ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "${snapshot.data["main"]["temp"].toString()}\u2103",
                        style: TextStyle(fontSize: 45)
                            .merge(utilities.containerTextStyle()),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,0,15,0),
                    child: Container(
                      decoration: utilities.containerBoxDecoration(),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,0,10),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.network('http://openweathermap.org/img/w/${snapshot.data["weather"][0]["icon"]}.png',
                                    //height: 35,)
                                  ),
                                  Text("${snapshot.data["weather"][0]["main"].toString()}",style: utilities.moreInfoTextStyle().merge(TextStyle(fontSize: 22)),),

                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Min : ${snapshot.data["main"]["temp_min"].toString()}\u2103",style: utilities.moreInfoTextStyle(),),
                              Text("Max : ${snapshot.data["main"]["temp_max"].toString()}\u2103",style: utilities.moreInfoTextStyle(),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Wind : ${snapshot.data["wind"]["speed"].toString()}m/s, ${snapshot.data["wind"]["deg"].toString()}\u00b0",style: utilities.moreInfoTextStyle(),),
                              Text("Clouds : ${snapshot.data["clouds"]["all"].toString()}%",style: utilities.moreInfoTextStyle(),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(snapshot.data["visibility"]==null?"Visibility : N.A.":"Visibility : ${snapshot.data["visibility"].toString()}m",style: utilities.moreInfoTextStyle(),),
                              Text("Pressure : ${snapshot.data["main"]["pressure"].toString()}hPa",style: utilities.moreInfoTextStyle(),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Sunrise : ${DateTime.fromMillisecondsSinceEpoch(snapshot.data["sys"]["sunrise"]*1000).toUtc().hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data["sys"]["sunrise"]*1000).toUtc().minute} ${DateTime.fromMillisecondsSinceEpoch(snapshot.data["sys"]["sunrise"]*1000).toUtc().timeZoneName}",style: utilities.moreInfoTextStyle(),),
                              Text("Sunset : ${DateTime.fromMillisecondsSinceEpoch(snapshot.data["sys"]["sunset"]*1000).toUtc().hour}:${DateTime.fromMillisecondsSinceEpoch(snapshot.data["sys"]["sunrise"]*1000).toUtc().minute} ${DateTime.fromMillisecondsSinceEpoch(snapshot.data["sys"]["sunrise"]*1000).toUtc().timeZoneName}",style: utilities.moreInfoTextStyle(),),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.black26,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.chevron_left,color: utilities.textColor(),)
              ),
            ),
          );
        } else {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar:AppBar(
                backgroundColor: utilities.appBarColor(),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      location == ""
                          ? "Please enter location"
                          : location == null ? utilities.defaultLocation : location,
                      style: utilities.containerTextStyle(),
                    ),
                    FlatButton(
                      child: Icon(Icons.refresh,color: utilities.textColor(),),
                      onPressed:(){
                        refresh(location);
                      },
                    )
                  ],
                ),
              ),
              body : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                      decoration: utilities.containerBoxDecoration(),
                      padding: EdgeInsets.all(10),
                      child: snapshot.data==null?Text("Loading...",style: utilities.moreInfoTextStyle().merge(TextStyle(letterSpacing: 10)),):Text(
                        snapshot.data.toString(),
                        style: utilities.moreInfoTextStyle(),
                      )),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.white12,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.chevron_left,color: utilities.textColor(),)
              ),
            ),
          );
        }
      },
    );
  }
}