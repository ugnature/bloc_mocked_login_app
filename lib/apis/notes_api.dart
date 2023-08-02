import 'package:flutter/foundation.dart' show immutable;
import 'package:notes_bloc_statemanage/models.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

class NotesApi extends NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => loginHandle == const LoginHandle.foobar() ? mockNotes : null,
    );
  }
}
