import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/notificacion_listado_bloc.dart';
import 'package:oportunidades_cce/src/home/notificacion_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class NotificacionListadoView extends StatelessWidget {
  const NotificacionListadoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return BlocProvider<NotificacionListadoBloc>(
      create: (context) {
        return NotificacionListadoBloc(
          userDetails: userDetails,
          notificacionRepository: sl.get<NotificacionRepository>(),
        )..add(const NotificacionListadoStarted());
      },
      child: const NotificacionListado(),
    );
  }
}

class NotificacionListado extends StatelessWidget {
  const NotificacionListado({Key? key}) : super(key: key);

  void _refresh(BuildContext context) {
    context
        .read<NotificacionListadoBloc>()
        .add(const NotificacionListadoRefreshed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionListadoBloc, NotificacionListadoState>(
      builder: (context, state) {
        if (state is NotificacionListadoUninitialized ||
            state is NotificacionListadoLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (state is NotificacionListadoSuccess &&
                state.notificaciones.isEmpty)
              Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  children: const [
                    Text(
                      'No hay oportunidades nuevas para tí, puedes configurar tus suscripciones para que te lleguen nuevas oportunidades.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                    // const SizedBox(height: 12),
                    // TextButton(
                    //   onPressed: _fetchFirst,
                    //   child: const Text('Reintentar'),
                    // ),
                  ],
                ),
              ),
            if (state is NotificacionListadoFailure)
              Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  children: [
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _refresh(context),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Configura tus suscripciones'),
              onPressed: () {
                BlocProvider.of<AuthenticatedNavigatorBloc>(context)
                    .add(const NotificacionesSettingsViewPushed());
              },
            ),
          ],
        );
      },
    );
  }
}
