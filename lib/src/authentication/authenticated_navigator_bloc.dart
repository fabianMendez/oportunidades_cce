import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class AuthenticatedNavigatorBloc
    extends Bloc<AuthenticatedNavigatorEvent, AuthenticatedNavigatorState> {
  AuthenticatedNavigatorBloc()
      : super(const AuthenticatedNavigatorState.initial());

  @override
  Stream<AuthenticatedNavigatorState> mapEventToState(
      AuthenticatedNavigatorEvent event) async* {
    if (event is AuthenticatedNavigatorPopped) {
      if (state.isNotificacionesSettingsFiltroBienesServicios) {
        yield const AuthenticatedNavigatorState(isNotificacionesSettings: true);
      } else {
        yield const AuthenticatedNavigatorState.initial();
      }
    } else if (event is NotificacionesSettingsViewPushed) {
      yield const AuthenticatedNavigatorState(isNotificacionesSettings: true);
    } else if (event is NotificacionesSettingsFiltroBienesServiciosViewPushed) {
      yield const AuthenticatedNavigatorState(
        isNotificacionesSettings: true,
        isNotificacionesSettingsFiltroBienesServicios: true,
      );
    }
  }
}

abstract class AuthenticatedNavigatorEvent extends Equatable {
  const AuthenticatedNavigatorEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticatedNavigatorPopped extends AuthenticatedNavigatorEvent {
  const AuthenticatedNavigatorPopped();
}

class NotificacionesSettingsViewPushed extends AuthenticatedNavigatorEvent {
  const NotificacionesSettingsViewPushed();
}

class NotificacionesSettingsFiltroBienesServiciosViewPushed
    extends AuthenticatedNavigatorEvent {
  const NotificacionesSettingsFiltroBienesServiciosViewPushed();
}

class AuthenticatedNavigatorState extends Equatable {
  const AuthenticatedNavigatorState({
    this.isNotificacionesSettings = false,
    this.isNotificacionesSettingsFiltroBienesServicios = false,
  });

  const AuthenticatedNavigatorState.initial()
      : isNotificacionesSettings = false,
        isNotificacionesSettingsFiltroBienesServicios = false;

  final bool isNotificacionesSettings;
  final bool isNotificacionesSettingsFiltroBienesServicios;

  @override
  List<Object?> get props => [
        isNotificacionesSettings,
        isNotificacionesSettingsFiltroBienesServicios,
      ];
}
