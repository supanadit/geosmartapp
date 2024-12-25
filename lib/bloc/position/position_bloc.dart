import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geosmart/bloc/authentication/authentication.dart';
import 'package:geosmart/bloc/position/position_event.dart';
import 'package:geosmart/bloc/position/position_state.dart';
import 'package:geosmart/service/position_service.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  final AuthenticationBloc authenticationBloc;

  PositionBloc({required this.authenticationBloc})
      : super(PositionTrackingIdle()) {
    on<PositionStartTracking>((event, emit) async {
      emit(PositionTrackingStarted());
    });

    on<PositionStopTracking>((event, emit) async {
      try {
        await PositionService(
          dio: authenticationBloc.dio,
        ).stopTracking();
        emit(PositionTrackingIdle());
      } catch (e) {
        emit(PositionTrackingFailed());
      }
    });

    on<PositionSend>((event, emit) async {
      try {
        PositionService(
          dio: authenticationBloc.dio,
        ).sendPosition(
          event.lat,
          event.lng,
        );
      } catch (_) {
        await PositionService(
          dio: authenticationBloc.dio,
        ).stopTracking();
        emit(PositionTrackingFailed());
      }
    });
  }
}
