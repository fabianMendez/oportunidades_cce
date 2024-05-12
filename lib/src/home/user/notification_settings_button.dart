import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:provider/provider.dart';

class NotificationsSettingsButton extends StatelessWidget {
  const NotificationsSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Configurar suscripciones',
      onPressed: () {
        context
            .read<AuthenticatedNavigatorBloc>()
            .add(const NotificacionesSettingsViewPushed());
      },
    );
  }
}
