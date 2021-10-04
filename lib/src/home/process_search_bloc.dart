import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/filtro_repository.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';

class ProcessSearchBloc extends Bloc<ProcessSearchEvent, ProcessSearchState> {
  ProcessSearchBloc({
    required this.userDetails,
    required this.procesoRepository,
    required this.filtroRepository,
  }) : super(const ProcessSearchUninitialized());

  final UserDetails userDetails;
  final ProcesoRepository procesoRepository;
  final FiltroRepository filtroRepository;

  Stream<ProcessSearchState> _search(ProcessSearchState stt) async* {
    try {
      final nstt = stt.loading();
      yield nstt;

      List<ProcessSearchResult> results;

      if (stt.filter.isNotEmpty) {
        results = await procesoRepository.busquedaProcesos(
          codigo: userDetails.codigo,
          familias: stt.filter.familias,
          rangos: stt.filter.rangos,
          textos: stt.filter.textos,
        );

        if (stt.term.isNotEmpty) {
          final termLowerCase = stt.term.toLowerCase();
          results = results.where((it) {
            return it.nombreEntidad.toLowerCase().contains(termLowerCase) ||
                it.descripcion.toLowerCase().contains(termLowerCase);
          }).toList();
        }
      } else if (stt.term.isNotEmpty) {
        results = await procesoRepository.getProcesosBusquedaRapida(
          codigo: userDetails.codigo,
          texto: stt.term,
        );
      } else {
        results = [];
      }

      print(results.length);

      final nstt2 = stt.ready(results: results);
      yield nstt2;
    } catch (err, str) {
      print(err);
      print(str);
      yield stt.failure(err.toString());
    }
  }

  @override
  Stream<ProcessSearchState> mapEventToState(ProcessSearchEvent event) async* {
    if (event is ProcessSearchStarted) {
      // final filters =
      //     await filtroRepository.getFiltros(codigo: userDetails.codigo);
      // print(filters);
      // yield* _searchByTerm(state);
    } else if (event is ProcessSearchTermChanged) {
      yield* _search(ProcessSearchState(
        results: state.results,
        term: event.term,
        filter: state.filter,
        sort: state.sort,
      ));
    } else if (event is ProcessSearchKeywordsChanged) {
      final filter = SavedFilter(
        id: state.filter.id,
        familias: state.filter.familias,
        nombre: state.filter.nombre,
        rangos: state.filter.rangos,
        recibirNotificacionesApp: state.filter.recibirNotificacionesApp,
        recibirNotificacionesCorreo: state.filter.recibirNotificacionesCorreo,
        textos: event.keywords.map((keyword) {
          return KeywordNotificationSetting(estado: 0, id: 0, texto: keyword);
        }).toList(),
      );

      yield* _search(ProcessSearchState(
        filter: filter,
        results: state.results,
        term: state.term,
        sort: state.sort,
      ));
    } else if (event is ProcessSearchRangesChanged) {
      final filter = SavedFilter(
        id: state.filter.id,
        familias: state.filter.familias,
        nombre: state.filter.nombre,
        textos: state.filter.textos,
        recibirNotificacionesApp: state.filter.recibirNotificacionesApp,
        recibirNotificacionesCorreo: state.filter.recibirNotificacionesCorreo,
        rangos: event.ranges.map((range) {
          return ValueNotificationSetting(
            estado: 0,
            id: 0,
            montoInferior: '${range.min.toInt()}',
            montoSuperior: '${range.max.toInt()}',
          );
        }).toList(),
      );

      yield* _search(ProcessSearchState(
        filter: filter,
        results: state.results,
        term: state.term,
        sort: state.sort,
      ));
    } else if (event is ProcessSearchFamiliesChanged) {
      final filter = SavedFilter(
        id: state.filter.id,
        nombre: state.filter.nombre,
        textos: state.filter.textos,
        rangos: state.filter.rangos,
        recibirNotificacionesApp: state.filter.recibirNotificacionesApp,
        recibirNotificacionesCorreo: state.filter.recibirNotificacionesCorreo,
        familias: event.families,
      );

      yield* _search(ProcessSearchState(
        filter: filter,
        results: state.results,
        term: state.term,
        sort: state.sort,
      ));
    } else if (event is ProcessSearchRefreshed) {
      yield* _search(state);
    } else if (event is ProcessSearchSortChanged) {
      yield ProcessSearchState(
        filter: state.filter,
        results: state.results,
        term: state.term,
        sort: event.sort,
      );
    }
  }
}

abstract class ProcessSearchEvent extends Equatable {
  const ProcessSearchEvent();

  @override
  List<Object?> get props => [];
}

class ProcessSearchStarted extends ProcessSearchEvent {
  const ProcessSearchStarted();
}

class ProcessSearchGrupoChanged extends ProcessSearchEvent {
  const ProcessSearchGrupoChanged({
    required this.grupo,
  });

