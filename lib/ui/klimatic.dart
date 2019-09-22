import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;

  Future goToCity(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCity();
    }));
    if (results != null && results.containsKey('city')) {
      _cityEntered = results['city'];
    } else {
      _cityEntered = results['city'] = util.defaultCity;
    }
  }

  void showWeather() async {
    Map _data = await getWeather(util.apiId, util.defaultCity);
    print(_data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(
          "Climatic Weather App",
          style: TextStyle(
              color: Colors.black87,
              fontSize: 23.0,
              fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent.shade200,
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            tooltip: "Change City",
            splashColor: Colors.black26,
            onPressed: () {
              goToCity(context);
            },
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          // new Center(
          //   child: new Image.asset(
          //     'images/white_snow.png',
          //     height: 1200,
          //     width: 500,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 30.0, 40.0, 0.0),
            child: new Text(
              "CITY:${_cityEntered == null ? util.defaultCity : _cityEntered}"
                  .toUpperCase(),
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
          ),
          new Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(0.0, 105.0, 0.0, 0.0),
            child: new Image.asset('images/earth.png'),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(40.0, 250.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String apiId, String city) async {
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiId&units=metric";

    http.Response response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return (throw Exception('Failed to load city'));
    }
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(util.apiId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          List content_1 = content['weather'];
          return Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "Weather Forecast",
                    style: TextStyle(
                        color: Colors.blue.shade600,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0),
                  ),
                  // new Divider(
                  //   color: Colors.black,
                  //   height: 20.0,
                  // ),
                  Center(
                    child: new ListTile(
                      title: Center(
                        child: new Text(
                          content['main']['temp'].toString() + "°C",
                          style: new TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 60.9,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: new ListTile(
                      title: Center(
                        child: new Text(
                          "Humidity: ${content['main']['humidity'].toString()}\n"
                              "Min: ${content['main']['temp_min'].toString()} C\n"
                              "Max: ${content['main']['temp_max'].toString()} C \n"
                              "Description: ${content_1[0]['description'].toString().toUpperCase()} ",
                          style: extraData(),
                        ),
                      ),
                    ),
                  ),
                  // new Divider(
                  //   color: Colors.black,
                  //   height: 20.0,
                  // ),
                  new SizedBox(
                    height: 50.0,

                  ),
                  new Text(
                    "To change city tap the top right corner icon.",
                    style: extraData(),
                  )
                ],
              ),
            ),
          );
        } else {
          return new Container();
        }
      },
    );
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.lightBlueAccent.shade200,
        title: Text(
          "Change City",
          style: TextStyle(
              color: Colors.black87, fontSize: 23.0, fontWeight: FontWeight.normal),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          // new Center(
          //   child: new Image.asset(
          //     'images/white_snow.png',
          //     height: 1200.0,
          //     width: 490.0,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  textInputAction: TextInputAction.none,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Enter City:",
                  ),
                  controller: _cityFieldController,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  color: Colors.lightBlueAccent.shade400,
                  child: Text("Get Weather"),
                  textColor: Colors.white,
                  onPressed: () {
                    if (_cityFieldController.text.isNotEmpty) {
                      Navigator.pop(
                          context, {'city': _cityFieldController.text});
                    } else {
                      Navigator.pop(context, {'city': util.defaultCity});
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle extraData() {
  return new TextStyle(
      color: Colors.black87, fontStyle: FontStyle.normal, fontSize: 18.0);
}
