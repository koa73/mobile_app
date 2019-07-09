import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class RegState extends Equatable {
  final bool progress = false;
  RegState([List props = const []]) : super(props);
}

class InitState extends RegState {
}

class Success extends RegState {
}


class Progress extends RegState {
}

class SwitchView extends RegState {
  final String view;

  SwitchView({@required this.view})
      : super([view]);
}

class ValidationError extends RegState {
  Map<String, bool> error;

  ValidationError({@required this.error}) :
        super([error]);

}

class NotValidValue extends RegState {}
class ValidValue extends RegState {}

class ShowProgress extends  RegState {

  final bool state;

  ShowProgress({@required this.state}): super([state]);

  @override
  bool get progress => state;
}

class Failure extends RegState {
  final String error;
  final int length;
  final bool progress;

  Failure({@required this.error, this.length = 0, this.progress = false})
      : super([error, length, progress]);

  @override
  String toString() => 'Failure { error: $error }';
}


