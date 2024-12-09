import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'api_key.dart';
import 'package:weatherapi/weatherapi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
        scaffoldBackgroundColor: Color.fromRGBO(51, 51, 51, 1.0),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageScreen();
}

class HomePageScreen extends State<HomePage> {
  String selectedCity = 'Surgut';
  Map <String, dynamic>? weatherData;
  bool check = false;

  @override
  void initState() {
    super.initState();
    updateWeatherData(check);
  }

  Future <void> updateWeatherData(check) async {
    int days = 7;
    if (check)
      days = 1;
    final response = await http.get(Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=$api_key&q=$selectedCity&days=$days&aqi=yes&alerts=no'));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
      });
    }
    else
      throw Exception('Ошибка при загрузке погоды');
  }

  @override
  Widget build(BuildContext context) {
    List <String> DaysWeek = ['Mon', 'Tus', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(30, 40, 10, 20),
          decoration: BoxDecoration(
            color: Color.fromRGBO(218, 119, 14, 1.0),
          ),
          child: Text(
            'Weather🌍',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
        elevation: 5.0,
        shadowColor: Colors.black,
        toolbarHeight: 70,
      actions: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 25, 0),
          child: Text(
            '${DaysWeek[DateTime.now().weekday-1]} ${DateTime.now().day}.${DateTime.now().month}',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ]
      ),
      body: Column(
        children: [
            Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(13, 191, 28, 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: IconButton(
                    onPressed: () {
                      check = !check;
                      updateWeatherData(check);
                    },
                    color: Colors.white,
                    icon: Icon(
                        check ? Icons.calendar_view_day_rounded
                            : Icons.calendar_view_week_rounded
                    ),
                    iconSize: 40,
                  ),
                ),
                Expanded(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$selectedCity',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: IconButton(
                    onPressed: () {
                      setCity();
                    },
                    color: Colors.white,
                    icon: Icon(Icons.search_rounded),
                    iconSize: 40,
                  ),
                ),
              ],
            ),
          ),
          weatherData == null ? buildCenter() : buildContainer(),
        ],
      ),
    );
  }

  Widget buildCenter() => Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(top: 200),
    child: Text(
      "I'm looking at the sky, you're waiting for the forecast, okay?)",
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    ),
  );

  Widget buildContainer() => Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
        alignment: Alignment.center,
        height: 200,
        decoration: BoxDecoration(
          color: Color.fromRGBO(218, 119, 14, 1.0),
          border: Border.all(color: Color.fromRGBO(21, 21, 21, 1.0), width: 2),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 170,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(147, 146, 146, 0.6137254901960784),
                border: Border.all(color: Color.fromRGBO(230, 133, 49, 1.0), width: 3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    check ? 'Right now:' : 'Today:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    check ? '${weatherData?['current']['temp_c']} °C'
                          : '${weatherData?['forecast']['forecastday'][0]['day']['avgtemp_c']} °C',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    check ? '${weatherData?['current']['condition']['text']}'
                        : '${weatherData?['forecast']['forecastday'][0]['day']['condition']['text']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: SizedBox(
                child: Image.network(
                  check ? 'https:' + weatherData!['current']['condition']['icon']
                  : 'https:' + weatherData!['forecast']['forecastday'][0]['day']['condition']['icon'],
                  scale: 0.4,
                ),
              ),
            ),
          ],
        )
      ),
      check ? BuildForecast([0, 4, 8]) : BuildForecast([1, 2, 3]),
      check ? BuildForecast([12, 16, 20]) : BuildForecast([4, 5, 6]),
      BuildAddiction(),
    ],
  );

  Widget BuildForecast(List<int> hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: hours.map((hour) {
        return ForecastStyle(hour);
      }).toList(),
    );
  }

  Widget ForecastStyle(int label) {
    String hourText = '0';
    String dayMonth = '';
    if (label < 10 && check) {
      hourText += label.toString() + ':00';
    }
    else if (label > 10 && check)
      hourText = label.toString() + ':00';
    else {
      String date = weatherData?['forecast']['forecastday'][label]['date'];
      List<String> dateParts = date.split('-');
      dayMonth = '${dateParts[2]}-${dateParts[1]}';
    }

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(top: 5),
        height: 140,
        width: 115,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromRGBO(99, 99, 99, 1.0),
          border: Border.all(color: Color.fromRGBO(21, 21, 21, 1.0), width: 2),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),],
        ),
        child: Column(
          children: [
            SizedBox(
              child: Image.network(
                  check ? 'https:' + weatherData!['forecast']['forecastday'][0]['hour'][label]['condition']['icon']
                      : 'https:' + weatherData!['forecast']['forecastday'][label]['day']['condition']['icon'],
              ),
              height: 50,
            ),
            Text(
              check ? '${weatherData?['forecast']['forecastday'][0]['hour'][label]['temp_c']}°C ️'
                : '${weatherData?['forecast']['forecastday'][label]['day']['avgtemp_c']}°C ️',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              check ? '$hourText ️' : dayMonth,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget BuildAddiction() {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            padding: EdgeInsets.only(top: 5, left: 20),
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color.fromRGBO(14, 79, 218, 1.0),
              border: Border.all(color: Color.fromRGBO(21, 21, 21, 1.0), width: 2),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),],
            ),
            child: Text(
              check ? 'Wind: ${weatherData?['current']['wind_kph']} kph, ${weatherData?['current']['wind_dir']}'
                  : 'Wind: ${weatherData?['forecast']['forecastday'][0]['day']['avgvis_km']} kph',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15),
            padding: EdgeInsets.only(top: 5, left: 20),
            height: 70,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color.fromRGBO(14, 79, 218, 1.0),
              border: Border.all(color: Color.fromRGBO(21, 21, 21, 1.0), width: 2),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),],
            ),
            child: Text(
              check ? 'Humidity: ${weatherData?['current']['humidity']}% ️'
                : 'Humidity: ${weatherData?['forecast']['forecastday'][0]['day']['avghumidity']}% ️',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      )
    );
  }

  void setCity() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              'Select City',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: 280,
            ),
            child: ListView(
              children: [
                ListTile(
                  title: Text('Moscow'),
                  onTap: () {
                    setState(() {
                      selectedCity = 'Moscow';
                      updateWeatherData(check);
                    });
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  title: Text('Serov'),
                  onTap: () {
                    setState(() {
                      selectedCity = 'Serov';
                      updateWeatherData(check);
                    });
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  title: Text('Sverdlovsk'),
                  onTap: () {
                    setState(() {
                      selectedCity = 'Sverdlovsk';
                      updateWeatherData(check);
                    });
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  title: Text('Khanty-Mansiysk'),
                  onTap: () {
                    setState(() {
                      selectedCity = 'Khanty-Mansiysk';
                      updateWeatherData(check);
                    });
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  title: Text('Surgut'),
                  onTap: () {
                    setState(() {
                      selectedCity = 'Surgut';
                      updateWeatherData(check);
                    });
                    Navigator.pop(context);
                  }
                ),
              ],
            ),
          )
        );
      }
    );
  }
}