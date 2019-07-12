import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/virtual_keyboard.dart';
import '../widgets/targets.dart';
import '../widgets/background.dart';
import '../widgets/progress.dart';
import '../pages/home.dart';
import '../pages/registration.dart';
import '../bloc/login/login.dart';
import '../globals.dart' as global;

class LoginPage extends StatefulWidget {

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  LoginBloc _bloc;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:  BlocBuilder<BlocEvent, BlocState>(
          bloc: _bloc,
          builder: (BuildContext context, BlocState state) {

            if (state is Success){

              return HomePage();

            } else if (state is UnRegistered){

              return RegistrationPage();

            } else {

              if (state is Failure){
                WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text("Login error"),
                      content: new Text(state.error),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            _bloc.dispatch(Init());
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                ));
              }

              return ProgressView(
                child:  Scaffold(
                  body: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: global.systemStyle,
                      child: BackGround(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                  //color: Colors.blue,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: new CountTarget(
                                            count: (state is UnAuthorised)?state.length:5,
                                            child: Targets(
                                                color: global.highlightColor2
                                            ),
                                          ),
                                        ),
                                        Text('Enter your secret code', style: TextStyle(color: global.foregroundColor),),
                                      ],
                                    )
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  // Keyboard is transparent
                                  //color: Colors.blue,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 30, right: 30, top: 10),
                                      child: VirtualKeyboard(
                                          type: VirtualKeyboardType.Numeric,
                                          fontSize: 25,
                                          textColor: global.foregroundColor,
                                          backgroundColor: global.highlightColor2,
                                          // Callback for key press event
                                          onKeyPress: (key) => _bloc.dispatch(KeyPushed(key: key.text))),
                                    ),
                                    new MaterialButton(
                                        child: Text("Restore password", style: TextStyle(color: global.foregroundColor),),
                                        textTheme: ButtonTextTheme.normal,
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/restore');
                                        }
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                      ),
                  ),
                ),
                visibility: state.progress,
              );

            }
          },
        ),
    );
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    _bloc = LoginBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

