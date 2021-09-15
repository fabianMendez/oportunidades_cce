import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/home/home_view.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_filtro_bienes_servicios_view.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_view.dart';

class AuthenticatedNavigator extends StatelessWidget {
  const AuthenticatedNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticatedNavigatorBloc, AuthenticatedNavigatorState>(
      builder: (context, state) {
        return Navigator(
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            BlocProvider.of<AuthenticatedNavigatorBloc>(context)
                .add(const AuthenticatedNavigatorPopped());

            return true;
          },
          pages: [
            const MaterialPage(child: HomeView()),
            if (state.isNotificacionesSettings)
              const MaterialPage(child: NotificacionesSettingsView()),
            if (state.isNotificacionesSettingsFiltroBienesServicios)
              const MaterialPage(
                child: NotificacionesSettingsFiltroBienesServiciosView(),
              ),
          ],
        );
      },
    );
  }
}
