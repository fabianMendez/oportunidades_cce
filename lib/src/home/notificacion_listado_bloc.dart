import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/api_client.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/notificacion_repository.dart';

class NotificacionListadoBloc
    extends Bloc<NotificacionListadoEvent, NotificacionListadoState> {
  NotificacionListadoBloc({
    required this.userDetails,
    required this.notificacionRepository,
  }) : super(const NotificacionListadoUninitialized()) {
    on<NotificacionListadoStarted>((_, emit) => _load(emit));
    on<NotificacionListadoRefreshed>((_, emit) => _load(emit));
  }

  final UserDetails userDetails;
  final NotificacionRepository notificacionRepository;

  Future<void> _load(Emitter<NotificacionListadoState> emit) async {
    try {
      emit(const NotificacionListadoLoading());

      final notificaciones = await notificacionRepository.getNotificaciones(
        codigo: userDetails.codigo,
        // tipoNotificacion: 'Todos',
        // tipoNotificacion: 'CreacionProceso',
        // tipoNotificacion: 'CreacionProcesoEntidad',
        tipoNotificacion: 'ActualizacionProceso',
      );

      emit(NotificacionListadoSuccess(notificaciones));
    } catch (err, str) {
      print(err);
      print(str);

      if (err is APIException) {
        emit(NotificacionListadoFailure(err.message));
      } else {
        emit(NotificacionListadoFailure(err.toString()));
      }
    }
  }
}

abstract class NotificacionListadoEvent extends Equatable {
  const NotificacionListadoEvent();

  @override
  List<Object?> get props => [];
}

class NotificacionListadoStarted extends NotificacionListadoEvent {
  const NotificacionListadoStarted();
}

class NotificacionListadoRefreshed extends NotificacionListadoEvent {
  const NotificacionListadoRefreshed();
}

abstract class NotificacionListadoState extends Equatable {
  const NotificacionListadoState();

  @override
  List<Object?> get props => [];
}

class NotificacionListadoUninitialized extends NotificacionListadoState {
  const NotificacionListadoUninitialized();
}

class NotificacionListadoLoading extends NotificacionListadoState {
  const NotificacionListadoLoading();
}

class NotificacionListadoFailure extends NotificacionListadoState {
  const NotificacionListadoFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}

class NotificacionListadoSuccess extends NotificacionListadoState {
  const NotificacionListadoSuccess(this.notificaciones);

  final List<Notificacion> notificaciones;

  @override
  List<Object?> get props => [...super.props, notificaciones];
}
