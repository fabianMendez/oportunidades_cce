import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/notificacion_repository.dart';

class NotificacionListadoBloc
    extends Bloc<NotificacionListadoEvent, NotificacionListadoState> {
  NotificacionListadoBloc({
    required this.userDetails,
    required this.notificacionRepository,
  }) : super(const NotificacionListadoUninitialized());

  final UserDetails userDetails;
  final NotificacionRepository notificacionRepository;

  @override
  Stream<NotificacionListadoState> mapEventToState(
      NotificacionListadoEvent event) async* {
    if (event is NotificacionListadoStarted) {
      try {
        final notificaciones = await notificacionRepository.getNotificaciones(
          codigo: userDetails.codigo,
          tipoNotificacion: 'Todos',
        );

        yield NotificacionListadoSuccess(notificaciones);
      } catch (err, str) {
        print(err);
        print(str);

        yield NotificacionListadoFailure(err.toString());
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

abstract class NotificacionListadoState extends Equatable {
  const NotificacionListadoState();

  @override
  List<Object?> get props => [];
}

class NotificacionListadoUninitialized extends NotificacionListadoState {
  const NotificacionListadoUninitialized();
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
