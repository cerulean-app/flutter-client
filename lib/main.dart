import 'package:cerulean_app/pages/welcome.dart';
import 'package:cerulean_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: !isMobile(),
      title: kDebugMode ? 'Cerulean (debug)' : 'Cerulean',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routes: {
        '/': (BuildContext context) => const WelcomePage(
            title: kDebugMode ? 'Cerulean (debug)' : 'Cerulean'),
      },
    );
  }
}
