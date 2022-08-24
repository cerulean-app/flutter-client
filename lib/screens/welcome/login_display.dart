import 'package:cerulean_app/utils.dart';
import 'package:flutter/material.dart';

class LoginDisplay extends StatefulWidget {
  const LoginDisplay({Key? key, required this.onClose}) : super(key: key);

  final Function onClose;

  @override
  State<StatefulWidget> createState() => _LoginDisplayState();
}

class _LoginDisplayState extends State<LoginDisplay> {
  final _formKey = GlobalKey<FormState>();

  void handleLogin() {
    // TODO: login properly
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );
    /*
    setStatus('fetching')
    fetch(reqUrl + '/login?cookie=false', { method: 'POST', body: JSON.stringify({ username, password }) })
      .then(res => {
        if (res.ok) {
          res.json().then(resp => {
            setToken(resp.token)
            // setStatus(null) - causes async state update noop.
          }).catch(() => setStatus('unknown'))
        } else if (res.status === 401) {
          setStatus('invalid')
        } else setStatus('unknown')
      }).catch(() => setStatus('unknown'))
    */
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  'Log in to Cerulean',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                TextFormField(
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
                // TODO: {status === 'unknown' && <h5 css={css`color: #ff6666`}>An unknown error occurred.</h5>}
                // TODO: {status === 'invalid' && <h5 css={css`color: #ff6666`}>Invalid username or password!</h5>}
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        widget.onClose();
                      },
                      child: const Text('Close',
                          style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          handleLogin();
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
