import 'dart:convert';

import 'package:cerulean_app/config.dart';
import 'package:cerulean_app/entities/todo.dart';
import 'package:cerulean_app/screens/welcome/home_display.dart';
import 'package:cerulean_app/state/file_storage.dart';
import 'package:cerulean_app/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.debug}) : super(key: key);

  final bool debug;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool checking = true;

  Future<http.Response> fetchTodos(String token) {
    return http.get(Uri.parse('$serverUrl/todos'), headers: {
      'authorization': token,
    });
  }

  void updateTodos() {
    setState(() => checking = true);
    final fileStorage = Provider.of<FileStorage>(context, listen: false);

    if (fileStorage.token == "") {
      setState(() => checking = false);
    } else {
      fetchTodos(fileStorage.token).then((response) {
        if (response.statusCode == 200) {
          final List todos = jsonDecode(response.body)["todos"];
          fileStorage.todos = todos.map((e) => Todo.fromJson(e)).toList();

          Navigator.of(context).pushNamed('/todos');
        } else if (response.statusCode == 401) {
          fileStorage.token = "";
          fileStorage.todos = [];

          setState(() => checking = false);
        } else {
          throw Exception(
              'Network request error ${response.statusCode}: ${response.body}');
        }
      }).catchError((err) {
        FlutterError.presentError(FlutterErrorDetails(exception: err));
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Error!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'Looks like an error occurred when trying to access the Cerulean back-end.'),
                  Text('Would you like to retry connecting?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Retry', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  updateTodos();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Cerulean ${widget.debug ? ' (debug)' : ''}',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: checking == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox.square(
                    dimension: 96.0,
                    child: CircularProgressIndicator(strokeWidth: 8.0),
                  )
                ],
              )
            : const HomeDisplay(),
      ),
    );
  }
}
