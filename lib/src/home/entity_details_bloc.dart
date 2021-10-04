import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/models/entity_search_result.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';

class EntityDetailsBloc extends Bloc<EntityDetailsEvent, EntityDetailsState> {
  EntityDetailsBloc({
    required this.userDetails,
    required this.entidadRepository,
    required this.procesoRepository,
    required this.id,
  }) : super(EntityDetailsLoading(id: id));

  final UserDetails userDetails;
  final EntidadRepository entidadRepository;
  final ProcesoRepository procesoRepository;
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

        final procesos = await procesoRepository.getProcesosEntidad(
          codigo: userDetails.codigo,
          idEntidad: id,
        );

        yield EntityDetailsReady(
          details: entidad,
          procesos: procesos,
        );
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
    required this.procesos,
  }) : super(id: details.id);

  final EntitySearchResult details;
  final List<ProcessSearchResult> procesos;

  @override
  List<Object?> get props => [...super.props, details, procesos];
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
