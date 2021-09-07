// @dart=2.9
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/GetIcons.dart';
import 'GetLocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  //Create an account at https://openweathermap.org/
  //then remove XXXXXXXXX and add you api key here
  Future main() async {
    // To load the .env file contents into dotenv.
    // NOTE: fileName defaults to .env and can be omitted in this case.
    // Ensure that the filename corresponds to the path in step 1 and 2.
    await dotenv.load(fileName: ".env");
    //...runapp
  }
  bool yukleniyor=false;
  String apiKey = '4a8358a594c372974a8d2db780440625';
  var description;
  var temp;
  String city="";
  String feels_like="";
  String temp_min="";
  String temp_max="";
  String humidity="";
  String icon="";

@override
  void initState() {

    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: yukleniyor==false ? Scaffold(
        backgroundColor: Colors.black,
        body: Center(

          child:SpinKitSpinningLines(color: Colors.white,size: 150.0,) ,
        ),
      ):Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: displayImage(),//Image.asset('images/dayTime.jpg'),
            ),
            //SizedBox(height: 50.0,),
            Container(
              margin: EdgeInsets.only(top: 50.0),

            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(city.toString(), style:
                    TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[500],
                    ),),
                  ),
                  SizedBox(width: 10.0,),
                  Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 35.0,
                    ),
                  ),
                ],
              ),
            ),
            Card (

              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 17.0, horizontal: 25.0),

              child: ListTile(

                leading: GetIcons.getIcon( '${icon.toString()}'),

                title: Text(
                  'Temperature: ${temp.toString()} C '
                      '\n Feels Like: ${feels_like.toString()} '
                      '\n Minumum Temp: ${temp_min.toString()}'
                      '\n Maximum Temp: ${temp_max.toString()}',
                ),
                subtitle: Text('Status: ${description.toString()}\n'
                    'Humidity: ${humidity.toString()}'),
              ),
            ),
            Container(
              child: Center(
                child: FlatButton(
                  child: Text('Get weather info'),
                  color: Colors.blue[500],
                  textColor: Colors.white,
                  onPressed: () {

                     getLocation();

                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //display images baed on current time
  displayImage(){
    var now = DateTime.now();
    final currentTime = DateFormat.jm().format(now);
    if(currentTime.contains('AM')){

      return Image.asset('images/dayTime.png');
    }else if(currentTime.contains('PM')){
      return Image.asset('images/nightTime.png');
    }
  }


  //getLocation
  void getLocation() async{
    Getlocation getlocation = Getlocation();
    await getlocation.getCurrentLocation();

    print(getlocation.latitude);
    print(getlocation.longitude);
    print(getlocation.city);
    city = getlocation.city;
    await getTemp(getlocation.latitude, getlocation.longitude);
    setState(() {
      yukleniyor=true;
    });
  }


  //Get current temp
  Future<void> getTemp(double lat, double lon) async{


    http.Response response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));
    print(response.body);
//https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric
    var dataDecoded = jsonDecode(response.body);
    description = dataDecoded['weather'][0]['description'];
    temp = dataDecoded['main']['temp'];
    feels_like = dataDecoded['main']['feels_like'].toString();
    temp_min = dataDecoded['main']['temp_min'].toString();
    temp_max = dataDecoded['main']['temp_max'].toString();
    humidity = dataDecoded['main']['humidity'].toString();
    icon= dataDecoded['main']['icon'].toString();
    print('derece'+temp.toString());


  }
}

