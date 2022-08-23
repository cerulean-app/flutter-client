import 'dart:collection';
import 'dart:convert';

import 'package:cerulean_app/entities/todo.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileStorage extends ChangeNotifier {
  Object? error;
  bool loading = true;

  List<Todo> _todos = [];
  String _token = "";

  FileStorage() {
    loadFromSharedPrefs();
  }

  Future<void> loadFromSharedPrefs() async {
    error = null;
    loading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      _todos = (prefs.getStringList('todos') ?? [])
          .map((json) => Todo.fromJson(jsonDecode(json)))
          .toList();
      _token = prefs.getString('token') ?? "";
    } catch (err) {
      error = err;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> saveToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setStringList(
        'todos', _todos.map((todo) => jsonEncode(todo.toJson())).toList());
  }

  void applyChanges() {
    notifyListeners();
    saveToSharedPrefs().catchError((err) {
      FlutterError.reportError(FlutterErrorDetails(exception: err));
    });
  }

  // Todos
  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  set todos(List<Todo> todos) {
    _todos = todos;
    applyChanges();
  }

  // Token
  String get token => _token;

  set token(String token) {
    _token = token;
    applyChanges();
  }
}
