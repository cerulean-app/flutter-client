import 'package:cerulean_app/config.dart';
import 'package:cerulean_app/state/file_storage.dart';
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
  Future<http.Response> fetchLogout(String token) {
    return http.post(Uri.parse('$serverUrl/logout'), headers: {
      'authorization': token,
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
            const Text('hey there...'),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                final fileStorage = Provider.of<FileStorage>(context, listen: false);
                fetchLogout(fileStorage.token).then((response) => {
                  if (response.statusCode == 200) {
                    Navigator.of(context).pushNamed('/')
                  } else {
                    print(response.statusCode),
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Couldn\'t logout. Please try again.',
                        style: TextStyle(color: Colors.red))
                      ),
                    )
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
