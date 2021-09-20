import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';

class NotificacionesSettingsBloc
    extends Bloc<NotificacionesSettingsEvent, NotificacionesSettingsState> {
  NotificacionesSettingsBloc({
    required this.userDetails,
    required this.authenticatedNavigatorBloc,
    required this.grupoUNSPSCRepository,
  }) : super(const NotificacionesSettingsState.initial()) {
    authenticatedNavigatorSubscription = authenticatedNavigatorBloc.stream
        .listen(_authenticatedNavigatorListener);
  }

  final UserDetails userDetails;
  final AuthenticatedNavigatorBloc authenticatedNavigatorBloc;
  final GrupoUNSPSCRepository grupoUNSPSCRepository;

  late StreamSubscription<AuthenticatedNavigatorState>
      authenticatedNavigatorSubscription;

  @override
  Future<void> close() {
    authenticatedNavigatorSubscription.cancel();
    return super.close();
  }

  static bool _hasFinishedSelecting(
      AuthenticatedNavigatorState prev, AuthenticatedNavigatorState state) {
    return ((prev.isNotificacionesSettingsFiltroBienesServicios &&
            prev.isNotificacionesSettingsFiltroBienesServicios !=
                state.isNotificacionesSettingsFiltroBienesServicios) ||
        (prev.isNotificacionesSettingsKeyword &&
            prev.isNotificacionesSettingsKeyword !=
                state.isNotificacionesSettingsKeyword) ||
        (prev.isNotificacionesSettingsMonto &&
            prev.isNotificacionesSettingsMonto !=
                state.isNotificacionesSettingsMonto));
  }

  void _authenticatedNavigatorListener(AuthenticatedNavigatorState state) {
    if (state is AuthenticatedNavigatorResult &&
        _hasFinishedSelecting(state.previous, state)) {
      add(const NotificacionesSettingsUpdated());
    }
    // if (state.history.isNotEmpty && _hasFinishedSelecting(state.history.last, state)) {
    //   print('auth nav: $state');
    // }
  }

  Stream<NotificacionesSettingsState> _loadSavedSettingsFromCache(
    Map<NotificacionesSettingsFiltro, List<dynamic>> cache,
    NotificacionesSettingsFiltro selectedFilter,
  ) async* {
    if (cache.containsKey(selectedFilter)) {
      final List<ValueNotificationSetting> settings =
          cache[selectedFilter]! as List<ValueNotificationSetting>;

      yield NotificacionesSettingsReady(
        selectedFilter: selectedFilter,
        valueNotificationSettings: settings,
        cache: cache,
      );
    } else {
      yield* _loadSavedSettings(cache, selectedFilter);
    }
  }

  Stream<NotificacionesSettingsState> _loadSavedSettings(
    Map<NotificacionesSettingsFiltro, List<dynamic>> cache,
    NotificacionesSettingsFiltro selectedFilter,
  ) async* {
    try {
      yield NotificacionesSettingsLoading(selectedFilter: selectedFilter);

      final valueNotificationSettings =
          await grupoUNSPSCRepository.getMontosConfiguracion(
        codigo: userDetails.codigo,
      );

      final newCache =
          Map<NotificacionesSettingsFiltro, List<dynamic>>.from(cache)
            ..addAll({selectedFilter: valueNotificationSettings});

      yield NotificacionesSettingsReady(
        selectedFilter: selectedFilter,
        valueNotificationSettings: valueNotificationSettings,
        cache: newCache,
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
      yield* _loadSavedSettingsFromCache(
        state.notificationSettingsCache,
        state.selectedFilter,
      );
    } else if (event is NotificacionesSettingsFilterChanged) {
      yield* _loadSavedSettingsFromCache(
        state.notificationSettingsCache,
        event.selected,
      );
    } else if (event is NotificacionesSettingsUpdated) {
      yield* _loadSavedSettings(
        state.notificationSettingsCache,
        state.selectedFilter,
      );
    } else if (event is NotificacionesSettingsFilterPressed) {
      if (state.selectedFilter == kFiltroBienesServicios) {
        authenticatedNavigatorBloc
            .add(const NotificacionesSettingsFiltroBienesServiciosViewPushed());
      } else if (state.selectedFilter == kFiltroValores) {
        authenticatedNavigatorBloc
            .add(const NotificacionesSettingsMontoViewPushed());
      } else if (state.selectedFilter == kFiltroPalabrasClave) {
        authenticatedNavigatorBloc
            .add(const NotificacionesSettingsKeywordViewPushed());
      }

      yield NotificacionesSettingsSelecting(
        notificationSettingsCache: state.notificationSettingsCache,
        selectedFilter: state.selectedFilter,
        valueNotificationSettings: state.valueNotificationSettings,
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

class NotificacionesSettingsUpdated extends NotificacionesSettingsEvent {
  const NotificacionesSettingsUpdated();
}

class NotificacionesSettingsFilterPressed extends NotificacionesSettingsEvent {
  const NotificacionesSettingsFilterPressed();
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
    this.notificationSettingsCache = const {},
  });

  const NotificacionesSettingsState.initial()
      : selectedFilter = kFiltroBienesServicios,
        valueNotificationSettings = const [],
        notificationSettingsCache = const {};

  final List<NotificacionesSettingsFiltro> filters = const [
    kFiltroBienesServicios,
    kFiltroValores,
    kFiltroPalabrasClave,
  ];

  final NotificacionesSettingsFiltro selectedFilter;
  final List<ValueNotificationSetting> valueNotificationSettings;
  final Map<NotificacionesSettingsFiltro, List<dynamic>>
      notificationSettingsCache;

  @override
  List<Object?> get props => [
        filters,
        selectedFilter,
        valueNotificationSettings,
        notificationSettingsCache,
      ];
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
    required Map<NotificacionesSettingsFiltro, List<dynamic>> cache,
  }) : super(
          selectedFilter: selectedFilter,
          valueNotificationSettings: valueNotificationSettings,
          notificationSettingsCache: cache,
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

class NotificacionesSettingsSelecting extends NotificacionesSettingsState {
  const NotificacionesSettingsSelecting({
    required NotificacionesSettingsFiltro selectedFilter,
    required List<ValueNotificationSetting> valueNotificationSettings,
    required Map<NotificacionesSettingsFiltro, List<dynamic>>
        notificationSettingsCache,
  }) : super(
          selectedFilter: selectedFilter,
          notificationSettingsCache: notificationSettingsCache,
          valueNotificationSettings: valueNotificationSettings,
        );
}
