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
  }) : super(const NotificacionesSettingsFiltroBienesServiciosUninitialized());

  final UserDetails userDetails;
  final GrupoUNSPSCRepository grupoUNSPSCRepository;

  Stream<NotificacionesSettingsFiltroBienesServiciosState> _onGrupoChanged(
      NotificacionesSettingsFiltroBienesServiciosState state) async* {
    final idGrupo = state.grupoSeleccionado;

    // segmentos y familias del grupo seleccionado
    final segmentos = await grupoUNSPSCRepository.buscarFamiliasUNSPSC(
      codigo: userDetails.codigo,
      idGrupo: idGrupo,
      texto: '',
    );

    yield NotificacionesSettingsFiltroBienesServiciosState(
      grupoSeleccionado: state.grupoSeleccionado,
      gruposUNSPSC: state.gruposUNSPSC,
      segmentos: segmentos,
      termino: state.termino,
      familiasSeleccionadas: state.familiasSeleccionadas,
    );

    // las que están marcadas
    // final familias =
    //     await grupoUNSPSCRepository.getFamiliasClasesUsuarioGrupoUNSPSC(
    //   codigo: userDetails.codigo,
    //   idGrupo: idGrupo,
    // );
  }

  @override
  Stream<NotificacionesSettingsFiltroBienesServiciosState> mapEventToState(
      NotificacionesSettingsFiltroBienesServiciosEvent event) async* {
    if (event is NotificacionesSettingsFiltroStarted) {
      final gruposUNSPSC = await grupoUNSPSCRepository.getGruposUNSPSC(
        codigo: userDetails.codigo,
      );

      final newState = NotificacionesSettingsFiltroBienesServiciosLoading(
        gruposUNSPSC: gruposUNSPSC,
        grupoSeleccionado: gruposUNSPSC[0].id,
        familiasSeleccionadas: state.familiasSeleccionadas,
        termino: state.termino,
      );
      yield newState;

      yield* _onGrupoChanged(newState);
    } else if (event
        is NotificacionesSettingsFiltroBienesServiciosGrupoChanged) {
      final newState = NotificacionesSettingsFiltroBienesServiciosLoading(
        grupoSeleccionado: event.grupo,
        gruposUNSPSC: state.gruposUNSPSC,
        familiasSeleccionadas: state.familiasSeleccionadas,
        termino: state.termino,
      );
      yield newState;
      yield* _onGrupoChanged(newState);
    } else if (event
        is NotificacionesSettingsFiltroBienesServiciosTermChanged) {
      yield NotificacionesSettingsFiltroBienesServiciosState(
        grupoSeleccionado: state.grupoSeleccionado,
        gruposUNSPSC: state.gruposUNSPSC,
        segmentos: state.segmentos,
        familiasSeleccionadas: state.familiasSeleccionadas,
        termino: event.term,
      );
    } else if (event is NotificacionesSettingsFamiliaSeleccionada) {
      final isSelected = state.familiasSeleccionadas.contains(event.id);
      final familiasSeleccionadas = isSelected
          ? state.familiasSeleccionadas
              .where((element) => element != event.id)
              .toList()
          : state.familiasSeleccionadas.followedBy([event.id]).toList();

      // await grupoUNSPSCRepository.inscribirseFamiliaUNSPSC(
      //   codigo: userDetails.codigo,
      //   idGrupo: state.grupoSeleccionado,
      //   idFamilia: event.id,
      //   inscribirse: !isSelected,
      // );

      yield NotificacionesSettingsFiltroBienesServiciosState(
        grupoSeleccionado: state.grupoSeleccionado,
        gruposUNSPSC: state.gruposUNSPSC,
        segmentos: state.segmentos,
        termino: state.termino,
        familiasSeleccionadas: familiasSeleccionadas,
      );
    }
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
  const NotificacionesSettingsFamiliaSeleccionada({required this.id});

  final int id;

  @override
  List<Object?> get props => [...super.props, id];
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
  final List<int> familiasSeleccionadas;

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
    required int grupoSeleccionado,
    required List<GrupoUNSPSC> gruposUNSPSC,
    String termino = '',
    List<int> familiasSeleccionadas = const [],
  }) : super(
          grupoSeleccionado: grupoSeleccionado,
          gruposUNSPSC: gruposUNSPSC,
          termino: termino,
          familiasSeleccionadas: familiasSeleccionadas,
        );
}
