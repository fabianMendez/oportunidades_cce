import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';

class ProcessSearchBloc extends Bloc<ProcessSearchEvent, ProcessSearchState> {
  ProcessSearchBloc({
    required this.userDetails,
    required this.procesoRepository,
  }) : super(const ProcessSearchUninitialized());

  final UserDetails userDetails;
  final ProcesoRepository procesoRepository;

  Stream<ProcessSearchState> _searchByTerm(ProcessSearchState state) async* {
    try {
      yield ProcessSearchLoading(term: state.term);
      final results = await procesoRepository.getProcesosBusquedaRapida(
        codigo: userDetails.codigo,
        texto: state.term,
      );

      print(results.length);

      yield ProcessSearchReady(
        term: state.term,
        results: results,
      );
    } catch (err, str) {
      print(err);
      print(str);
      yield ProcessSearchFailure(
        err.toString(),
        term: state.term,
      );
    }
  }

  @override
  Stream<ProcessSearchState> mapEventToState(ProcessSearchEvent event) async* {
    if (event is ProcessSearchStarted) {
      // yield* _searchByTerm(state);
    } else if (event is ProcessSearchTermChanged) {
      if (event.term.isEmpty) {
        yield const ProcessSearchUninitialized();
      } else {
        yield* _searchByTerm(ProcessSearchState(
          results: state.results,
          term: event.term,
        ));
      }
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

class NotificacionesSettingsFamiliaSeleccionada extends ProcessSearchEvent {
  const NotificacionesSettingsFamiliaSeleccionada({required this.id});

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
}

class ProcessSearchState extends Equatable {
  const ProcessSearchState({
    this.term = '',
    this.results = const [],
  });

  const ProcessSearchState.initial()
      : term = '',
        results = const [];

  final String term;
  final List<ProcessSearchResult> results;

  @override
  List<Object?> get props => [
        term,
        results,
      ];
}

class ProcessSearchUninitialized extends ProcessSearchState {
  const ProcessSearchUninitialized();
}

class ProcessSearchLoading extends ProcessSearchState {
  const ProcessSearchLoading({
    String term = '',
  }) : super(
          term: term,
        );
}

class ProcessSearchReady extends ProcessSearchState {
  const ProcessSearchReady({
    String term = '',
    required List<ProcessSearchResult> results,
  }) : super(
          term: term,
          results: results,
        );
}

class ProcessSearchFailure extends ProcessSearchState {
  const ProcessSearchFailure(
    this.error, {
    String term = '',
  }) : super(
          term: term,
        );
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
