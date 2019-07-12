import 'dart:async';
import 'package:bloc/bloc.dart';

import '../event.dart';
import '../state.dart';
import '../../client/auth_api.dart';


class LoginBloc extends Bloc<BlocEvent, BlocState> {

  String _code = '';
  String _username = '';

  @override
  BlocState get initialState => (_username.length == 0 )?UnAuthorised()
      :UnRegistered();

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {

    if (event is KeyPushed){

      if (_code.length < 5) {

        if (event.key == null){
          _code = _code.replaceFirst(new RegExp(r'.$'), '');
        } else {
          _code = _code + event.key;
        }
      }


      yield UnAuthorised(length: _code.length, progress: (_code.length == 5) );

      if (_code.length == 5){

        auth.getToken(password: _code)
            .then((String result)=> this.dispatch(Complete()))
            .catchError((e) => this.dispatch(Error(error: e.toString())));
      }
    }


    if (event is Complete){
      yield ShowProgress(state: false);
      yield Success();
    }

    if (event is Error){
      _code ='';
      yield Failure(error: event.error);
    }

    if (event is Init){
      yield UnAuthorised(length: 0, progress: false);
    }
  }
}