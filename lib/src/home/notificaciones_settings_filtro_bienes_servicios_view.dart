import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_filtro_bienes_servicios_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/dropdown_input.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/widgets/search_field.dart';
import 'package:provider/provider.dart';

class NotificacionesSettingsFiltroBienesServiciosView extends StatelessWidget {
  const NotificacionesSettingsFiltroBienesServiciosView({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suscribirme a bienes y servicios'),
      ),
      body: BlocProvider<NotificacionesSettingsFiltroBienesServiciosBloc>(
        create: (context) {
          return NotificacionesSettingsFiltroBienesServiciosBloc(
            userDetails: userDetails,
            grupoUNSPSCRepository: sl.get<GrupoUNSPSCRepository>(),
          )..add(const NotificacionesSettingsFiltroStarted());
        },
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: NotificacionesSettingsFiltroBienesServicios(),
        ),
      ),
    );
  }
}

class NotificacionesSettingsFiltroBienesServicios extends StatelessWidget {
  const NotificacionesSettingsFiltroBienesServicios({Key? key})
      : super(key: key);

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
            DropdownInput(
              required: true,
              items: gruposItems,
              hintText: 'Filtro',
              onChanged: (int? value) {
                FocusScope.of(context).unfocus();

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
            const SizedBox(height: 24),
            Expanded(
              child: state is NotificacionesSettingsFiltroBienesServiciosLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : segmentos.isEmpty
                      ? const Text(
                          'No hay familias con esa descripción',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.separated(
                            itemCount: segmentos.length,
                            itemBuilder: (context, index) {
                              final segmento = segmentos[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    segmento.nombre,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      for (final familia in segmento.familias)
                                        FamiliaCard(familia: familia),
                                    ],
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }
}

class FamiliaCard extends StatelessWidget {
  const FamiliaCard({
    Key? key,
    required this.familia,
    this.seleccionada = false,
  }) : super(key: key);

  final GrupoUNSPSC familia;
  final bool seleccionada;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
            familia.nombre.split('\n')[0],
          ),
          subtitle: Text('Cod: ${familia.codigo}'),
          trailing: const Icon(Icons.check),
        ),
        const Divider()
      ],
    );
  }
}
