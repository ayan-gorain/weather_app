import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/sectrcts.dart';
import 'additionalitem.dart';
import 'hourley_forecast_itrem.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String cityName = "sehore";

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$onpenweatherapi'),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw "An unexpected error occurred";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currTemp = currentWeatherData['main']['temp'];
          final currTempCelsius = (currTemp - 273.15).toStringAsFixed(1);
          final season = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final windSpeed = currentWeatherData['wind']['speed'];
          final humidity = currentWeatherData['main']['humidity'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // City Input Field
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: "Enter City",
                      hintText: "Type city name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        cityName = value; // Update city name
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Main Weather Card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currTempCelsius °C',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Icon(
                                  season == 'Clouds' || season == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 90,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  season,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Hourly Forecast
                  Text(
                    "Hourly Forecast",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyFore = data['list'][index + 1];
                        final time = DateTime.parse(hourlyFore['dt_txt']);
                        final tempKelvin = hourlyFore['main']['temp'];
                        final tempCelsius = (tempKelvin - 273.15).toStringAsFixed(1);

                        return timehourley(
                          time: DateFormat.j().format(time),
                          icon: hourlyFore['weather'][0]['main'] == 'Clouds' ||
                              hourlyFore['weather'][0]['main'] == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          dregee: '$tempCelsius °C',
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // Additional Information
                  Text(
                    "Additional Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Additional(icon: Icons.water_drop, lebeel: "Humidity", number: humidity.toString()),
                      Additional(icon: Icons.air, lebeel: "Wind Speed", number: windSpeed.toString()),
                      Additional(icon: Icons.beach_access, lebeel: "Pressure", number: currentPressure.toString()),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
