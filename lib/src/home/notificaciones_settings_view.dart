import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_bloc.dart';
import 'package:oportunidades_cce/src/widgets/dropdown_field.dart';

class NotificacionesSettingsView extends StatelessWidget {
  const NotificacionesSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: BlocProvider<NotificacionesSettingsBloc>(
        create: (context) => NotificacionesSettingsBloc(),
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: NotificacionesSettings(),
          ),
        ),
      ),
    );
  }
}

class NotificacionesSettings extends StatelessWidget {
  const NotificacionesSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionesSettingsBloc, NotificacionesSettingsState>(
      builder: (context, state) {
        final items = {
          for (final filter in state.filters) filter.value: filter.description,
        };

        return Column(
          children: [
            DropdownField(
              required: true,
              items: items,
              hintText: 'Filtro',
              onChanged: (String? value) {
                final selected =
                    state.filters.firstWhere((elm) => elm.value == value);

                BlocProvider.of<NotificacionesSettingsBloc>(context).add(
                  NotificacionesSettingsFilterChanged(selected: selected),
                );
              },
              value: state.selectedFilter.value,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (state.selectedFilter == kFiltroBienesServicios) {
                  BlocProvider.of<AuthenticatedNavigatorBloc>(context).add(
                      const NotificacionesSettingsFiltroBienesServiciosViewPushed());
                } else if (state.selectedFilter == kFiltroValores) {
                  BlocProvider.of<AuthenticatedNavigatorBloc>(context)
                      .add(const NotificacionesSettingsMontoViewPushed());
                } else if (state.selectedFilter == kFiltroPalabrasClave) {
                  BlocProvider.of<AuthenticatedNavigatorBloc>(context)
                      .add(const NotificacionesSettingsKeywordViewPushed());
                }
              },
              icon: const Icon(Icons.add),
              label: Text(state.selectedFilter.actionMessage),
            ),
          ],
        );
      },
    );
  }
}
