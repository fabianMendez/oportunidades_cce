import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';

class ProcessDetailsBloc
    extends Bloc<ProcessDetailsEvent, ProcessDetailsState> {
  ProcessDetailsBloc({
    required this.userDetails,
    required this.procesoRepository,
    required this.id,
  }) : super(ProcessDetailsLoading(id: id));

  final UserDetails userDetails;
  final ProcesoRepository procesoRepository;
  final int id;

  @override
  Stream<ProcessDetailsState> mapEventToState(
      ProcessDetailsEvent event) async* {
    if (event is ProcessDetailsStarted) {
      try {
        yield ProcessDetailsLoading(id: id);
        final proceso = await procesoRepository.getProceso(
          codigo: userDetails.codigo,
          idProceso: id,
        );

        yield ProcessDetailsReady(details: proceso);
      } catch (err, str) {
        print(err);
        print(str);
        yield ProcessDetailsFailure(err.toString(), id: id);
      }
    }
  }
}

abstract class ProcessDetailsEvent extends Equatable {
  const ProcessDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ProcessDetailsStarted extends ProcessDetailsEvent {
  const ProcessDetailsStarted();
}

class ProcessDetailsState extends Equatable {
  const ProcessDetailsState({
    this.id = 0,
  });

  const ProcessDetailsState.initial() : id = 0;

  final int id;

  @override
  List<Object?> get props => [id];
}

class ProcessDetailsUninitialized extends ProcessDetailsState {
  const ProcessDetailsUninitialized();
}

class ProcessDetailsLoading extends ProcessDetailsState {
  const ProcessDetailsLoading({
    required int id,
  }) : super(id: id);
}

class ProcessDetailsReady extends ProcessDetailsState {
  ProcessDetailsReady({
    required this.details,
  }) : super(id: 0 /*TODO(fmendez): pass id*/);

  final Proceso details;
}

class ProcessDetailsFailure extends ProcessDetailsState {
  const ProcessDetailsFailure(
    this.error, {
    required int id,
  }) : super(id: id);
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
