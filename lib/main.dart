import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bloc/bloc.dart';

import 'src/pages/login.dart';
import 'src/bloc/state.dart';
import 'src/pages/restore_access.dart';


class SimpleBlocDelegate extends BlocDelegate{
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print("Event: $event");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print("Transition : $transition");
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {

    super.onError(bloc, error, stacktrace);
    print("Error in bloc : $error");
    bloc.dispatch(Failure(error: error));
  }
}


void main() {

  BlocSupervisor().delegate = SimpleBlocDelegate();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Smart shopper',
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        cursorColor: Colors.grey[500],
      ),
      initialRoute: '/',
      routes: {
        '/':(BuildContext context) => LoginPage(),
        '/restore':(BuildContext context) => RestorePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


