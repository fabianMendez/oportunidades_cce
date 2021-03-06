import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/models/entity_search_result.dart';

class EntitySearchBloc extends Bloc<EntitySearchEvent, EntitySearchState> {
  EntitySearchBloc({
    required this.userDetails,
    required this.entidadRepository,
  }) : super(const EntitySearchUninitialized());

  final UserDetails userDetails;
  final EntidadRepository entidadRepository;

  Stream<EntitySearchState> _searchByTerm(EntitySearchState state) async* {
    try {
      if (state.term.isEmpty) {
        yield const EntitySearchUninitialized();
        return;
      }

      yield EntitySearchLoading(term: state.term);
      final results = await entidadRepository.buscarEntidades(
        codigo: userDetails.codigo,
        texto: state.term,
      );

      print(results.length);

      yield EntitySearchReady(
        term: state.term,
        results: results,
      );
    } catch (err, str) {
      print(err);
      print(str);
      yield EntitySearchFailure(
        err.toString(),
        term: state.term,
      );
    }
  }

  @override
  Stream<EntitySearchState> mapEventToState(EntitySearchEvent event) async* {
    if (event is EntitySearchStarted) {
      // yield* _searchByTerm(state);
    } else if (event is EntitySearchTermChanged) {
      yield* _searchByTerm(EntitySearchState(
        results: state.results,
        term: event.term,
      ));
    } else if (event is EntitySearchRefreshed) {
      yield* _searchByTerm(state);
    }
  }
}

abstract class EntitySearchEvent extends Equatable {
  const EntitySearchEvent();

  @override
  List<Object?> get props => [];
}

class EntitySearchStarted extends EntitySearchEvent {
  const EntitySearchStarted();
}

class EntitySearchGrupoChanged extends EntitySearchEvent {
  const EntitySearchGrupoChanged({
    required this.grupo,
  });

  final int grupo;

  @override
  List<Object?> get props => [...super.props, grupo];
}

class EntitySearchTermChanged extends EntitySearchEvent {
  const EntitySearchTermChanged({
    required this.term,
  });

  final String term;

  @override
  List<Object?> get props => [...super.props, term];
}

class NotificacionesSettingsFamiliaSeleccionada extends EntitySearchEvent {
  const NotificacionesSettingsFamiliaSeleccionada({required this.id});

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
}

class EntitySearchRefreshed extends EntitySearchEvent {
  const EntitySearchRefreshed();
}

class EntitySearchState extends Equatable {
  const EntitySearchState({
    this.term = '',
    this.results = const [],
  });

  const EntitySearchState.initial()
      : term = '',
        results = const [];

  final String term;
  final List<EntitySearchResult> results;

  bool get isEmpty => term.isEmpty;
  bool get isNotEmpty => term.isNotEmpty;

  bool get isLoading => this is EntitySearchLoading;
  bool get isUninitialized => this is EntitySearchUninitialized;

  @override
  List<Object?> get props => [
        term,
        results,
      ];
}

class EntitySearchUninitialized extends EntitySearchState {
  const EntitySearchUninitialized();
}

class EntitySearchLoading extends EntitySearchState {
  const EntitySearchLoading({
    String term = '',
  }) : super(
          term: term,
        );
}

class EntitySearchReady extends EntitySearchState {
  const EntitySearchReady({
    String term = '',
    required List<EntitySearchResult> results,
  }) : super(
          term: term,
          results: results,
        );
}

class EntitySearchFailure extends EntitySearchState {
  const EntitySearchFailure(
    this.error, {
    String term = '',
  }) : super(
          term: term,
        );
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
