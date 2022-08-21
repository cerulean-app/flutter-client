import 'package:cerulean_app/screens/welcome.dart';
import 'package:cerulean_app/state/storage_model.dart';
import 'package:cerulean_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  var storage = StorageModel(); // TODO: read and save storage

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider<StorageModel>(create: (_) => storage)],
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
        '/': (BuildContext context) => const WelcomeScreen(
            title: 'Cerulean ${kDebugMode ? ' (debug)' : ''}'),
      },
    );
  }
}
