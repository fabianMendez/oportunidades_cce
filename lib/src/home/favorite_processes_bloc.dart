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
    if (event is FavoriteProcessesStarted) {
      try {
        yield FavoriteProcessesLoading(term: state.term);
        final results = await procesoRepository.getMisProcesos(
          codigo: userDetails.codigo,
        );

        print(results.length);

        yield FavoriteProcessesReady(
          term: state.term,
          results: results,
        );
      } catch (err, str) {
        print(err);
        print(str);
        yield FavoriteProcessesFailure(
          err.toString(),
          term: state.term,
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

class FavoriteProcessesState extends Equatable {
  const FavoriteProcessesState({
    this.term = '',
    this.results = const [],
  });

  const FavoriteProcessesState.initial()
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

class FavoriteProcessesUninitialized extends FavoriteProcessesState {
  const FavoriteProcessesUninitialized();
}

class FavoriteProcessesLoading extends FavoriteProcessesState {
  const FavoriteProcessesLoading({
    String term = '',
  }) : super(
          term: term,
        );
}

class FavoriteProcessesReady extends FavoriteProcessesState {
  const FavoriteProcessesReady({
    String term = '',
    required List<ProcessSearchResult> results,
  }) : super(
          term: term,
          results: results,
        );
}

class FavoriteProcessesFailure extends FavoriteProcessesState {
  const FavoriteProcessesFailure(
    this.error, {
    String term = '',
  }) : super(
          term: term,
        );
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
