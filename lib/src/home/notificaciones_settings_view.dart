import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_bloc.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/widgets/dropdown_field.dart';
import 'package:provider/provider.dart';

class NotificacionesSettingsView extends StatelessWidget {
  const NotificacionesSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: BlocProvider<NotificacionesSettingsBloc>(
        create: (context) {
          return NotificacionesSettingsBloc(
            userDetails: userDetails,
            authenticatedNavigatorBloc:
                BlocProvider.of<AuthenticatedNavigatorBloc>(context),
            grupoUNSPSCRepository: sl.get<GrupoUNSPSCRepository>(),
          )..add(const NotificacionesSettingsStarted());
        },
        child: const NotificacionesSettings(),
      ),
    );
  }
}

class NotificacionesSettings extends StatelessWidget {
  const NotificacionesSettings({super.key});

  static const _kPadding = EdgeInsets.all(16);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionesSettingsBloc, NotificacionesSettingsState>(
      builder: (context, state) {
        final items = {
          for (final filter in state.filters) filter.value: filter.description,
        };

        final isLoading = state is NotificacionesSettingsLoading;

        return Column(
          children: [
            Padding(
              padding: _kPadding,
              child: Column(
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
                      BlocProvider.of<NotificacionesSettingsBloc>(context).add(
                        const NotificacionesSettingsFilterPressed(),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: Text(state.selectedFilter.actionMessage),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : NotificacionesSettingsListing(settingsState: state),
            ),
          ],
        );
      },
    );
  }
}

class NotificacionesSettingsListing extends StatelessWidget {
  const NotificacionesSettingsListing({
    super.key,
    required this.settingsState,
  });

  final NotificacionesSettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    if (settingsState.selectedFilter == kFiltroValores) {
      return ValueNotificationSettingsListing(settingsState: settingsState);
    }

    if (settingsState.selectedFilter == kFiltroPalabrasClave) {
      return KeywordNotificationSettingsListing(settingsState: settingsState);
    }

    if (settingsState.valueNotificationSettings.isEmpty) {
      return const Center(child: Text('No hay configuraciones'));
    }

    return ListView.builder(
      itemCount: settingsState.valueNotificationSettings.length,
      itemBuilder: (_, index) {
        final setting = settingsState.valueNotificationSettings[index];
        return ListTile(
          title: Text(setting.montoInferior),
          subtitle: Text(setting.montoSuperior),
        );
      },
    );
  }
}

class EmptyNotificationSettings extends StatelessWidget {
  const EmptyNotificationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No hay configuraciones'));
  }
}

class ValueNotificationSettingsListing extends StatelessWidget {
  const ValueNotificationSettingsListing({
    super.key,
    required this.settingsState,
  });

  final NotificacionesSettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    if (settingsState.valueNotificationSettings.isEmpty) {
      return const EmptyNotificationSettings();
    }

    return ListView.builder(
      itemCount: settingsState.valueNotificationSettings.length,
      itemBuilder: (_, index) {
        final setting = settingsState.valueNotificationSettings[index];
        return ListTile(
          title: Text(setting.montoInferior),
          subtitle: Text(setting.montoSuperior),
        );
      },
    );
  }
}

class KeywordNotificationSettingsListing extends StatelessWidget {
  const KeywordNotificationSettingsListing({
    super.key,
    required this.settingsState,
  });

  final NotificacionesSettingsState settingsState;

  @override
  Widget build(BuildContext context) {
    if (settingsState.keywordNotificationSettings.isEmpty) {
      return const EmptyNotificationSettings();
    }

    return ListView.builder(
      itemCount: settingsState.keywordNotificationSettings.length,
      itemBuilder: (_, index) {
        final setting = settingsState.keywordNotificationSettings[index];
        return ListTile(
          title: Text(setting.texto),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
