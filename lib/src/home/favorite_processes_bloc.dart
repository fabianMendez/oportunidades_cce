import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';

class FavoriteProcessesBloc
    extends Bloc<FavoriteProcessesEvent, FavoriteProcessesState> {
  FavoriteProcessesBloc({
    required this.userDetails,
    required this.procesoRepository,
  }) : super(const FavoriteProcessesUninitialized());

  final UserDetails userDetails;
  final ProcesoRepository procesoRepository;

  @override
  Stream<FavoriteProcessesState> mapEventToState(
      FavoriteProcessesEvent event) async* {
    if (event is FavoriteProcessesStarted ||
        event is FavoriteProcessesRefreshed) {
      try {
        yield const FavoriteProcessesLoading();
        final results = await procesoRepository.getMisProcesos(
          codigo: userDetails.codigo,
        );

        print(results.length);

        yield FavoriteProcessesReady(
          results: results,
        );
      } catch (err, str) {
        print(err);
        print(str);
        yield FavoriteProcessesFailure(
          err.toString(),
        );
      }
    }
  }
}

abstract class FavoriteProcessesEvent extends Equatable {
  const FavoriteProcessesEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteProcessesStarted extends FavoriteProcessesEvent {
  const FavoriteProcessesStarted();
}

class FavoriteProcessesRefreshed extends FavoriteProcessesEvent {
  const FavoriteProcessesRefreshed();
}

class FavoriteProcessesState extends Equatable {
  const FavoriteProcessesState({
    this.results = const [],
  });

  const FavoriteProcessesState.initial() : results = const [];

  final List<ProcessSearchResult> results;

  @override
  List<Object?> get props => [
        results,
      ];
}

class FavoriteProcessesUninitialized extends FavoriteProcessesState {
  const FavoriteProcessesUninitialized();
}

class FavoriteProcessesLoading extends FavoriteProcessesState {
  const FavoriteProcessesLoading() : super();
}

class FavoriteProcessesReady extends FavoriteProcessesState {
  const FavoriteProcessesReady({
    required List<ProcessSearchResult> results,
  }) : super(
          results: results,
        );
}

class FavoriteProcessesFailure extends FavoriteProcessesState {
  const FavoriteProcessesFailure(this.error) : super();
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
