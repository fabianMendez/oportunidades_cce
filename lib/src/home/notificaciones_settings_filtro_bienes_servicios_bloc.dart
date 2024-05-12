import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';

class NotificacionesSettingsFiltroBienesServiciosBloc extends Bloc<
    NotificacionesSettingsFiltroBienesServiciosEvent,
    NotificacionesSettingsFiltroBienesServiciosState> {
  NotificacionesSettingsFiltroBienesServiciosBloc({
    required this.userDetails,
    required this.grupoUNSPSCRepository,
  }) : super(const NotificacionesSettingsFiltroBienesServiciosUninitialized()) {
    on<NotificacionesSettingsFiltroStarted>((event, emit) async {
      final gruposUNSPSC = await grupoUNSPSCRepository.getGruposUNSPSC(
        codigo: userDetails.codigo,
      );

      final newState = NotificacionesSettingsFiltroBienesServiciosLoading(
        gruposUNSPSC: gruposUNSPSC,
        grupoSeleccionado: gruposUNSPSC[0].id,
        familiasSeleccionadas: state.familiasSeleccionadas,
        termino: state.termino,
      );
      emit(newState);

      await _onGrupoChanged(newState, emit);
    });

    on<NotificacionesSettingsFiltroBienesServiciosGrupoChanged>(
        (event, emit) async {
      final newState = NotificacionesSettingsFiltroBienesServiciosLoading(
        grupoSeleccionado: event.grupo,
        gruposUNSPSC: state.gruposUNSPSC,
        familiasSeleccionadas: state.familiasSeleccionadas,
        termino: state.termino,
      );
      emit(newState);
      await _onGrupoChanged(newState, emit);
    });

    on<NotificacionesSettingsFiltroBienesServiciosTermChanged>((event, emit) {
      emit(NotificacionesSettingsFiltroBienesServiciosState(
        grupoSeleccionado: state.grupoSeleccionado,
        gruposUNSPSC: state.gruposUNSPSC,
        segmentos: state.segmentos,
        familiasSeleccionadas: state.familiasSeleccionadas,
        termino: event.term,
      ));
    });

    on<NotificacionesSettingsFamiliaSeleccionada>((event, emit) {
      final isSelected = state.familiasSeleccionadas.contains(event.familia);
      final familiasSeleccionadas = isSelected
          ? state.familiasSeleccionadas
              .where((it) => it != event.familia)
              .toList()
          : state.familiasSeleccionadas.followedBy([event.familia]).toList();

      // await grupoUNSPSCRepository.inscribirseFamiliaUNSPSC(
      //   codigo: userDetails.codigo,
      //   idGrupo: state.grupoSeleccionado,
      //   idFamilia: event.id,
      //   inscribirse: !isSelected,
      // );

      emit(NotificacionesSettingsFiltroBienesServiciosState(
        grupoSeleccionado: state.grupoSeleccionado,
        gruposUNSPSC: state.gruposUNSPSC,
        segmentos: state.segmentos,
        termino: state.termino,
        familiasSeleccionadas: familiasSeleccionadas,
      ));
    });
  }

  final UserDetails userDetails;
  final GrupoUNSPSCRepository grupoUNSPSCRepository;

  Future<void> _onGrupoChanged(
      NotificacionesSettingsFiltroBienesServiciosState state,
      Emitter<NotificacionesSettingsFiltroBienesServiciosState> emit) async {
    final idGrupo = state.grupoSeleccionado;

    // segmentos y familias del grupo seleccionado
    final segmentos = await grupoUNSPSCRepository.buscarFamiliasUNSPSC(
      codigo: userDetails.codigo,
      idGrupo: idGrupo,
      texto: '',
    );

    emit(NotificacionesSettingsFiltroBienesServiciosState(
      grupoSeleccionado: state.grupoSeleccionado,
      gruposUNSPSC: state.gruposUNSPSC,
      segmentos: segmentos,
      termino: state.termino,
      familiasSeleccionadas: state.familiasSeleccionadas,
    ));

    // las que están marcadas
    // final familias =
    //     await grupoUNSPSCRepository.getFamiliasClasesUsuarioGrupoUNSPSC(
    //   codigo: userDetails.codigo,
    //   idGrupo: idGrupo,
    // );
  }
}

