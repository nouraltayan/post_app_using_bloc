import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'internet_event.dart';
import 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  InternetBloc() : super(InternetInitial()) {
    on<CheckConnection>((event, emit) async {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        emit(Connected(message: "Connected"));
      } else {
        emit(NotConnected(message: "Not Connected"));
      }
    });

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((connectivityResults) {
      add(CheckConnection());
    });

    // Initial connectivity check
    add(CheckConnection());
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
