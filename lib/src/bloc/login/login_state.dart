import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  final int length = 0;
  final bool progress = false;
  LoginState([List props = const []]) : super(props);
}

class Success extends LoginState {
}

class Failure extends LoginState {
  final String error;
  final int length;
  final bool progress;

  Failure({@required this.error, this.length = 0, this.progress = false})
      : super([error, length, progress]);

  @override
  String toString() => 'Failure { error: $error }';
}


class UnAuthorised extends LoginState {
  final int length;
  final bool progress;

  UnAuthorised({this.length=0, this.progress = false}) : super([length, progress]);
}

class UnRegistered extends LoginState {
}




