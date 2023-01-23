import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import 'models/city_response_model.dart';
import 'models/condition_response_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _city = 'None';
  String _svgUrl = 'assets/day.svg';
  String _svgTemperatureUrl = 'assets/icons/1.svg';
  String _condition = '-';
  String _temperature = '-';
  final String _apiKey = 'AQhGafsko3RyzvacNT8oIaMX4JPx0EaC';

  Future<void> _getCity(String city) async {
    context.loaderOverlay.show();
    var response = await http.get(Uri.parse(
        'http://dataservice.accuweather.com/locations/v1/cities/search?apikey=$_apiKey&q=$city'));
    if (response.statusCode == 200) {
      List<CityResponseModel> cities = cityResponseModelFromJson(response.body);
      CityResponseModel cityModel = cities.first;
      await _getCurrentCondition(cityModel);
      context.loaderOverlay.hide();
    } else {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('Error')));
    }
  }

  Future<void> _getCurrentCondition(CityResponseModel city) async {
    var response = await http.get(Uri.parse(
        'http://dataservice.accuweather.com/currentconditions/v1/${city.key}?apikey=$_apiKey'));
    if (response.statusCode == 200) {
      List<ConditionResponseModel> models =
          conditionResponseModelFromJson(response.body);
      ConditionResponseModel model = models.first;
      setState(() {
        _city = city.localizedName;
        _svgUrl = model.isDayTime ? 'assets/day.svg' : 'assets/night.svg';
        _svgTemperatureUrl = 'assets/icons/${model.weatherIcon}.svg';
        _condition = model.weatherText;
        _temperature =
            '${model.temperature.metric.value}°${model.temperature.metric.unit}';
      });
    } else {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text('Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const Text('Enter a location for weather information.'),
                    const SizedBox(height: 12),
                    TextField(
                      onSubmitted: (s) {
                        _getCity(s);
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(4))),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                  flex: 3,
                  child: SvgPicture.asset(
                    _svgUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  )),
              Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Column(children: [
                        const SizedBox(height: 70),
                        Text(
                          _city,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.8,
                              color: Colors.grey[600],
                              fontSize: 20),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _condition,
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.grey[600],
                              fontSize: 12),
                        ),
                        const Spacer(),
                        FittedBox(
                          child: Text(
                            _temperature,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.5,
                                color: Colors.grey[600],
                                fontSize: 50),
                          ),
                        ),
                      ]),
                      Positioned(
                        top: -50,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          radius: 50,
                          child: SvgPicture.asset(
                            _svgTemperatureUrl,
                          ),
                        ),
                      )
                    ],
                  )),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
