import 'package:cerulean_app/utils.dart';
import 'package:flutter/material.dart';

class RegisterDisplay extends StatefulWidget {
  const RegisterDisplay({Key? key, required this.onClose}) : super(key: key);

  final Function onClose;

  @override
  State<StatefulWidget> createState() => _RegisterDisplayState();
}

class _RegisterDisplayState extends State<RegisterDisplay> {
  final _formKey = GlobalKey<FormState>();

  void handleRegister() {
    // TODO: register properly
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing Data')),
    );
    /*
    setStatus('fetching')
    fetch(reqUrl + '/register?cookie=false', { method: 'POST', body: JSON.stringify({ username, password, email }) })
      .then(res => {
        if (res.ok) {
          res.json().then(resp => {
            setToken(resp.token)
            // setStatus(null) - causes async state update noop.
          }).catch(() => setStatus('An unknown error occurred.'))
        } else if (res.status === 409) {
          res.json()
            .then(resp => setStatus(resp.error))
            .catch(() => setStatus('An unknown error occurred.'))
        } else setStatus('An unknown error occurred.')
      }).catch(() => setStatus('An unknown error occurred.'))
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
                  'Register a Cerulean Account',
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
                    hintText: 'E-mail',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your e-mail!';
                    } else if (!emailRegExp.hasMatch(value)) {
                      return invalidEmailError;
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
                const Padding(padding: EdgeInsets.only(top: 16.0)),
                // TODO: {status && status !== 'fetching' && <h5 css={css`color: #ff6666`}>{status}</h5>}
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
                          handleRegister();
                        }
                      },
                      child: const Text('Register'),
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
