import 'package:flutter/foundation.dart';

bool isMobile() {
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.fuchsia;
}

var usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{4,}$');
const invalidUsernameError =
    'Username must be at least 4 letters/numbers (may have _).';

var passwordRegExp = RegExp(r'^.{8,}$');
const invalidPasswordError = 'Password must be at least 8 letters long!';

const passwordsDoNotMatch = 'Passwords don\'t match!';

var emailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
const invalidEmailError = 'Invalid e-mail entered!';
