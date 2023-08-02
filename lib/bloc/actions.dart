import 'package:flutter/foundation.dart' show immutable;

// Action in other words are called as input or events
@immutable
abstract class AppAction {
  const AppAction();
}

@immutable
class LoginAction implements AppAction {
  final String email;
  final String password;

  const LoginAction({required this.email, required this.password});
}

@immutable
class LoadNotesAction implements AppAction {
  const LoadNotesAction();
}
