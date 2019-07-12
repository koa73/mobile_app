import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class BlocState extends Equatable {
  final bool progress = false;
  BlocState([List props = const []]) : super(props);
}

class InitState extends BlocState {
}

class Success extends BlocState {
}

class ShowProgress extends  BlocState {

  final bool state;

  ShowProgress({@required this.state}): super([state]);

  @override
  bool get progress => state;
}

class Failure extends BlocState {
  final String error;
  final int length;
  final bool progress;

  Failure({@required this.error, this.length = 0, this.progress = false})
      : super([error, length, progress]);

  @override
  String toString() => 'Failure { error: $error }';
}

// Login page states

class UnRegistered extends BlocState {
}

class UnAuthorised extends BlocState {
  final int length;
  final bool progress;

  UnAuthorised({this.length=0, this.progress = false}) : super([length, progress ]);
}

// Registration page state

class SwitchView extends BlocState {
  final String view;

  SwitchView({@required this.view})
      : super([view]);
}

class ValidationError extends BlocState {
  Map<String, bool> error;

  ValidationError({@required this.error}) :
        super([error]);

}

class NotValidValue extends BlocState {}

class ValidValue extends BlocState {}




