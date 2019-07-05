import 'dart:async';
import 'package:bloc/bloc.dart';

import 'login_event.dart';
import 'login_state.dart';
import '../../client/auth_api.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {

  String _code = '';
  String _username = '';

  @override
  LoginState get initialState => (_username.length == 0 )?UnAuthorised()
      :UnRegistered();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {

    if (event is KeyPushed){

      if (_code.length < 5) {

        if (event.key == null){
          _code = _code.replaceFirst(new RegExp(r'.$'), '');
        } else {
          _code = _code + event.key;
        }
      }
      yield UnAuthorised(length: _code.length, progress: ( _code.length == 5));

      if (_code.length == 5){

        auth.getToken(password: _code)
            .then((String result)=> this.dispatch(LoggedIn()))
            .catchError((e) => this.dispatch(AuthError(error: e.toString())));

      }
    }

    if (event is AuthError){

      _code ='';
      yield Failure(error: event.error);

    }

    if (event is LoggedIn){

      yield Success();

    }

    if (event is Init){
      yield UnAuthorised(length: 0, progress: false);
    }

    if (event is Progress){
      yield UnAuthorised(length: 0, progress: true);
    }
  }
}