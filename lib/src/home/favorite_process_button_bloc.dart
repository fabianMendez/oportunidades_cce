import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';

class FavoriteProcessButtonBloc
    extends Bloc<FavoriteProcessButtonEvent, FavoriteProcessButtonState> {
  FavoriteProcessButtonBloc({
    required this.userDetails,
    required this.idProceso,
    required this.procesoRepository,
  }) : super(const FavoriteProcessButtonInitial()) {
    on<FavoriteProcessButtonStarted>((_, emit) async {
      try {
        emit(const FavoriteProcessButtonLoading());

        final esSeguidor = await procesoRepository.esSeguidorProceso(
          codigo: userDetails.codigo,
          idProceso: '$idProceso',
        );

        emit(FavoriteProcessButtonReady(isFavorite: esSeguidor));
      } catch (err, str) {
        print(err);
        print(str);
        emit(FavoriteProcessButtonFailure(err.toString()));
      }
    });

    on<FavoriteProcessButtonChanged>((event, emit) async {
      try {
        emit(const FavoriteProcessButtonLoading());

        final response = await procesoRepository.seguirNoSeguirProceso(
          codigo: userDetails.codigo,
          idProceso: '$idProceso',
          insertar: event.isFavorite,
        );

        if (response.successful) {
          emit(FavoriteProcessButtonReady(isFavorite: event.isFavorite));
        } else {
          emit(FavoriteProcessButtonFailure(response.message));
        }
      } catch (err, str) {
        print(err);
        print(str);
        emit(FavoriteProcessButtonFailure(err.toString()));
      }
    });
  }

  final UserDetails userDetails;
  final ProcesoRepository procesoRepository;
  final int idProceso;
}

abstract class FavoriteProcessButtonEvent extends Equatable {
  const FavoriteProcessButtonEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteProcessButtonStarted extends FavoriteProcessButtonEvent {
  const FavoriteProcessButtonStarted();
}

class FavoriteProcessButtonChanged extends FavoriteProcessButtonEvent {
  const FavoriteProcessButtonChanged({
    required this.isFavorite,
  });

  final bool isFavorite;

  @override
  List<Object?> get props => [...super.props, isFavorite];
}

abstract class FavoriteProcessButtonState extends Equatable {
  const FavoriteProcessButtonState();

  @override
  List<Object?> get props => [];
}

class FavoriteProcessButtonInitial extends FavoriteProcessButtonState {
  const FavoriteProcessButtonInitial();
}

class FavoriteProcessButtonLoading extends FavoriteProcessButtonState {
  const FavoriteProcessButtonLoading();
}

class FavoriteProcessButtonFailure extends FavoriteProcessButtonState {
  const FavoriteProcessButtonFailure(
    this.error,
  );

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}

class FavoriteProcessButtonReady extends FavoriteProcessButtonState {
  const FavoriteProcessButtonReady({
    required this.isFavorite,
  });

  final bool isFavorite;

  @override
  List<Object?> get props => [...super.props, isFavorite];
}
