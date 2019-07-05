import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RegEvent extends Equatable {
  RegEvent([List props = const []]) : super(props);
}

class Verify extends RegEvent {
  final String email;
  final String phone;
  final String password;

  Verify ({@required this.email, @required this.phone, this.password}) :
        super([email, phone, password]);
}

class Confirm extends RegEvent {
  final String code;
  Confirm ({@required this.code}) :
        super([code]);
}

class Cancel extends RegEvent {
}

class VerificationCompleted extends RegEvent {
}

class UserRegistered extends RegEvent {
}

class TimeoutExcided extends RegEvent {
}