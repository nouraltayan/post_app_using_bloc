import 'package:meta/meta.dart';

@immutable
abstract class InternetEvent {}

class CheckConnection extends InternetEvent {}
