import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';

class NotificacionesSettingsBloc
    extends Bloc<NotificacionesSettingsEvent, NotificacionesSettingsState> {
  NotificacionesSettingsBloc({
    required this.userDetails,
    required this.grupoUNSPSCRepository,
  }) : super(const NotificacionesSettingsState.initial());

  final UserDetails userDetails;
  final GrupoUNSPSCRepository grupoUNSPSCRepository;

  Stream<NotificacionesSettingsState> _loadSavedSettings(
      NotificacionesSettingsFiltro selectedFilter) async* {
    try {
      yield NotificacionesSettingsLoading(selectedFilter: selectedFilter);

      final valueNotificationSettings =
          await grupoUNSPSCRepository.getMontosConfiguracion(
        codigo: userDetails.codigo,
      );

      yield NotificacionesSettingsReady(
        selectedFilter: selectedFilter,
        valueNotificationSettings: valueNotificationSettings,
      );
    } catch (err, str) {
      print(err);
      print(str);
      yield NotificacionesSettingsFailure(
        err.toString(),
        selectedFilter: selectedFilter,
      );
    }
  }

  @override
  Stream<NotificacionesSettingsState> mapEventToState(
      NotificacionesSettingsEvent event) async* {
    if (event is NotificacionesSettingsStarted) {
      yield* _loadSavedSettings(state.selectedFilter);
    } else if (event is NotificacionesSettingsFilterChanged) {
      yield* _loadSavedSettings(event.selected);
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

class NotificacionesSettingsStarted extends NotificacionesSettingsEvent {
  const NotificacionesSettingsStarted();
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
    this.valueNotificationSettings = const [],
  });

  const NotificacionesSettingsState.initial()
      : selectedFilter = kFiltroBienesServicios,
        valueNotificationSettings = const [];

  final List<NotificacionesSettingsFiltro> filters = const [
    kFiltroBienesServicios,
    kFiltroValores,
    kFiltroPalabrasClave,
  ];

  final NotificacionesSettingsFiltro selectedFilter;
  final List<ValueNotificationSetting> valueNotificationSettings;

  @override
  List<Object?> get props =>
      [filters, selectedFilter, valueNotificationSettings];
}

class NotificacionesSettingsLoading extends NotificacionesSettingsState {
  const NotificacionesSettingsLoading({
    required NotificacionesSettingsFiltro selectedFilter,
  }) : super(
          selectedFilter: selectedFilter,
        );
}

class NotificacionesSettingsReady extends NotificacionesSettingsState {
  const NotificacionesSettingsReady({
    required NotificacionesSettingsFiltro selectedFilter,
    required List<ValueNotificationSetting> valueNotificationSettings,
  }) : super(
          selectedFilter: selectedFilter,
          valueNotificationSettings: valueNotificationSettings,
        );
}

class NotificacionesSettingsFailure extends NotificacionesSettingsState {
  const NotificacionesSettingsFailure(
    this.error, {
    required NotificacionesSettingsFiltro selectedFilter,
  }) : super(
          selectedFilter: selectedFilter,
        );

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
