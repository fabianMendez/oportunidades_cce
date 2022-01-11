import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';

class NotificacionesSettingsKeywordBloc extends Bloc<
    NotificacionesSettingsKeywordEvent, NotificacionesSettingsKeywordState> {
  NotificacionesSettingsKeywordBloc({
    required this.userDetails,
    required this.grupoUNSPSCRepository,
  }) : super(const NotificacionesSettingsKeywordInitial()) {
    on<NotificacionesSettingsKeywordSubmitted>((event, emit) async {
      emit(const NotificacionesSettingsKeywordLoading());

      final texto = event.texto.trim();
      if (texto.isEmpty) {
        emit(const NotificacionesSettingsKeywordFailure(
            'El texto es requerido'));
        return;
      }

      try {
        emit(const NotificacionesSettingsKeywordLoading());
        final response = await grupoUNSPSCRepository.insertarTextoContratacion(
          codigo: userDetails.codigo,
          texto: texto,
        );

        if (response.successful) {
          emit(const NotificacionesSettingsKeywordSuccess());
        } else {
          emit(NotificacionesSettingsKeywordFailure(response.message));
        }
      } catch (err, str) {
        print(err);
        print(str);
        emit(NotificacionesSettingsKeywordFailure(err.toString()));
      }
    });
  }

  final UserDetails userDetails;
  final GrupoUNSPSCRepository grupoUNSPSCRepository;
}

abstract class NotificacionesSettingsKeywordEvent extends Equatable {
  const NotificacionesSettingsKeywordEvent();

  @override
  List<Object?> get props => [];
}

class NotificacionesSettingsKeywordSubmitted
    extends NotificacionesSettingsKeywordEvent {
  const NotificacionesSettingsKeywordSubmitted({
    required this.texto,
  });

  final String texto;

  @override
  List<Object> get props => <Object>[texto];
}

class NotificacionesSettingsKeywordStarted
    extends NotificacionesSettingsKeywordEvent {
  const NotificacionesSettingsKeywordStarted();
}

class NotificacionesSettingsKeywordGrupoChanged
    extends NotificacionesSettingsKeywordEvent {
  const NotificacionesSettingsKeywordGrupoChanged({
    required this.grupo,
  });

  final int grupo;

  @override
  List<Object?> get props => [...super.props, grupo];
}

class NotificacionesSettingsKeywordTermChanged
    extends NotificacionesSettingsKeywordEvent {
  const NotificacionesSettingsKeywordTermChanged({
    required this.term,
  });

  final String term;

  @override
  List<Object?> get props => [...super.props, term];
}

class NotificacionesSettingsFamiliaSeleccionada
    extends NotificacionesSettingsKeywordEvent {
  const NotificacionesSettingsFamiliaSeleccionada({required this.id});

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
}

abstract class NotificacionesSettingsKeywordState extends Equatable {
  const NotificacionesSettingsKeywordState();

  @override
  List<Object?> get props => [];
}

class NotificacionesSettingsKeywordInitial
    extends NotificacionesSettingsKeywordState {
  const NotificacionesSettingsKeywordInitial();
}

class NotificacionesSettingsKeywordLoading
    extends NotificacionesSettingsKeywordState {
  const NotificacionesSettingsKeywordLoading();
}

class NotificacionesSettingsKeywordSuccess
    extends NotificacionesSettingsKeywordState {
  const NotificacionesSettingsKeywordSuccess();
}

class NotificacionesSettingsKeywordFailure
    extends NotificacionesSettingsKeywordState {
  const NotificacionesSettingsKeywordFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
