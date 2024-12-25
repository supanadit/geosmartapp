import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosmart/bloc/authentication/authentication.dart';
import 'package:geosmart/bloc/setting/setting_event.dart';
import 'package:geosmart/bloc/setting/setting_state.dart';
import 'package:geosmart/model/setting.dart';
import 'package:geosmart/service/setting_service.dart';
import 'package:geosmart/service/unique_id_service.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final AuthenticationBloc authenticationBloc;

  SettingBloc({required this.authenticationBloc}) : super(SettingInitial()) {
    on<SettingSet>((event, emit) async {
      emit(SettingProgress());
      if (event.host != null && event.host != "") {
        try {
          final s = await UniqueIDService().getUniqueID(
            event.host,
            authenticationBloc.dio,
          );
          SettingService().setSetting(SettingModel(
            event.host,
            s.id,
          ));
          emit(SettingSuccess());
        } catch (_) {
          emit(SettingFailed(
            message: "Make sure your host is correct and alive.",
          ));
        }
      } else {
        emit(SettingFailed(message: "Host cannot null or empty."));
      }
    });
  }
}
