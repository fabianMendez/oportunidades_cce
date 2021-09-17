import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';

class NotificacionesSettingsMontoBloc extends Bloc<
    NotificacionesSettingsMontoEvent, NotificacionesSettingsMontoState> {
  NotificacionesSettingsMontoBloc({
    required this.userDetails,
    required this.grupoUNSPSCRepository,
  }) : super(const NotificacionesSettingsMontoInitial());

  final UserDetails userDetails;
  final GrupoUNSPSCRepository grupoUNSPSCRepository;

  @override
  Stream<NotificacionesSettingsMontoState> mapEventToState(
      NotificacionesSettingsMontoEvent event) async* {
    if (event is NotificacionesSettingsMontoSubmitted) {
      yield const NotificacionesSettingsMontoLoading();

      if (event.montoInferior.trim().isEmpty) {
        yield const NotificacionesSettingsMontoFailure(
            'El monto inferior es requerido');
        return;
      }

      final montoInferiorValue = double.tryParse(event.montoInferior.trim());
      if (montoInferiorValue == null || montoInferiorValue < 0) {
        yield const NotificacionesSettingsMontoFailure(
            'El monto inferior no es válido');
        return;
      }
      if (event.montoSuperior.trim().isEmpty) {
        yield const NotificacionesSettingsMontoFailure(
            'El monto superior es requerido');
        return;
      }

      final montoSuperiorValue = double.tryParse(event.montoSuperior.trim());
      if (montoSuperiorValue == null ||
          montoSuperiorValue <= montoInferiorValue) {
        yield const NotificacionesSettingsMontoFailure(
            'El monto superior no es válido');
        return;
      }
      try {
        yield const NotificacionesSettingsMontoLoading();
        final response =
            await grupoUNSPSCRepository.insertarMontosConfiguracion(
          codigo: userDetails.codigo,
          montoInferior: montoInferiorValue,
          montoSuperior: montoSuperiorValue,
        );

        if (response.successful) {
          yield const NotificacionesSettingsMontoSuccess();
        } else {
          yield NotificacionesSettingsMontoFailure(response.message);
        }
      } catch (err, str) {
        print(err);
        print(str);
        yield NotificacionesSettingsMontoFailure(err.toString());
      }
    }
  }
}

abstract class NotificacionesSettingsMontoEvent extends Equatable {
  const NotificacionesSettingsMontoEvent();

  @override
  List<Object?> get props => [];
}

class NotificacionesSettingsMontoSubmitted
    extends NotificacionesSettingsMontoEvent {
  const NotificacionesSettingsMontoSubmitted({
    required this.montoInferior,
    required this.montoSuperior,
  });

  final String montoInferior;
  final String montoSuperior;

  @override
  List<Object> get props => <Object>[montoInferior, montoSuperior];
}

class NotificacionesSettingsMontoStarted
    extends NotificacionesSettingsMontoEvent {
  const NotificacionesSettingsMontoStarted();
}

class NotificacionesSettingsMontoGrupoChanged
    extends NotificacionesSettingsMontoEvent {
  const NotificacionesSettingsMontoGrupoChanged({
    required this.grupo,
  });

  final int grupo;

  @override
  List<Object?> get props => [...super.props, grupo];
}

class NotificacionesSettingsMontoTermChanged
    extends NotificacionesSettingsMontoEvent {
  const NotificacionesSettingsMontoTermChanged({
    required this.term,
  });

  final String term;

  @override
  List<Object?> get props => [...super.props, term];
}

class NotificacionesSettingsFamiliaSeleccionada
    extends NotificacionesSettingsMontoEvent {
  const NotificacionesSettingsFamiliaSeleccionada({required this.id});

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
}

abstract class NotificacionesSettingsMontoState extends Equatable {
  const NotificacionesSettingsMontoState();

  @override
  List<Object?> get props => [];
}

class NotificacionesSettingsMontoInitial
    extends NotificacionesSettingsMontoState {
  const NotificacionesSettingsMontoInitial();
}

class NotificacionesSettingsMontoLoading
    extends NotificacionesSettingsMontoState {
  const NotificacionesSettingsMontoLoading();
}

class NotificacionesSettingsMontoSuccess
    extends NotificacionesSettingsMontoState {
  const NotificacionesSettingsMontoSuccess();
}

class NotificacionesSettingsMontoFailure
    extends NotificacionesSettingsMontoState {
  const NotificacionesSettingsMontoFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
