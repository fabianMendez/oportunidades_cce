import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/models/entity_search_result.dart';

class EntityDetailsBloc extends Bloc<EntityDetailsEvent, EntityDetailsState> {
  EntityDetailsBloc({
    required this.userDetails,
    required this.entidadRepository,
    required this.id,
  }) : super(EntityDetailsLoading(id: id));

  final UserDetails userDetails;
  final EntidadRepository entidadRepository;
  final int id;

  @override
  Stream<EntityDetailsState> mapEventToState(EntityDetailsEvent event) async* {
    if (event is EntityDetailsStarted) {
      try {
        yield EntityDetailsLoading(id: id);
        final entidad = await entidadRepository.getEntidad(
          codigo: userDetails.codigo,
          idEntidad: id,
        );

        yield EntityDetailsReady(details: entidad);
      } catch (err, str) {
        print(err);
        print(str);
        yield EntityDetailsFailure(err.toString(), id: id);
      }
    }
  }
}

abstract class EntityDetailsEvent extends Equatable {
  const EntityDetailsEvent();

  @override
  List<Object?> get props => [];
}

class EntityDetailsStarted extends EntityDetailsEvent {
  const EntityDetailsStarted();
}

class EntityDetailsState extends Equatable {
  const EntityDetailsState({
    this.id = 0,
  });

  const EntityDetailsState.initial() : id = 0;

  final int id;

  @override
  List<Object?> get props => [id];
}

class EntityDetailsUninitialized extends EntityDetailsState {
  const EntityDetailsUninitialized();
}

class EntityDetailsLoading extends EntityDetailsState {
  const EntityDetailsLoading({
    required int id,
  }) : super(id: id);
}

class EntityDetailsReady extends EntityDetailsState {
  EntityDetailsReady({
    required this.details,
  }) : super(id: details.id);

  final EntitySearchResult details;
}

class EntityDetailsFailure extends EntityDetailsState {
  const EntityDetailsFailure(
    this.error, {
    required int id,
  }) : super(id: id);
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
