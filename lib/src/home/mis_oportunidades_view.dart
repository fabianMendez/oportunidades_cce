import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/notificacion_listado_view.dart';
import 'package:oportunidades_cce/src/home/user/app_menu_button.dart';
import 'package:oportunidades_cce/src/home/user/notification_settings_button.dart';

class MisOportunidadesView extends StatelessWidget {
  const MisOportunidadesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis oportunidades'),
        actions: const [
          NotificationsSettingsButton(),
          AppMenuButton(),
        ],
      ),
      body: const NotificacionListadoView(),
      primary: true,
    );
  }
}
