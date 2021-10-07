import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class AuthenticatedNavigatorBloc
    extends Bloc<AuthenticatedNavigatorEvent, AuthenticatedNavigatorState> {
  AuthenticatedNavigatorBloc()
      : super(const AuthenticatedNavigatorState.initial());

  Stream<AuthenticatedNavigatorState> mapEventToStateInternal(
      AuthenticatedNavigatorEvent event) async* {
    if (event is AuthenticatedNavigatorPopped) {
      final currState = state;
      final newState = (state.isNotificacionesSettingsFiltroBienesServicios ||
              state.isNotificacionesSettingsMonto ||
              state.isNotificacionesSettingsKeyword)
          ? const AuthenticatedNavigatorState(isNotificacionesSettings: true)
          : const AuthenticatedNavigatorState.initial();

      yield AuthenticatedNavigatorResult(
        previous: currState,
        state: newState,
      );
    } else if (event is NotificacionesSettingsViewPushed) {
      yield const AuthenticatedNavigatorState(isNotificacionesSettings: true);
    } else if (event is NotificacionesSettingsFiltroBienesServiciosViewPushed) {
      yield const AuthenticatedNavigatorState(
        isNotificacionesSettings: true,
        isNotificacionesSettingsFiltroBienesServicios: true,
      );
    } else if (event is NotificacionesSettingsMontoViewPushed) {
      yield const AuthenticatedNavigatorState(
        isNotificacionesSettings: true,
        isNotificacionesSettingsMonto: true,
      );
    } else if (event is NotificacionesSettingsKeywordViewPushed) {
      yield const AuthenticatedNavigatorState(
        isNotificacionesSettings: true,
        isNotificacionesSettingsKeyword: true,
      );
    } else if (event is EntityDetailsPushed) {
      yield AuthenticatedNavigatorState(
        isEntityDetails: true,
        entityDetailsId: event.id,
      );
    } else if (event is ProcessDetailsPushed) {
      yield AuthenticatedNavigatorState(
        isProcessDetails: true,
        processDetailsId: event.id,
      );
    } else if (event is UserInformationPushed) {
      yield const AuthenticatedNavigatorState(isUserInformation: true);
    }
  }

  @override
  Stream<AuthenticatedNavigatorState> mapEventToState(
      AuthenticatedNavigatorEvent event) async* {
    // var prevState = state;
    yield* mapEventToStateInternal(
            event) /*.map((state) {
      state = AuthenticatedNavigatorState(
        history: state.history.followedBy([prevState]).toList(),
        isNotificacionesSettings: state.isNotificacionesSettings,
        isNotificacionesSettingsFiltroBienesServicios:
            state.isNotificacionesSettingsFiltroBienesServicios,
        isNotificacionesSettingsKeyword: state.isNotificacionesSettingsKeyword,
        isNotificacionesSettingsMonto: state.isNotificacionesSettingsMonto,
      );
      prevState = state;
      return state;
    })*/
        ;
  }
}

abstract class AuthenticatedNavigatorEvent extends Equatable {
  const AuthenticatedNavigatorEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticatedNavigatorPopped extends AuthenticatedNavigatorEvent {
  const AuthenticatedNavigatorPopped({
    this.result,
  });

  final dynamic result;

  @override
  List<Object?> get props => [...super.props, result];
}

class NotificacionesSettingsViewPushed extends AuthenticatedNavigatorEvent {
  const NotificacionesSettingsViewPushed();
}

class NotificacionesSettingsFiltroBienesServiciosViewPushed
    extends AuthenticatedNavigatorEvent {
  const NotificacionesSettingsFiltroBienesServiciosViewPushed();
}

class NotificacionesSettingsMontoViewPushed
    extends AuthenticatedNavigatorEvent {
  const NotificacionesSettingsMontoViewPushed();
}

class NotificacionesSettingsKeywordViewPushed
    extends AuthenticatedNavigatorEvent {
  const NotificacionesSettingsKeywordViewPushed();
}

class EntityDetailsPushed extends AuthenticatedNavigatorEvent {
  const EntityDetailsPushed({
    required this.id,
  });

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
}

class ProcessDetailsPushed extends AuthenticatedNavigatorEvent {
  const ProcessDetailsPushed({
    required this.id,
  });

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
}

class UserInformationPushed extends AuthenticatedNavigatorEvent {
  const UserInformationPushed();
}

class AuthenticatedNavigatorState extends Equatable {
  const AuthenticatedNavigatorState({
    this.isNotificacionesSettings = false,
    this.isNotificacionesSettingsFiltroBienesServicios = false,
    this.isNotificacionesSettingsMonto = false,
    this.isNotificacionesSettingsKeyword = false,
    this.history = const [],
    this.isEntityDetails = false,
    this.entityDetailsId = 0,
    this.isProcessDetails = false,
    this.processDetailsId = 0,
    this.isUserInformation = false,
  });

  const AuthenticatedNavigatorState.initial()
      : isNotificacionesSettings = false,
        isNotificacionesSettingsFiltroBienesServicios = false,
        isNotificacionesSettingsMonto = false,
        isNotificacionesSettingsKeyword = false,
        history = const [],
        isEntityDetails = false,
        entityDetailsId = 0,
        isProcessDetails = false,
        processDetailsId = 0,
        isUserInformation = false;

  final bool isNotificacionesSettings;
  final bool isNotificacionesSettingsFiltroBienesServicios;
  final bool isNotificacionesSettingsMonto;
  final bool isNotificacionesSettingsKeyword;
  final List<AuthenticatedNavigatorState> history;

  final bool isEntityDetails;
  final int entityDetailsId;

  final bool isProcessDetails;
  final int processDetailsId;

  final bool isUserInformation;

  @override
  List<Object?> get props => [
        isNotificacionesSettings,
        isNotificacionesSettingsFiltroBienesServicios,
        isNotificacionesSettingsMonto,
        isNotificacionesSettingsKeyword,
        history,
        isEntityDetails,
        entityDetailsId,
        isProcessDetails,
        processDetailsId,
        isUserInformation,
      ];
}

class AuthenticatedNavigatorResult extends AuthenticatedNavigatorState {
  AuthenticatedNavigatorResult({
    required this.previous,
    required AuthenticatedNavigatorState state,
  }) : super(
          isNotificacionesSettings: state.isNotificacionesSettings,
          isNotificacionesSettingsFiltroBienesServicios:
              state.isNotificacionesSettingsFiltroBienesServicios,
          isNotificacionesSettingsKeyword:
              state.isNotificacionesSettingsKeyword,
          isNotificacionesSettingsMonto: state.isNotificacionesSettingsMonto,
        );

  final AuthenticatedNavigatorState previous;
}
