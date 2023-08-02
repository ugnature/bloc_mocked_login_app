import 'package:flutter/foundation.dart' show immutable;
import 'package:notes_bloc_statemanage/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  @override
  String toString() => {
        'isLoading': isLoading,
        'Login Error': loginError,
        'Login Handle': loginHandle,
        'Fetched Notes': fetchedNotes,
      }.toString();

  // Initial App State
  const AppState.initialState()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;
}
