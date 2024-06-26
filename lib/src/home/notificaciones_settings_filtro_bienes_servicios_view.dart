import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_filtro_bienes_servicios_bloc.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/widgets/dropdown_field.dart';
import 'package:oportunidades_cce/src/widgets/search_field.dart';
import 'package:provider/provider.dart';

class NotificacionesSettingsFiltroBienesServiciosView extends StatelessWidget {
  const NotificacionesSettingsFiltroBienesServiciosView({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return BlocProvider<NotificacionesSettingsFiltroBienesServiciosBloc>(
      create: (context) {
        return NotificacionesSettingsFiltroBienesServiciosBloc(
          userDetails: userDetails,
          grupoUNSPSCRepository: sl.get<GrupoUNSPSCRepository>(),
        )..add(const NotificacionesSettingsFiltroStarted());
      },
      child: const _ScaffoldBuilder(),
    );
  }
}

class NotificacionesSettingsFiltroBienesServicios extends StatelessWidget {
  const NotificacionesSettingsFiltroBienesServicios({
    super.key,
    this.contentPadding = const EdgeInsets.all(8),
  });

  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionesSettingsFiltroBienesServiciosBloc,
        NotificacionesSettingsFiltroBienesServiciosState>(
      builder: (context, state) {
        if (state is NotificacionesSettingsFiltroBienesServiciosUninitialized) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final gruposItems = {
          for (final grupo in state.gruposUNSPSC) grupo.id: grupo.nombre,
        };

        final segmentos = state.segmentosParaTermino;

        return Column(
          children: [
            Padding(
              padding: contentPadding,
              child: Column(
                children: [
                  DropdownField(
                    required: true,
                    items: gruposItems,
                    hintText: 'Filtro',
                    isDense: false,
                    onChanged: (int? value) {
                      BlocProvider.of<
                                  NotificacionesSettingsFiltroBienesServiciosBloc>(
                              context)
                          .add(
                        NotificacionesSettingsFiltroBienesServiciosGrupoChanged(
                            grupo: value!),
                      );
                    },
                    value: state.grupoSeleccionado,
                  ),
                  const SizedBox(height: 12),
                  SearchField(
                    value: state.termino,
                    onSubmitted: (value) {
                      BlocProvider.of<
                                  NotificacionesSettingsFiltroBienesServiciosBloc>(
                              context)
                          .add(
                        NotificacionesSettingsFiltroBienesServiciosTermChanged(
                            term: value),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 4),
            Expanded(
              child: state is NotificacionesSettingsFiltroBienesServiciosLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : segmentos.isEmpty
                      ? Padding(
                          padding: contentPadding,
                          child: const Text(
                            'No hay familias con esa descripción',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: segmentos.length + 1,
                          itemBuilder: (context, index) {
                            if (index == segmentos.length) {
                              return const SizedBox(height: 50);
                            }

                            final segmento = segmentos[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    segmento.nombre.replaceAll('?', ''),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (final familia in segmento.familias)
                                      FamiliaCard(
                                        familia: familia,
                                        selected: state.familiasSeleccionadas
                                            .contains(familia),
                                        onTap: () {
                                          context
                                              .read<
                                                  NotificacionesSettingsFiltroBienesServiciosBloc>()
                                              .add(
                                                NotificacionesSettingsFamiliaSeleccionada(
                                                    familia),
                                              );
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const Divider(height: 16),
                        ),
            ),
          ],
        );
      },
    );
  }
}

class _ScaffoldBuilder extends StatelessWidget {
  const _ScaffoldBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionesSettingsFiltroBienesServiciosBloc,
        NotificacionesSettingsFiltroBienesServiciosState>(
      buildWhen: (prev, curr) =>
          prev.familiasSeleccionadas.length !=
          curr.familiasSeleccionadas.length,
      builder: (context, state) {
        final isVisible = state.familiasSeleccionadas.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Seleccionar bienes y servicios'),
          ),
          body: const NotificacionesSettingsFiltroBienesServicios(),
          floatingActionButton: isVisible
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pop(state.familiasSeleccionadas);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  extendedPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  label: const Text(
                    'ACEPTAR',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class FamiliaCard extends StatelessWidget {
  const FamiliaCard({
    super.key,
    required this.familia,
    this.selected = false,
    this.onTap,
  });

  final GrupoUNSPSC familia;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        familia.nombre.split('\n')[0],
      ),
      subtitle: Text('Cod: ${familia.codigo}'),
      // trailing: (value: value, onChanged: onChanged),
      // trailing: selected ? const Icon(Icons.check) : null,
      // onTap: onTap,
      onChanged: (_) {
        if (onTap != null) {
          onTap!();
        }
      },
      value: selected,
    );
  }
}
