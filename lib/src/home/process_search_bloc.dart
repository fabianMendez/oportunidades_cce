import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/filtro_repository.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';

class ProcessSearchBloc extends Bloc<ProcessSearchEvent, ProcessSearchState> {
  ProcessSearchBloc({
    required this.userDetails,
    required this.procesoRepository,
    required this.filtroRepository,
  }) : super(const ProcessSearchUninitialized());

  final UserDetails userDetails;
  final ProcesoRepository procesoRepository;
  final FiltroRepository filtroRepository;

  Stream<ProcessSearchState> _searchByTerm(ProcessSearchState state) async* {
    try {
      final nstt = state.loading();
      yield nstt;

      final results = await procesoRepository.getProcesosBusquedaRapida(
        codigo: userDetails.codigo,
        texto: state.term,
      );

      print(results.length);

      yield state.ready(results: results);
    } catch (err, str) {
      print(err);
      print(str);
      yield state.failure(err.toString());
    }
  }

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
      final filters =
          await filtroRepository.getFiltros(codigo: userDetails.codigo);
      print(filters);
      // yield* _searchByTerm(state);
    } else if (event is ProcessSearchTermChanged) {
      if (event.term.isEmpty) {
        yield const ProcessSearchUninitialized();
      } else {
        yield* _search(ProcessSearchState(
          results: state.results,
          term: event.term,
        ));
      }
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
      ));
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

class NotificacionesSettingsFamiliaSeleccionada extends ProcessSearchEvent {
  const NotificacionesSettingsFamiliaSeleccionada({required this.id});

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
}

class ProcessSearchState extends Equatable {
  const ProcessSearchState({
    this.term = '',
    this.filter = const SavedFilter(),
    this.results = const [],
  });

  static const initial = ProcessSearchState();

  final String term;
  final SavedFilter filter;
  final List<ProcessSearchResult> results;

  bool get isEmpty => term.isEmpty && filter.isEmpty;

  ProcessSearchLoading loading() {
    return ProcessSearchLoading(
      term: term,
      filter: filter,
    );
  }

  ProcessSearchReady ready({
    required List<ProcessSearchResult> results,
  }) {
    return ProcessSearchReady(
      term: term,
      filter: filter,
      results: results,
    );
  }

  ProcessSearchFailure failure(String error) {
    return ProcessSearchFailure(
      error,
      term: term,
      filter: filter,
    );
  }

  @override
  List<Object?> get props => [
        term,
        filter,
        results,
      ];
}

class ProcessSearchUninitialized extends ProcessSearchState {
  const ProcessSearchUninitialized();
}

class ProcessSearchLoading extends ProcessSearchState {
  const ProcessSearchLoading({
    String term = '',
    required SavedFilter filter,
  }) : super(
          term: term,
          filter: filter,
        );
}

class ProcessSearchReady extends ProcessSearchState {
  const ProcessSearchReady({
    String term = '',
    required SavedFilter filter,
    required List<ProcessSearchResult> results,
  }) : super(
          term: term,
          filter: filter,
          results: results,
        );
}

class ProcessSearchFailure extends ProcessSearchState {
  const ProcessSearchFailure(
    this.error, {
    String term = '',
    required SavedFilter filter,
  }) : super(term: term, filter: filter);

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
