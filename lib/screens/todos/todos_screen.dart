import 'package:cerulean_app/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key, required this.debug}) : super(key: key);

  final bool debug;

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      title: 'Cerulean ${widget.debug ? ' (debug)' : ''}',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('hey there...'),
          ],
        ),
      ),
    );
  }
}
