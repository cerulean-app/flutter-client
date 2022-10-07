import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../state/file_storage.dart';
import 'package:http/http.dart' as http;

class DeleteAccountDialog extends StatefulWidget {
  final Timer timer;

  const DeleteAccountDialog({Key? key, required this.timer}) : super(key: key);

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
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

  void handleDeleteAccount() {
    final fileStorage = Provider.of<FileStorage>(context, listen: false);
    fetchDeleteAccount(fileStorage.token).then((response) {
      if (response.statusCode == 200) {
        fileStorage.token = '';
        fileStorage.todos = [];
        // TODO: use dispose instead of pushing to /, cancel timer on dispose
        widget.timer.cancel();
        Navigator.of(context).pushNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Align(
          alignment: Alignment.topLeft, child: Text('This cannot be undone.')),
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
  }
}
