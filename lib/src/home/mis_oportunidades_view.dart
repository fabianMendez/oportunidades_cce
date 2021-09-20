import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/notificacion_listado_view.dart';
import 'package:oportunidades_cce/src/home/widgets/logout_button.dart';

class MisOportunidadesView extends StatelessWidget {
  const MisOportunidadesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis oportunidades'),
        actions: const [LogoutButton()],
      ),
      body: const NotificacionListadoView(),
      primary: true,
    );
  }
}
