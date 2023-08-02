import 'package:bloc/bloc.dart';
import 'package:notes_bloc_statemanage/apis/login_api.dart';
import 'package:notes_bloc_statemanage/apis/notes_api.dart';
import 'package:notes_bloc_statemanage/bloc/actions.dart';
import 'package:notes_bloc_statemanage/bloc/app_state.dart';
import 'package:notes_bloc_statemanage/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({required this.loginApi, required this.notesApi})
      : super(const AppState.initialState()) {
    on<LoginAction>((loginAction, emit) async {
      // Loading State- start Loading
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );
      // Logged In State
      final loginHandle = await loginApi.login(
        email: loginAction.email,
        password: loginAction.password,
      );
      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });
    // showing the notes state
    on<LoadNotesAction>(
      (loadNotesAction, emit) async {
        emit(
          AppState(
            isLoading: true,
            loginError: null,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );
        // get the login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != const LoginHandle(token: 'foobar')) {
          // invailid loginhandle can't catch the notes
          emit(
            AppState(
              isLoading: false,
              loginError: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }
        // now after crosschecking now we are allowing to catch the notes
        final notes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      },
    );
  }
}
