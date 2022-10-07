import 'package:flutter/foundation.dart';

bool isMobile() {
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.fuchsia;
}

var usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{4,16}$');
const badLengthUsernameError =
    'Usernames must be between 4 and 16 characters long.';
const invalidUsernameError =
    'Usernames must have letters, numbers or underscores (_).';

var passwordRegExp = RegExp(r'^.{8,}$');
const invalidPasswordError = 'Password must be at least 8 letters long!';

const passwordsDoNotMatch = 'Passwords don\'t match!';

var emailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
const invalidEmailError = 'Invalid e-mail entered!';
const badLengthEmailError = 'An e-mail cannot be longer than 64 characters.';
