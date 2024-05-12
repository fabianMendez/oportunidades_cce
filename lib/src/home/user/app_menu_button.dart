import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:provider/provider.dart';

enum _AppMenuOption { userInfo, logout }

class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_AppMenuOption>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_AppMenuOption>>[
        const PopupMenuItem<_AppMenuOption>(
          value: _AppMenuOption.userInfo,
          child: Text('Actualizar perfil'),
        ),
        const PopupMenuItem<_AppMenuOption>(
          value: _AppMenuOption.logout,
          child: Text('Cerrar sesión'),
        ),
      ],
      tooltip: 'Más opciones',
      onSelected: (_AppMenuOption result) {
        switch (result) {
          case _AppMenuOption.logout:
            context.read<AuthenticationBloc>().add(const LoggedOut());
            break;
          case _AppMenuOption.userInfo:
            context
                .read<AuthenticatedNavigatorBloc>()
                .add(const UserInformationPushed());
            break;
        }
      },
    );
    // return IconButton(
    //   icon: const Icon(Icons.more_vert),
    //   onPressed: () {
    //     context
    //         .read<AuthenticatedNavigatorBloc>()
    //         .add(const UserInformationPushed());
    //   },
    //   tooltip: 'Salir',
    // );
    // return IconButton(
    //   icon: const Icon(Icons.account_circle),
    //   onPressed: () {
    //     context
    //         .read<AuthenticatedNavigatorBloc>()
    //         .add(const UserInformationPushed());
    //   },
    //   tooltip: 'Salir',
    // );
  }
}
