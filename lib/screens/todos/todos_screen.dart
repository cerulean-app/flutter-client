import 'dart:async';
import 'dart:convert';

import 'package:cerulean_app/config.dart';
import 'package:cerulean_app/entities/todo.dart';
import 'package:cerulean_app/state/file_storage.dart';
import 'package:cerulean_app/widgets/change_password_dialog.dart';
import 'package:cerulean_app/widgets/delete_account_dialog.dart';
import 'package:cerulean_app/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key, required this.debug}) : super(key: key);

  final bool debug;

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  List<Todo> todos = [];
  late Timer timer;

  _fetchTodos() {
    final fileStorage = Provider.of<FileStorage>(context, listen: false);
    setState(() => todos = fileStorage.todos);

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      http.get(Uri.parse('$serverUrl/todos'), headers: {
        'authorization': fileStorage.token,
      }).then((response) {
        final List todosRaw = jsonDecode(response.body);
        fileStorage.todos = todosRaw.map((e) => Todo.fromJson(e)).toList();
        setState(() => todos = fileStorage.todos);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<http.Response> fetchLogout(String token) {
    return http.post(Uri.parse('$serverUrl/logout'), headers: {
      'authorization': token,
    });
  }

  void handleLogout() {
    final fileStorage = Provider.of<FileStorage>(context, listen: false);
    fetchLogout(fileStorage.token).then((response) {
      if (response.statusCode == 200 || response.statusCode == 401) {
        fileStorage.token = '';
        timer.cancel();
        Navigator.of(context).pushNamed('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Couldn\'t logout. Please try again.',
                  style: TextStyle(color: Colors.red))),
        );
      }
    });
  }

  Future<void> _changePasswordDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  Future<void> _deleteAccountDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => DeleteAccountDialog(timer: timer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Cerulean ${widget.debug ? ' (debug)' : ''}',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: handleLogout,
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Logout'),
                      )),
                  Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: () => _changePasswordDialog(context),
                        icon: const Icon(Icons.password),
                        label: const Text('Change Password'),
                      )),
                  Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.resolveWith(
                              (state) => Colors.red),
                        ),
                        onPressed: () => _deleteAccountDialog(context),
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('Delete Account'),
                      )),
                ],
              ),
            ),
            Align(
                // TODO: Actual UI with each to-do.
                alignment: Alignment.center,
                child: Text(todos.map((todo) => todo.name).join('\n'))),
          ],
        ),
      ),
    );
  }
}
