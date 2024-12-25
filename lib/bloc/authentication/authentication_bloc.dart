// import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosmart/bloc/authentication/authentication_event.dart';
import 'package:geosmart/bloc/authentication/authentication_state.dart';
import 'package:geosmart/service/setting_service.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Dio dio;

  AuthenticationBloc({
    required this.dio,
  }) : super(AuthenticationInitial()) {
    on<AuthenticationStarted>((event, emit) async {
      emit(AuthenticationProgress());
      final s = await SettingService().getSetting();
      if (s.isValid()) {
        emit(AuthenticationSuccess());
      } else {
        emit(AuthenticationFailed());
      }
    });

    on<AuthenticationClear>(
      (event, emit) async {
        await SettingService().clearSetting();
        emit(AuthenticationFailed());
      },
    );
  }
}
