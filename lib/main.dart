import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes_bloc_statemanage/apis/login_api.dart';
import 'package:notes_bloc_statemanage/apis/notes_api.dart';
import 'package:notes_bloc_statemanage/bloc/actions.dart';
import 'package:notes_bloc_statemanage/bloc/app_bloc.dart';
import 'package:notes_bloc_statemanage/bloc/app_state.dart';
import 'package:notes_bloc_statemanage/dialogs/generic_dialog.dart';
import 'package:notes_bloc_statemanage/dialogs/loading_screen.dart';
import 'package:notes_bloc_statemanage/models.dart';
import 'package:notes_bloc_statemanage/strings.dart';
import 'package:notes_bloc_statemanage/views/iterable_list_view.dart';
import 'package:notes_bloc_statemanage/views/login_view.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: homePage),
    ),
  );
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        backgroundColor: Colors.white54,
        appBar: AppBar(
          toolbarHeight: 30,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // Loading Screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // Display possible errors
            final loginErrors = appState.loginError;
            if (loginErrors != null) {
              showGenericDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () {
                  return {ok: true};
                },
              );
            }
            // if we are logged in and didn't fetch the notes than fetch now.
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.foobar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
