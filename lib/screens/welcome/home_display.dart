import 'package:flutter/material.dart';

class HomeDisplay extends StatelessWidget {
  const HomeDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox.square(
          dimension: 360,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Cerulean!',
                style: Theme.of(context).textTheme.headline3,
              ),
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.headline5,
                  children: const [
                    TextSpan(
                        text:
                            '\nCerulean is a todo app focused around keeping it simple and helping you get work '),
                    TextSpan(
                        text: 'done',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    TextSpan(text: '. Inspired by Google Tasks.\n'),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    child:
                        const Text('Login', style: TextStyle(fontSize: 24.0)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/register'),
                    child: const Text('Register',
                        style: TextStyle(color: Colors.teal, fontSize: 24.0)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
