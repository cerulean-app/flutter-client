import 'package:cerulean_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  const ScreenScaffold(
      {Key? key,
      required this.title,
      required this.child,
      this.floatingActionButton,
      this.resizeToAvoidBottomInset = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile()
          ? AppBar(
              title: Text(title),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
            )
          : null,
      body: SizedBox.expand(child: child),
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
