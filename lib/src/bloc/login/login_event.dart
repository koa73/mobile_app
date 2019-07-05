import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class KeyPushed extends LoginEvent {
  final String key;
  KeyPushed({@required this.key}) : super([key]);
}

class LoggedIn extends LoginEvent {
}

class AuthError extends LoginEvent {
  final String error;
  AuthError({@required this.error}) : super([error]);
}

class Init extends LoginEvent {
}

class Progress extends LoginEvent {
}
