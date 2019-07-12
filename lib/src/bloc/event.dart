import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class BlocEvent extends Equatable {
  BlocEvent([List props = const []]) : super(props);
}

class ClearError extends BlocEvent{}

class Complete extends BlocEvent{}

class Error extends BlocEvent {
  final String error;
  Error({@required this.error}) : super([error]);
}

class TimeoutExcided extends BlocEvent {
}

// Login page event

class KeyPushed extends BlocEvent {
  final String key;
  KeyPushed({@required this.key}) : super([key]);
}


// Registration page event

class Verify extends BlocEvent {
  final String email;
  final String phone;
  final String password;

  Verify ({@required this.email, @required this.phone, this.password}) :
        super([email, phone, password]);
}

class Confirm extends BlocEvent {
  final String code;
  Confirm ({@required this.code}) :
        super([code]);
}

class Cancel extends BlocEvent {
}

class VerificationCompleted extends BlocEvent {
}

class UserRegistered extends BlocEvent {
}

