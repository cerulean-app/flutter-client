import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../state/file_storage.dart';
import '../utils.dart';
import 'package:http/http.dart' as http;

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

  void _submitForm([String? value]) {
    if (_formKey.currentState!.validate()) {
      handleChangePassword();
    }
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

  @override
  Widget build(BuildContext context) {
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
              onFieldSubmitted: _submitForm,
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
              onFieldSubmitted: _submitForm,
            ),
            const Padding(padding: EdgeInsets.only(top: 16.0)),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Confirm New Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm your new password!';
                } else if (value != newPasswordController.text) {
                  return passwordsDoNotMatch;
                }
                return null;
              },
              onFieldSubmitted: _submitForm,
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
          onPressed: _submitForm,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
