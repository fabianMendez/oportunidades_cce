import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/models/entity_search_result.dart';

class FavoriteEntitiesBloc
    extends Bloc<FavoriteEntitiesEvent, FavoriteEntitiesState> {
  FavoriteEntitiesBloc({
    required this.userDetails,
    required this.grupoUNSPSCRepository,
  }) : super(const FavoriteEntitiesLoading());

  final UserDetails userDetails;
  final GrupoUNSPSCRepository grupoUNSPSCRepository;

  @override
  Stream<FavoriteEntitiesState> mapEventToState(
      FavoriteEntitiesEvent event) async* {
    if (event is FavoriteEntitiesStarted) {
      try {
        yield FavoriteEntitiesLoading(term: state.term);
        final results = await grupoUNSPSCRepository.getMisEntidades(
          codigo: userDetails.codigo,
        );

        print(results.length);

        yield FavoriteEntitiesReady(
          term: state.term,
          results: results,
        );
      } catch (err, str) {
        print(err);
        print(str);
        yield FavoriteEntitiesFailure(
          err.toString(),
          term: state.term,
        );
      }
    }
  }
}

abstract class FavoriteEntitiesEvent extends Equatable {
  const FavoriteEntitiesEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteEntitiesStarted extends FavoriteEntitiesEvent {
  const FavoriteEntitiesStarted();
}

class FavoriteEntitiesState extends Equatable {
  const FavoriteEntitiesState({
    this.term = '',
    this.results = const [],
  });

  const FavoriteEntitiesState.initial()
      : term = '',
        results = const [];

  final String term;
  final List<EntitySearchResult> results;

  @override
  List<Object?> get props => [
        term,
        results,
      ];
}

class FavoriteEntitiesUninitialized extends FavoriteEntitiesState {
  const FavoriteEntitiesUninitialized();
}

class FavoriteEntitiesLoading extends FavoriteEntitiesState {
  const FavoriteEntitiesLoading({
    String term = '',
  }) : super(
          term: term,
        );
}

class FavoriteEntitiesReady extends FavoriteEntitiesState {
  const FavoriteEntitiesReady({
    String term = '',
    required List<EntitySearchResult> results,
  }) : super(
          term: term,
          results: results,
        );
}

class FavoriteEntitiesFailure extends FavoriteEntitiesState {
  const FavoriteEntitiesFailure(
    this.error, {
    String term = '',
  }) : super(
          term: term,
        );
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
