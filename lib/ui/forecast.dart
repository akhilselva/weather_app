// FORECAST
//https://www.countryflags.io/ used for Country icons in Forecast page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utilities.dart' as utilities;
import 'home.dart';

class Forecast extends StatefulWidget {
  final String location;
  Forecast({Key key, @required this.location}): super(key:key);
  @override
  _ForecastState createState() => _ForecastState(location: location);
}

class _ForecastState extends State<Forecast> {
  final String location;
  var forecastInfo;
  _ForecastState({Key key, @required this.location});
  void initState(){
    super.initState();
    forecastInfo=getForecastInfo(utilities.appId, location);
  }
  refresh(String loco){
    print("From refresh fn-$loco");
    setState(() {
      forecastInfo=null;
      forecastInfo=getForecastInfo(utilities.appId, loco);
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: forecastInfo,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
    if (snapshot.hasData && snapshot.data.containsKey("list")) {
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
                    "Forecast",
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
            body: ListView(
              //scrollDirection: Axis.horizontal,
              children: <Widget>[
                //Text(snapshot.data.toString(),style: utilities.moreInfoTextStyle(),textAlign: TextAlign.justify,),
                Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network("https://www.countryflags.io/${snapshot.data["city"]["country"].toString()}/flat/32.png"),
                      Text(snapshot.data["city"]["name"].toString(),style: utilities.moreInfoTextStyle().merge(TextStyle(fontSize: 35)),),
                      Padding(padding: EdgeInsets.all(5),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Population : ${snapshot.data["city"]["population"].toString()}",style: utilities.moreInfoTextStyle(),),
                          Text("Timezone : ${snapshot.data["city"]["timezone"].toString()}",style: utilities.moreInfoTextStyle(),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(20),),
                      Text("5 days/3 hours forecast data",style: utilities.moreInfoTextStyle(),),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(10),),
                Container(
                  height: 275,
                  //width: 300,
                  child: Scrollbar(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data["cnt"],
                        separatorBuilder: (context, index){
                          return VerticalDivider(
                            width: 5,
                            color: Colors.transparent,
                          );
                        },
                        itemBuilder: (BuildContext context, int index){
                        return Container(
                          decoration: utilities.containerBoxDecoration(),
                          width: 300,
                          child: Column(
                            children: <Widget>[
                              Text("${utilities.unixToNormal(snapshot.data["list"][index]["dt"])} (${DateTime.fromMillisecondsSinceEpoch(snapshot.data["list"][index]["dt"]).toUtc().timeZoneName})",style: utilities.moreInfoTextStyle().merge(TextStyle(fontSize: 15)),),
                              Padding(padding: EdgeInsets.all(10),),
                              Image.network('http://openweathermap.org/img/w/${snapshot.data["list"][index]["weather"][0]["icon"].toString()}.png',
                                height: 35,
                              ),
                              Text(snapshot.data["list"][index]["weather"][0]["main"].toString(),style: utilities.moreInfoTextStyle(),),
                              Text("(${snapshot.data["list"][index]["weather"][0]["description"].toString()})",style: utilities.moreInfoTextStyle().merge(TextStyle(fontStyle: FontStyle.italic)),),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0,10,0,20),
                                child: Text("${snapshot.data["list"][index]["main"]["temp"].toString()}\u2103",style: utilities.moreInfoTextStyle(),),
                              ),
                              Container(
                                width: 275,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Min : ${snapshot.data["list"][index]["main"]["temp_min"].toString()}\u2103",style: utilities.moreInfoTextStyle(),),
                                        Text("Max : ${snapshot.data["list"][index]["main"]["temp_max"].toString()}\u2103",style: utilities.moreInfoTextStyle(),),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(1.5),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Humidity : ${snapshot.data["list"][index]["main"]["humidity"].toString()}%",style: utilities.moreInfoTextStyle(),),
                                        Text("Clouds : ${snapshot.data["list"][index]["clouds"]["all"].toString()}%",style: utilities.moreInfoTextStyle(),),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(1.5),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Wind : ${snapshot.data["list"][index]["wind"]["speed"].toString()}m/s, ${snapshot.data["list"][index]["wind"]["deg"].toString()}\u00b0",style: utilities.moreInfoTextStyle(),),
                                        //Text("Wind dir : ",style: utilities.moreInfoTextStyle(),),
                                      ],
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        );
                    }),
                  ),
                )
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
      }else {
      return Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: utilities.appBarColor(),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Forecast",
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
