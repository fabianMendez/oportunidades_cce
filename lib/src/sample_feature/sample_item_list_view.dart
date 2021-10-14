import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/authentication/unauthenticated_navigator_bloc.dart';
import 'package:provider/src/provider.dart';

class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oportunidades CCE'),
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        children: [
          ListTile(
            title: const Text('Iniciar sesión'),
            leading: const Icon(Icons.login),
            onTap: () {
              context
                  .read<UnauthenticatedNavigatorBloc>()
                  .add(const LoginViewPushed());
            },
          ),
          ListTile(
            title: const Text('Crear cuenta'),
            leading: const Icon(Icons.app_registration),
            onTap: () {
              context
                  .read<UnauthenticatedNavigatorBloc>()
                  .add(const RegisterViewPushed());
            },
          ),
          ListTile(
            title: const Text('¿Olvidaste tu contraseña?'),
            leading: const Icon(Icons.password),
            onTap: () {
              context
                  .read<UnauthenticatedNavigatorBloc>()
                  .add(const ForgotPasswordViewPushed());
            },
          ),
          ListTile(
            title: const Text('Reactivar cuenta'),
            leading: const Icon(Icons.account_box),
            onTap: () {
              // onRouteChanged(ReactivateAccountView.routeName);
            },
          ),
          ListTile(
            title: const Text('Eliminar cuenta'),
            leading: const Icon(Icons.delete_forever),
            onTap: () {
              // onRouteChanged(RemoveAccountView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