  final int grupo;

  @override
  List<Object?> get props => [...super.props, grupo];
}

class ProcessSearchTermChanged extends ProcessSearchEvent {
  const ProcessSearchTermChanged({
    required this.term,
  });

  final String term;

  @override
  List<Object?> get props => [...super.props, term];
}

class ProcessSearchKeywordsChanged extends ProcessSearchEvent {
  const ProcessSearchKeywordsChanged(
    this.keywords,
  );

  final List<String> keywords;

  @override
  List<Object?> get props => [...super.props, keywords];
}

class ProcessSearchRangesChanged extends ProcessSearchEvent {
  const ProcessSearchRangesChanged(
    this.ranges,
  );

  final List<Range> ranges;

  @override
  List<Object?> get props => [...super.props, ranges];
}

class ProcessSearchFamiliesChanged extends ProcessSearchEvent {
  const ProcessSearchFamiliesChanged(
    this.families,
  );

  final List<GrupoUNSPSC> families;

  @override
  List<Object?> get props => [...super.props, families];
}

class NotificacionesSettingsFamiliaSeleccionada extends ProcessSearchEvent {
  const NotificacionesSettingsFamiliaSeleccionada({required this.id});

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
}

class ProcessSearchRefreshed extends ProcessSearchEvent {
  const ProcessSearchRefreshed();
}

enum ProcessSort { dateDesc, dateAsc, valueAsc, valueDesc }

extension ProcessSortDisplayName on ProcessSort {
  String get displayName {
    switch (this) {
      case (ProcessSort.dateDesc):
        return 'Más recientes';
      case (ProcessSort.dateAsc):
        return 'Más antiguos';
      case (ProcessSort.valueAsc):
        return 'Mayor valor';
      case (ProcessSort.valueDesc):
        return 'Menor valor';

      default:
        return '';
    }
  }
}

extension ProcessSortCompare on ProcessSort {
  int Function(ProcessSearchResult, ProcessSearchResult) get compare {
    switch (this) {
      case (ProcessSort.dateAsc):
        return (a, b) => a.fecha.compareTo(b.fecha);
      case (ProcessSort.dateDesc):
        return (a, b) => b.fecha.compareTo(a.fecha);
      case (ProcessSort.valueAsc):
        return (a, b) => b.valor.compareTo(a.valor);
      case (ProcessSort.valueDesc):
        return (a, b) => a.valor.compareTo(b.valor);

      default:
        throw Error();
    }
  }
}

class ProcessSearchSortChanged extends ProcessSearchEvent {
  const ProcessSearchSortChanged(this.sort);

  final ProcessSort sort;

  @override
  List<Object?> get props => [...super.props, sort];
}

class ProcessSearchState extends Equatable {
  const ProcessSearchState({
    this.term = '',
    this.filter = const SavedFilter(),
    this.results = const [],
    this.sort = ProcessSort.dateDesc,
  });

  static const initial = ProcessSearchState();

  final String term;
  final SavedFilter filter;
  final List<ProcessSearchResult> results;
  final ProcessSort sort;

  bool get isEmpty => term.isEmpty && filter.isEmpty;

  List<ProcessSearchResult> get sortedResults {
    final copy = List<ProcessSearchResult>.from(results);
    copy.sort(sort.compare);
    return copy;
  }

  ProcessSearchLoading loading() {
    return ProcessSearchLoading(
      term: term,
      filter: filter,
      sort: sort,
    );
  }

  ProcessSearchReady ready({
    required List<ProcessSearchResult> results,
  }) {
    return ProcessSearchReady(
      term: term,
      filter: filter,
      results: results,
      sort: sort,
    );
  }

  ProcessSearchFailure failure(String error) {
    return ProcessSearchFailure(
      error,
      term: term,
      filter: filter,
      sort: sort,
    );
  }

  @override
  List<Object?> get props => [
        term,
        filter,
        results,
        sort,
      ];
}

class ProcessSearchUninitialized extends ProcessSearchState {
  const ProcessSearchUninitialized();
}

class ProcessSearchLoading extends ProcessSearchState {
  const ProcessSearchLoading({
    String term = '',
    required SavedFilter filter,
    required ProcessSort sort,
  }) : super(
          term: term,
          filter: filter,
          sort: sort,
        );
}

class ProcessSearchReady extends ProcessSearchState {
  const ProcessSearchReady({
    String term = '',
    required SavedFilter filter,
    required List<ProcessSearchResult> results,
    required ProcessSort sort,
  }) : super(
          term: term,
          filter: filter,
          results: results,
          sort: sort,
        );
}

class ProcessSearchFailure extends ProcessSearchState {
  const ProcessSearchFailure(
    this.error, {
    String term = '',
    required SavedFilter filter,
    required ProcessSort sort,
  }) : super(
          term: term,
          filter: filter,
          sort: sort,
        );

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
