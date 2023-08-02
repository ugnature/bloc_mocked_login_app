import 'package:flutter/material.dart' show immutable;
import 'package:notes_bloc_statemanage/models.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({required String email, required String password});
}

@immutable
class LoginApi implements LoginApiProtocol {
  // This loginApi is going to be a singleton pattern-
  // const LoginApi._sharedInstance();
  // static const LoginApi _shared = LoginApi._sharedInstance();
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) {
    return Future.delayed(
      const Duration(seconds: 3),
      () => email == 'foo@bar.com' && password == 'foobar',
    ).then((isLoggedIn) => isLoggedIn ? const LoginHandle.foobar() : null);
  }
}
