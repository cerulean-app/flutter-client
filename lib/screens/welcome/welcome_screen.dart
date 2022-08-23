import 'dart:convert';

import 'package:cerulean_app/config.dart';
import 'package:cerulean_app/entities/todo.dart';
import 'package:cerulean_app/state/file_storage.dart';
import 'package:cerulean_app/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key, required this.debug}) : super(key: key);

  final bool debug;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool? checking = true;

  Future<http.Response> fetchTodos(String token) {
    return http.get(Uri.parse('$serverUrl/todos'), headers: {
      'authorization': token,
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => checking = true);
      final fileStorage = Provider.of<FileStorage>(context, listen: false);

      if (fileStorage.token == "") {
        setState(() => checking = false);
      } else {
        fetchTodos(fileStorage.token).then((response) {
          if (response.statusCode == 200) {
            final List<Map<String, dynamic>> todos = jsonDecode(response.body);
            fileStorage.todos = todos.map((e) => Todo.fromJson(e)).toList();

            Navigator.of(context).pushNamed('/todos');
          } else if (response.statusCode == 401) {
            fileStorage.token = "";
            setState(() => checking = false);
          } else {
            FlutterError.presentError(FlutterErrorDetails(
                exception: Exception(
                    'Network request error ${response.statusCode}: ${response.body}')));
            setState(() => checking = null);
          }
        }).catchError((err) {
          FlutterError.presentError(FlutterErrorDetails(exception: err));
          setState(() => checking = null);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Cerulean ${widget.debug ? ' (debug)' : ''}',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            checking == true
                ? const SizedBox.square(
                    dimension: 96.0,
                    child: CircularProgressIndicator(strokeWidth: 8.0),
                  )
                : checking == false
                    ? const Text('Token is invalid')
                    : const Text('Unknown error'),
          ],
        ),
      ),
    );
  }
}
