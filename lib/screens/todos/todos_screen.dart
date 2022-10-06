import 'dart:async';
import 'dart:convert';

import 'package:cerulean_app/config.dart';
import 'package:cerulean_app/entities/todo.dart';
import 'package:cerulean_app/state/file_storage.dart';
import 'package:cerulean_app/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../utils.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key, required this.debug}) : super(key: key);

  final bool debug;

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  List<Todo> todos = [];
  late Timer timer;

  final _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

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

  Future<http.Response> fetchChangePassword(
      String token, String currentPassword, String newPassword) {
    const jsonEncoder = JsonEncoder();
    return http.post(Uri.parse('$serverUrl/changepassword'),
        headers: {
          'authorization': token,
        },
        body: jsonEncoder.convert({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }));
  }

  Future<http.Response> fetchDeleteAccount(String token) {
    return http.post(Uri.parse('$serverUrl/deleteaccount'), headers: {
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

  void handleChangePassword() {
    final fileStorage = Provider.of<FileStorage>(context, listen: false);
    fetchChangePassword(fileStorage.token, oldPasswordController.text,
            newPasswordController.text)
        .then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Password changed successfully!',
                  style: TextStyle(color: Colors.green))),
        );
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        // Handling for 400 too as an old password
        // not passing through validation is incorrect anyway.
        // TODO: Bug: snackbar shows behind the dialog.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Old password does not match!',
                  style: TextStyle(color: Colors.red))),
        );
      }
    });
  }

  Future<void> _changePasswordDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Old Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your old password!';
                    }

                    return null;
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'New Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your new password!';
                    } else if (!passwordRegExp.hasMatch(value)) {
                      return invalidPasswordError;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  handleChangePassword();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void handleDeleteAccount() {
    final fileStorage = Provider.of<FileStorage>(context, listen: false);
    fetchDeleteAccount(fileStorage.token).then((response) {
      if (response.statusCode == 200) {
        fileStorage.token = '';
        fileStorage.todos = [];
        timer.cancel();
        Navigator.of(context).pushNamed('/');
      }
    });
  }

  Future<void> _deleteAccountDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Align(
              alignment: Alignment.topLeft,
              child: Text('This cannot be undone.')),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.resolveWith(
                    (state) => Theme.of(context).textTheme.labelLarge),
                foregroundColor:
                    MaterialStateProperty.resolveWith((state) => Colors.red),
              ),
              child: const Text('Delete'),
              onPressed: () {
                handleDeleteAccount();
              },
            ),
          ],
        );
      },
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
