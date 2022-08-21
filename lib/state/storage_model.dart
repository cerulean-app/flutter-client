import 'dart:collection';
import 'dart:convert';

import 'package:cerulean_app/entities/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageModel extends ChangeNotifier {
  final List<Todo> _todos = [];
  String? _token;

  Future<void> loadFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _todos.clear();
    _todos.addAll((prefs.getStringList('todos') ?? [])
        .map((json) => Todo.fromJson(jsonDecode(json)))
        .toList());
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<void> saveToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token ?? "");
    prefs.setStringList(
        'todos', _todos.map((todo) => jsonEncode(todo.toJson())).toList());
    notifyListeners();
  }

  // Todos
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  set todos(List<Todo> todos) {
    _todos.clear();
    _todos.addAll(todos);
    notifyListeners();
  }

  // Token
  String? get token => _token;

  set token(String? value) {
    _token = value;
    notifyListeners();
  }
}
