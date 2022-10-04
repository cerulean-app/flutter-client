import 'dart:convert';

import 'package:cerulean_app/config.dart';
import 'package:cerulean_app/state/file_storage.dart';
import 'package:cerulean_app/utils.dart';
import 'package:cerulean_app/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.debug}) : super(key: key);

  final bool debug;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() {
    // TODO: setState('fetching')
    const jsonEncoder = JsonEncoder();
    http.post(
      Uri.parse('$serverUrl/login'),
      body: jsonEncoder.convert({
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        final fileStorage = Provider.of<FileStorage>(context, listen: false);
        fileStorage.token = token;
        Navigator.of(context).pushNamed('/todos');
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid username or password!',
                  style: TextStyle(color: Colors.red))),
        );
      } else {
        throw Exception(
            'Network request error ${response.statusCode}: ${response.body}');
      }
    }).catchError((err) {
      FlutterError.presentError(FlutterErrorDetails(exception: err));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An unknown error occurred.',
                style: TextStyle(color: Colors.red))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Login to Cerulean ${widget.debug ? ' (debug)' : ''}',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox.fromSize(
            size: const Size(360, 280),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  isMobile()
                      ? Container()
                      : Text(
                          'Log in to Cerulean',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your username!';
                      } else if (!usernameRegExp.hasMatch(value)) {
                        return invalidUsernameError;
                      }
                      return null;
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your password!';
                      } else if (!passwordRegExp.hasMatch(value)) {
                        return invalidPasswordError;
                      }
                      return null;
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(primary: Colors.red),
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil(ModalRoute.withName('/'));
                        },
                        child: const Text('Close',
                            style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            handleLogin();
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
