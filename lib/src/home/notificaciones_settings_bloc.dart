import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class NotificacionesSettingsBloc
    extends Bloc<NotificacionesSettingsEvent, NotificacionesSettingsState> {
  NotificacionesSettingsBloc()
      : super(const NotificacionesSettingsState.initial());

  @override
  Stream<NotificacionesSettingsState> mapEventToState(
      NotificacionesSettingsEvent event) async* {
    if (event is NotificacionesSettingsFilterChanged) {
      yield NotificacionesSettingsState(
        selectedFilter: event.selected,
      );
    }
  }
}

abstract class NotificacionesSettingsEvent extends Equatable {
  const NotificacionesSettingsEvent();

  @override
  List<Object?> get props => [];
}

class NotificacionesSettingsFiltro extends Equatable {
  const NotificacionesSettingsFiltro(
      {required this.value,
      required this.description,
      required this.actionMessage});

  final String value;
  final String description;
  final String actionMessage;

  @override
  List<Object?> get props => [value, description, actionMessage];
}

class NotificacionesSettingsFilterChanged extends NotificacionesSettingsEvent {
  const NotificacionesSettingsFilterChanged({
    required this.selected,
  });

  final NotificacionesSettingsFiltro selected;

  @override
  List<Object?> get props => [...super.props, selected];
}

const kFiltroBienesServicios = NotificacionesSettingsFiltro(
  value: 'bienesServicios',
  description: 'Bienes y servicios',
  actionMessage: 'Suscribirme a bienes y servicios',
);

const kFiltroValores = NotificacionesSettingsFiltro(
  value: 'valores',
  description: 'Valores',
  actionMessage: 'Insertar filtro por monto',
);

const kFiltroPalabrasClave = NotificacionesSettingsFiltro(
  value: 'palabrasClave',
  description: 'Palabras clave',
  actionMessage: 'Insertar filtro por texto clave',
);

class NotificacionesSettingsState extends Equatable {
  const NotificacionesSettingsState({
    required this.selectedFilter,
  });

  const NotificacionesSettingsState.initial()
      : selectedFilter = kFiltroBienesServicios;

  final List<NotificacionesSettingsFiltro> filters = const [
    kFiltroBienesServicios,
    kFiltroValores,
    kFiltroPalabrasClave,
  ];
  final NotificacionesSettingsFiltro selectedFilter;

  @override
  List<Object?> get props => [filters, selectedFilter];
}
