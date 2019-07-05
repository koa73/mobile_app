import 'dart:async';
import 'package:bloc/bloc.dart';

import 'registration_event.dart';
import 'registration_state.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegBloc extends Bloc<RegEvent, RegState> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  RegState get initialState => InitState();


  @override
  Stream<RegState> mapEventToState(RegEvent event) async* {

    if (event is Confirm){
      if (_confirmValidate(event.code)){
        yield NotValidValue();
      } else { yield Success();}
    }

    if (event is Verify){
      Map<String, bool> error = new Map();
      error['email'] = _emailValidate(event.email);
      error['phone'] = _phoneValidate(event.phone);
      error['password'] = _passwordValidate(event.password);

      if (error.containsValue(true)) {

        yield ValidationError(error: error);

      } else {
        yield ShowProgress(state: true);
        _verifyPhoneNumber(event.phone.replaceAll(new RegExp(r'\D'), ''));
      }
    }

    if (event is Cancel){
      yield SwitchView(view: 'Front');
    }

    if (event is VerificationCompleted){
      yield SwitchView(view: 'Back');
    }
  }

  bool _emailValidate(String email){
    final RegExp exp = new RegExp(r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$');
    return !exp.hasMatch(email);
  }

  bool _phoneValidate(String phone){
    return phone.replaceAll(new RegExp(r'\D'), '').length != 11;

  }

  bool _passwordValidate(String password){
    return password.replaceAll(new RegExp(r'\D'), '').length != 5;
  }

  bool _confirmValidate(String code){
    return code.replaceAll(new RegExp(r'\D'), '').length != 5;
  }

  _verifyPhoneNumber(String phoneNumber) async {

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      this.dispatch(VerificationCompleted());
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
}