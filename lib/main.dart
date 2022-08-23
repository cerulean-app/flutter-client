import 'package:cerulean_app/screens/todos/todos_screen.dart';
import 'package:cerulean_app/screens/welcome/welcome_screen.dart';
import 'package:cerulean_app/state/file_storage.dart';
import 'package:cerulean_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // Load config.
  var storage = FileStorage();
  try {
    await storage.loadFromSharedPrefs();
  } catch (err) {
    FlutterError.reportError(FlutterErrorDetails(exception: err));
  }

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider<FileStorage>(create: (_) => storage)],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
        '/': (BuildContext context) => const WelcomeScreen(debug: kDebugMode),
        '/todos': (BuildContext context) =>
            const TodosScreen(debug: kDebugMode),
      },
    );
  }
}
