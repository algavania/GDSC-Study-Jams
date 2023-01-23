import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:weather_app/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoaderOverlay(child: HomePage()),
        );
      },
      maximumSize: const Size(475.0, 812.0), // Maximum size
      enabled: kIsWeb, // default is enable, when disable content is full size
      backgroundColor: Colors.grey[200], // Background color/white space
    );
  }
}
