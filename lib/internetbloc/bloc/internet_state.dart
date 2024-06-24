import 'package:meta/meta.dart';

@immutable
abstract class InternetState {}

class InternetInitial extends InternetState {}

class Connected extends InternetState {
  final String message;
  Connected({required this.message});
}

class NotConnected extends InternetState {
  final String message;
  NotConnected({required this.message});
}
