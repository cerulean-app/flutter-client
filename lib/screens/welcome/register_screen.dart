import 'dart:convert';

import 'package:cerulean_app/config.dart';
import 'package:cerulean_app/state/file_storage.dart';
import 'package:cerulean_app/utils.dart';
import 'package:cerulean_app/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, required this.debug}) : super(key: key);

  final bool debug;

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleRegister() {
    // TODO: setState('fetching')
    http.post(
      Uri.parse('$serverUrl/register?cookie=false'),
      body: {
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        final fileStorage = Provider.of<FileStorage>(context, listen: false);
        fileStorage.token = token;
        Navigator.of(context).pushNamed('/todos');
      } else if (response.statusCode == 409) {
        final String error = jsonDecode(response.body)['error'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error, style: const TextStyle(color: Colors.red))),
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
      title: 'Cerulean ${widget.debug ? ' (debug)' : ''}',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox.square(
            dimension: 372,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Register a Cerulean Account',
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
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'E-mail',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your e-mail!';
                      } else if (!emailRegExp.hasMatch(value)) {
                        return invalidEmailError;
                      }
                      return null;
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 16.0)),
                  TextFormField(
                    controller: passwordController,
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
                            handleRegister();
                          }
                        },
                        child: const Text('Register'),
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
