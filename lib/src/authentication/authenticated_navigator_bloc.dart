import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class AuthenticatedNavigatorBloc
    extends Bloc<AuthenticatedNavigatorEvent, AuthenticatedNavigatorState> {
  AuthenticatedNavigatorBloc()
      : super(const AuthenticatedNavigatorState.initial()) {
    on<AuthenticatedNavigatorPopped>((event, emit) {
      final currState = state;
      final toEntityDetails =
          currState.isProcessDetails && currState.isEntityDetails;

      final newState = (state.isNotificacionesSettingsFiltroBienesServicios ||
              state.isNotificacionesSettingsMonto ||
              state.isNotificacionesSettingsKeyword)
          ? const AuthenticatedNavigatorState(isNotificacionesSettings: true)
          : toEntityDetails
              ? AuthenticatedNavigatorState(
                  isEntityDetails: true,
                  entityDetailsId: state.entityDetailsId,
                )
              : const AuthenticatedNavigatorState.initial();

      emit(AuthenticatedNavigatorResult(
        previous: currState,
        state: newState,
      ));
    });

    on<NotificacionesSettingsViewPushed>((event, emit) {
      emit(const AuthenticatedNavigatorState(isNotificacionesSettings: true));
    });

    on<NotificacionesSettingsFiltroBienesServiciosViewPushed>((event, emit) {
      emit(const AuthenticatedNavigatorState(
        isNotificacionesSettings: true,
        isNotificacionesSettingsFiltroBienesServicios: true,
      ));
    });

    on<NotificacionesSettingsMontoViewPushed>((event, emit) {
      emit(const AuthenticatedNavigatorState(
        isNotificacionesSettings: true,
        isNotificacionesSettingsMonto: true,
      ));
    });

    on<NotificacionesSettingsKeywordViewPushed>((event, emit) {
      emit(const AuthenticatedNavigatorState(
        isNotificacionesSettings: true,
        isNotificacionesSettingsKeyword: true,
      ));
    });

    on<EntityDetailsPushed>((event, emit) {
      emit(AuthenticatedNavigatorState(
        isEntityDetails: true,
        entityDetailsId: event.id,
      ));
    });
    on<ProcessDetailsPushed>((event, emit) {
      emit(AuthenticatedNavigatorState(
        isProcessDetails: true,
        processDetailsId: event.id,
        isEntityDetails: state.isEntityDetails,
        entityDetailsId: state.entityDetailsId,
      ));
    });

    on<UserInformationPushed>((event, emit) {
      emit(const AuthenticatedNavigatorState(isUserInformation: true));
    });
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
          entityDetailsId: state.entityDetailsId,
          history: state.history,
          isEntityDetails: state.isEntityDetails,
          isProcessDetails: state.isProcessDetails,
          isUserInformation: state.isUserInformation,
          processDetailsId: state.processDetailsId,
        );

  final AuthenticatedNavigatorState previous;
}
