import 'package:cerulean_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? floatingActionButton;

  const ScreenScaffold(
      {Key? key,
      required this.title,
      required this.child,
      this.floatingActionButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile()
          ? AppBar(
              title: Text(title),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
            )
          : null,
      body: Padding(padding: const EdgeInsets.all(16), child: child),
      floatingActionButton: floatingActionButton,
    );
  }
}
