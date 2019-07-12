import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';

import '../event.dart';
import '../state.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegBloc extends Bloc<BlocEvent, BlocState> {

  final Map<String, String> _reqValue = new Map();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  BlocState get initialState => InitState();


  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {

    if (event is Confirm){

      if (_confirmValidate(event.code)){

        yield NotValidValue();

      } else {

        yield ValidValue();
        print(" Request : ${json.encode(_reqValue)}");
        yield _showProgressWithTimeout(60);
      }

    } else if (event is Verify){

      Map<String, bool> error = new Map();
      error['email'] = _emailValidate(event.email);
      error['phone'] = _phoneValidate(event.phone);
      error['password'] = _passwordValidate(event.password);

      if (error.containsValue(true)) {

        yield ValidationError(error: error);

      } else {

        yield SwitchView(view: 'Back');
        yield _showProgressWithTimeout(4);
        //_verifyPhoneNumber(event.phone.replaceAll(new RegExp(r'\D'), ''));
      }
    }

    if (event is Cancel){
      yield SwitchView(view: 'Front');
    }

    if (event is VerificationCompleted){  yield ShowProgress(state: false);}

    if (event is TimeoutExcided){ yield ShowProgress(state: false);}
  }

  bool _emailValidate(String email){
    final RegExp exp = new RegExp(r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$');
    _reqValue['email'] = email;
    return !exp.hasMatch(email);
  }

  bool _phoneValidate(String phone){
    _reqValue['phone'] = phone.replaceAll(new RegExp(r'\D'), '');
    return _reqValue['phone'].length != 11;
  }

  bool _passwordValidate(String password){
    _reqValue['password'] = password.replaceAll(new RegExp(r'\D'), '');
    return _reqValue['password'].length != 5;
  }

  bool _confirmValidate(String code){
    _reqValue['code'] = code.replaceAll(new RegExp(r'\D'), '');
    return _reqValue['code'].length != 5;
  }

  _verifyPhoneNumber(String phoneNumber) async {

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      this.dispatch(VerificationCompleted());
      print('Received phone auth credential: $phoneAuthCredential');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      throw(
          'Phone number verification failed. Code: ${authException.code}. '
              'Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {

      print("Verification ID : $verificationId");
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("CodeAutoRetrievalTimeout : verificationId");
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: "+$phoneNumber",
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  BlocState _showProgressWithTimeout(final _timout){

    Future.delayed(Duration(seconds: _timout), (){
      if (this.currentState.progress) {
        this.dispatch(TimeoutExcided());
      }
    });
    return ShowProgress(state: true);
  }
}