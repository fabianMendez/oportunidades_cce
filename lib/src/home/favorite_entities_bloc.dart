import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/models/entity_search_result.dart';

class FavoriteEntitiesBloc
    extends Bloc<FavoriteEntitiesEvent, FavoriteEntitiesState> {
  FavoriteEntitiesBloc({
    required this.userDetails,
    required this.entidadRepository,
  }) : super(const FavoriteEntitiesLoading());

  final UserDetails userDetails;
  final EntidadRepository entidadRepository;

  @override
  Stream<FavoriteEntitiesState> mapEventToState(
      FavoriteEntitiesEvent event) async* {
    if (event is FavoriteEntitiesStarted ||
        event is FavoriteEntitiesRefreshed) {
      try {
        yield const FavoriteEntitiesLoading();
        final results = await entidadRepository.getMisEntidades(
          codigo: userDetails.codigo,
        );

        print(results.length);

        yield FavoriteEntitiesReady(
          results: results,
        );
      } catch (err, str) {
        print(err);
        print(str);
        yield FavoriteEntitiesFailure(
          err.toString(),
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

class FavoriteEntitiesRefreshed extends FavoriteEntitiesEvent {
  const FavoriteEntitiesRefreshed();
}

class FavoriteEntitiesState extends Equatable {
  const FavoriteEntitiesState({
    this.results = const [],
  });

  const FavoriteEntitiesState.initial() : results = const [];

  final List<EntitySearchResult> results;

  @override
  List<Object?> get props => [results];
}

class FavoriteEntitiesUninitialized extends FavoriteEntitiesState {
  const FavoriteEntitiesUninitialized();
}

class FavoriteEntitiesLoading extends FavoriteEntitiesState {
  const FavoriteEntitiesLoading() : super();
}

class FavoriteEntitiesReady extends FavoriteEntitiesState {
  const FavoriteEntitiesReady({
    required List<EntitySearchResult> results,
  }) : super(results: results);
}

class FavoriteEntitiesFailure extends FavoriteEntitiesState {
  const FavoriteEntitiesFailure(this.error) : super();
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
