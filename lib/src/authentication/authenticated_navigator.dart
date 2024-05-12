import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/home/entity_details_view.dart';
import 'package:oportunidades_cce/src/home/home_view.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_filtro_bienes_servicios_view.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_keyword_view.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_monto_view.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_view.dart';
import 'package:oportunidades_cce/src/home/process_details_view.dart';
import 'package:oportunidades_cce/src/home/user/user_information_view.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class AuthenticatedNavigator extends StatelessWidget {
  const AuthenticatedNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
      child:
          BlocBuilder<AuthenticatedNavigatorBloc, AuthenticatedNavigatorState>(
        builder: (context, state) {
          return Navigator(
            key: _navigatorKey,
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }

              BlocProvider.of<AuthenticatedNavigatorBloc>(context)
                  .add(AuthenticatedNavigatorPopped(result: result));

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
              if (state.isNotificacionesSettingsMonto)
                const MaterialPage(child: NotificacionesSettingsMontoView()),
              if (state.isNotificacionesSettingsKeyword)
                const MaterialPage(child: NotificacionesSettingsKeywordView()),
              if (state.isEntityDetails)
                MaterialPage(
                  child: EntityDetailsView(
                    id: state.entityDetailsId,
                  ),
                ),
              if (state.isProcessDetails)
                MaterialPage(
                  child: ProcessDetailsView(
                    id: state.processDetailsId,
                  ),
                ),
              if (state.isUserInformation)
                const MaterialPage(child: UserInformationView()),
            ],
          );
        },
      ),
    );
  }
}