abstract class NotificacionesSettingsFiltroBienesServiciosEvent
    extends Equatable {
  const NotificacionesSettingsFiltroBienesServiciosEvent();

  @override
  List<Object?> get props => [];
}

class NotificacionesSettingsFiltroStarted
    extends NotificacionesSettingsFiltroBienesServiciosEvent {
  const NotificacionesSettingsFiltroStarted();
}

class NotificacionesSettingsFiltroBienesServiciosGrupoChanged
    extends NotificacionesSettingsFiltroBienesServiciosEvent {
  const NotificacionesSettingsFiltroBienesServiciosGrupoChanged({
    required this.grupo,
  });

  final int grupo;

  @override
  List<Object?> get props => [...super.props, grupo];
}

class NotificacionesSettingsFiltroBienesServiciosTermChanged
    extends NotificacionesSettingsFiltroBienesServiciosEvent {
  const NotificacionesSettingsFiltroBienesServiciosTermChanged({
    required this.term,
  });

  final String term;

  @override
  List<Object?> get props => [...super.props, term];
}

class NotificacionesSettingsFamiliaSeleccionada
    extends NotificacionesSettingsFiltroBienesServiciosEvent {
  const NotificacionesSettingsFamiliaSeleccionada(this.familia);

  final GrupoUNSPSC familia;

  @override
  List<Object?> get props => [...super.props, familia];
}

class NotificacionesSettingsFiltroBienesServiciosState extends Equatable {
  const NotificacionesSettingsFiltroBienesServiciosState({
    this.grupoSeleccionado = 0,
    this.gruposUNSPSC = const [],
    this.segmentos = const [],
    this.termino = '',
    this.familiasSeleccionadas = const [],
  });

  const NotificacionesSettingsFiltroBienesServiciosState.initial()
      : grupoSeleccionado = 0,
        gruposUNSPSC = const [],
        segmentos = const [],
        termino = '',
        familiasSeleccionadas = const [];

  final int grupoSeleccionado;
  final List<GrupoUNSPSC> gruposUNSPSC;
  final List<SegmentoUNSPSC> segmentos;
  final String termino;
  final List<GrupoUNSPSC> familiasSeleccionadas;

  List<SegmentoUNSPSC> get segmentosParaTermino {
    final terminoTemp = termino.toLowerCase();

    return segmentos
        .map((segmento) {
          final familias = segmento.familias.where((familia) {
            return familia.nombre.toLowerCase().contains(terminoTemp);
          }).toList();

          return SegmentoUNSPSC(
            codigo: segmento.codigo,
            estado: segmento.estado,
            nombre: segmento.nombre,
            familias: familias,
          );
        })
        .where((segmento) => segmento.familias.isNotEmpty)
        .toList();
  }

  @override
  List<Object?> get props => [
        grupoSeleccionado,
        gruposUNSPSC,
        segmentos,
        termino,
        familiasSeleccionadas
      ];
}

class NotificacionesSettingsFiltroBienesServiciosUninitialized
    extends NotificacionesSettingsFiltroBienesServiciosState {
  const NotificacionesSettingsFiltroBienesServiciosUninitialized();
}

class NotificacionesSettingsFiltroBienesServiciosLoading
    extends NotificacionesSettingsFiltroBienesServiciosState {
  const NotificacionesSettingsFiltroBienesServiciosLoading({
    required super.grupoSeleccionado,
    required super.gruposUNSPSC,
    super.termino,
    super.familiasSeleccionadas,
  });
}
