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
    on<NotificacionesSettingsStarted>((event, emit) async {
      await _loadSavedSettingsFromCache(
        state.notificationSettingsCache,
        state.selectedFilter,
        emit,
      );
    });

    on<NotificacionesSettingsFilterChanged>((event, emit) async {
      await _loadSavedSettingsFromCache(
        state.notificationSettingsCache,
        event.selected,
        emit,
      );
    });

    on<NotificacionesSettingsUpdated>((event, emit) async {
      await _loadSavedSettings(
        state.notificationSettingsCache,
        state.selectedFilter,
        emit,
      );
    });

    on<NotificacionesSettingsFilterPressed>((event, emit) {
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

      emit(NotificacionesSettingsSelecting(
        notificationSettingsCache: state.notificationSettingsCache,
        selectedFilter: state.selectedFilter,
        valueNotificationSettings: state.valueNotificationSettings,
        familyNotificationSettings: state.familyNotificationSettings,
        keywordNotificationSettings: state.keywordNotificationSettings,
      ));
    });

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

  Future<void> _loadSavedSettingsFromCache(
    Map<NotificacionesSettingsFiltro, List<dynamic>> cache,
    NotificacionesSettingsFiltro selectedFilter,
    Emitter<NotificacionesSettingsState> emit,
  ) async {
    if (cache.containsKey(selectedFilter)) {
      final valueNotificationSettings = selectedFilter == kFiltroValores
          ? cache[selectedFilter]! as List<ValueNotificationSetting>
          : state.valueNotificationSettings;

      final familyNotificationSettings =
          selectedFilter == kFiltroBienesServicios
              ? cache[selectedFilter]! as List<FamiliaUNSPSC>
              : state.familyNotificationSettings;

      final keywordNotificationSettings = selectedFilter == kFiltroPalabrasClave
          ? cache[selectedFilter]! as List<KeywordNotificationSetting>
          : state.keywordNotificationSettings;

      emit(NotificacionesSettingsReady(
        selectedFilter: selectedFilter,
        valueNotificationSettings: valueNotificationSettings,
        familyNotificationSettings: familyNotificationSettings,
        keywordNotificationSettings: keywordNotificationSettings,
        cache: cache,
      ));
    } else {
      await _loadSavedSettings(cache, selectedFilter, emit);
    }
  }

  Future<void> _loadSavedSettings(
    Map<NotificacionesSettingsFiltro, List<dynamic>> cache,
    NotificacionesSettingsFiltro selectedFilter,
    Emitter<NotificacionesSettingsState> emit,
  ) async {
    try {
      emit(NotificacionesSettingsLoading(selectedFilter: selectedFilter));

      final valueNotificationSettings = selectedFilter == kFiltroValores
          ? await grupoUNSPSCRepository.getMontosConfiguracion(
              codigo: userDetails.codigo,
            )
          : state.valueNotificationSettings;

      final familyNotificationSettings =
          selectedFilter == kFiltroBienesServicios
              ? await grupoUNSPSCRepository.getFamiliasClasesUsuario(
                  codigo: userDetails.codigo,
                )
              : state.familyNotificationSettings;

      final keywordNotificationSettings = selectedFilter == kFiltroPalabrasClave
          ? await grupoUNSPSCRepository.getTextosConfiguracion(
              codigo: userDetails.codigo,
            )
          : state.keywordNotificationSettings;

      final cacheValue = selectedFilter == kFiltroValores
          ? valueNotificationSettings
          : selectedFilter == kFiltroPalabrasClave
              ? keywordNotificationSettings
              : familyNotificationSettings;

      final newCache =
          Map<NotificacionesSettingsFiltro, List<dynamic>>.from(cache)
            ..addAll({selectedFilter: cacheValue});

      emit(NotificacionesSettingsReady(
        selectedFilter: selectedFilter,
        valueNotificationSettings: valueNotificationSettings,
        cache: newCache,
        familyNotificationSettings: familyNotificationSettings,
        keywordNotificationSettings: keywordNotificationSettings,
      ));
    } catch (err, str) {
      print(err);
      print(str);
      emit(NotificacionesSettingsFailure(
        err.toString(),
        selectedFilter: selectedFilter,
      ));
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
    this.familyNotificationSettings = const [],
    this.keywordNotificationSettings = const [],
  });

  const NotificacionesSettingsState.initial()
      : selectedFilter = kFiltroBienesServicios,
        valueNotificationSettings = const [],
        notificationSettingsCache = const {},
        familyNotificationSettings = const [],
        keywordNotificationSettings = const [];

  final List<NotificacionesSettingsFiltro> filters = const [
    kFiltroBienesServicios,
    kFiltroValores,
    kFiltroPalabrasClave,
  ];

  final NotificacionesSettingsFiltro selectedFilter;
  final List<ValueNotificationSetting> valueNotificationSettings;
  final List<FamiliaUNSPSC> familyNotificationSettings;
  final List<KeywordNotificationSetting> keywordNotificationSettings;
  final Map<NotificacionesSettingsFiltro, List<dynamic>>
      notificationSettingsCache;

  @override
  List<Object?> get props => [
        filters,
        selectedFilter,
        valueNotificationSettings,
        notificationSettingsCache,
        familyNotificationSettings,
        keywordNotificationSettings,
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
    required List<FamiliaUNSPSC> familyNotificationSettings,
    required List<KeywordNotificationSetting> keywordNotificationSettings,
  }) : super(
          selectedFilter: selectedFilter,
          valueNotificationSettings: valueNotificationSettings,
          notificationSettingsCache: cache,
          familyNotificationSettings: familyNotificationSettings,
          keywordNotificationSettings: keywordNotificationSettings,
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
    required List<FamiliaUNSPSC> familyNotificationSettings,
    required List<KeywordNotificationSetting> keywordNotificationSettings,
    required Map<NotificacionesSettingsFiltro, List<dynamic>>
        notificationSettingsCache,
  }) : super(
          selectedFilter: selectedFilter,
          notificationSettingsCache: notificationSettingsCache,
          valueNotificationSettings: valueNotificationSettings,
          familyNotificationSettings: familyNotificationSettings,
          keywordNotificationSettings: keywordNotificationSettings,
        );
}
