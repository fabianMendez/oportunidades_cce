import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionListadoBloc, NotificacionListadoState>(
      builder: (context, state) {
        if (state is NotificacionListadoUninitialized) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state is NotificacionListadoSuccess) {
          if (state.notificaciones.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.settings),
                  label: const Text('Configura tus suscripciones'),
                  onPressed: () {},
                ),
              ],
            );
          }
        }

        return Container();
      },
    );
  }
}
