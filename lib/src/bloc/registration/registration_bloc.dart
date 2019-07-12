import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../event.dart';
import '../state.dart';
import '../../client/auth_api.dart';
import '../../security/password.dart';


class RegBloc extends Bloc<BlocEvent, BlocState> {

  final Map<String, String> _reqValue = new Map();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _verificationId;

  @override
  BlocState get initialState => InitState();


  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {

    if (event is Confirm){

      if (_confirmValidate(event.code)){

        yield NotValidValue();

      } else {

        yield ValidValue();

        yield _showProgressWithTimeout(60);
        _signInWithPhoneNumber()
            .then((String credential){
              _reqValue['credential'] = credential;

              print(" Request : ${json.encode(_reqValue)}");

        }).catchError((e) => this.dispatch(Error(error: e.toString())));
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
        _verifyPhoneNumber(event.phone.replaceAll(new RegExp(r'\D'), ''));
      }
    }

    if (event is Cancel){
      yield SwitchView(view: 'Front');
    }

    if (event is VerificationCompleted){  yield ShowProgress(state: false);}

    if (event is TimeoutExcided){

      if (event.error.length > 0) {
        yield Failure(error: 'Timeout excided.', progress: false);
      } else {
        yield ShowProgress(state: false);
      }
    }
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

    final String _password =  password.replaceAll(new RegExp(r'\D'), '');
    _reqValue['password'] = pwd.encodePasswordPassword(_password);
    return _password.length != 5;
  }

  bool _confirmValidate(String code){
    _reqValue['code'] = code.replaceAll(new RegExp(r'\D'), '');
    return _reqValue['code'].length != 6;
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
      _verificationId = verificationId;
      print("Verification ID : $verificationId");
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
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

  Future<String> _signInWithPhoneNumber() async {

    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _reqValue['code'],
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    return await user.getIdToken(refresh: true);
  }

  BlocState _showProgressWithTimeout(final _timeout){

    Future.delayed(Duration(seconds: _timeout), (){
      if (this.currentState.progress) {
        this.dispatch(TimeoutExcided());
      }
    });
    return ShowProgress(state: true);
  }
}