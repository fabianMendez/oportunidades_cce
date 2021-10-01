import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';

class FavoriteEntityButtonBloc
    extends Bloc<FavoriteEntityButtonEvent, FavoriteEntityButtonState> {
  FavoriteEntityButtonBloc({
    required this.userDetails,
    required this.idEntidad,
    required this.entidadRepository,
  }) : super(const FavoriteEntityButtonInitial()) {
    on<FavoriteEntityButtonStarted>((_, emit) async {
      try {
        emit(const FavoriteEntityButtonLoading());

        final esSeguidor = await entidadRepository.esSeguidorEntidad(
          codigo: userDetails.codigo,
          idEntidad: idEntidad,
        );

        emit(FavoriteEntityButtonReady(isFavorite: esSeguidor));
      } catch (err, str) {
        print(err);
        print(str);
        emit(FavoriteEntityButtonFailure(err.toString()));
      }
    });

    on<FavoriteEntityButtonChanged>((event, emit) async {
      try {
        emit(const FavoriteEntityButtonLoading());

        final response = await entidadRepository.seguirNoSeguirEntidad(
          codigo: userDetails.codigo,
          idEntidad: idEntidad,
          insertar: event.isFavorite,
        );

        if (response.successful) {
          emit(FavoriteEntityButtonReady(isFavorite: event.isFavorite));
        } else {
          emit(FavoriteEntityButtonFailure(response.message));
        }
      } catch (err, str) {
        print(err);
        print(str);
        emit(FavoriteEntityButtonFailure(err.toString()));
      }
    });
  }

  final UserDetails userDetails;
  final EntidadRepository entidadRepository;
  final int idEntidad;
}

abstract class FavoriteEntityButtonEvent extends Equatable {
  const FavoriteEntityButtonEvent();

  @override
  List<Object?> get props => [];
}

class FavoriteEntityButtonStarted extends FavoriteEntityButtonEvent {
  const FavoriteEntityButtonStarted();
}

class FavoriteEntityButtonChanged extends FavoriteEntityButtonEvent {
  const FavoriteEntityButtonChanged({
    required this.isFavorite,
  });

  final bool isFavorite;

  @override
  List<Object?> get props => [...super.props, isFavorite];
}

abstract class FavoriteEntityButtonState extends Equatable {
  const FavoriteEntityButtonState();

  @override
  List<Object?> get props => [];
}

class FavoriteEntityButtonInitial extends FavoriteEntityButtonState {
  const FavoriteEntityButtonInitial();
}

class FavoriteEntityButtonLoading extends FavoriteEntityButtonState {
  const FavoriteEntityButtonLoading();
}

class FavoriteEntityButtonFailure extends FavoriteEntityButtonState {
  const FavoriteEntityButtonFailure(
    this.error,
  );

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}

class FavoriteEntityButtonReady extends FavoriteEntityButtonState {
  const FavoriteEntityButtonReady({
    required this.isFavorite,
  });

  final bool isFavorite;

  @override
  List<Object?> get props => [...super.props, isFavorite];
}
