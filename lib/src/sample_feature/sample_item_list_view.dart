import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/authentication/forgot_password_view.dart';
import 'package:oportunidades_cce/src/authentication/login_view.dart';
import 'package:oportunidades_cce/src/authentication/reactivate_account_view.dart';
import 'package:oportunidades_cce/src/authentication/register_view.dart';
import 'package:oportunidades_cce/src/authentication/remove_account_view.dart';

import '../settings/settings_view.dart';

class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    Key? key,
    required this.onRouteChanged,
  }) : super(key: key);

  static const routeName = '/';
  final ValueChanged<String> onRouteChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oportunidades CCE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              onRouteChanged(SettingsView.routeName);
            },
          ),
        ],
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
              // Navigate to the details page. If the user leaves and returns to
              // the app after it has been killed while running in the
              // background, the navigation stack is restored.
              onRouteChanged(LoginView.routeName);
            },
          ),
          ListTile(
            title: const Text('Crear cuenta'),
            leading: const Icon(Icons.app_registration),
            onTap: () {
              onRouteChanged(RegisterView.routeName);
            },
          ),
          ListTile(
            title: const Text('¿Olvidaste tu contraseña?'),
            leading: const Icon(Icons.password),
            onTap: () {
              onRouteChanged(ForgotPasswordView.routeName);
            },
          ),
          ListTile(
            title: const Text('Reactivar cuenta'),
            leading: const Icon(Icons.account_box),
            onTap: () {
              onRouteChanged(ReactivateAccountView.routeName);
            },
          ),
          ListTile(
            title: const Text('Eliminar cuenta'),
            leading: const Icon(Icons.delete_forever),
            onTap: () {
              onRouteChanged(RemoveAccountView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
