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
  }) : super(EntityDetailsLoading(id: id)) {
    on<EntityDetailsStarted>((event, emit) async {
      try {
        emit(EntityDetailsLoading(id: id));
        final entidad = await entidadRepository.getEntidad(
          codigo: userDetails.codigo,
          idEntidad: id,
        );

        final procesos = await procesoRepository.getProcesosEntidad(
          codigo: userDetails.codigo,
          idEntidad: id,
        );

        emit(EntityDetailsReady(
          details: entidad,
          procesos: procesos,
        ));
      } catch (err, str) {
        print(err);
        print(str);
        emit(EntityDetailsFailure(err.toString(), id: id));
      }
    });
  }

  final UserDetails userDetails;
  final EntidadRepository entidadRepository;
  final ProcesoRepository procesoRepository;
  final int id;
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
    required super.id,
  });
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
    required super.id,
  });
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
