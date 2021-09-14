import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/authentication/forgot_password_view.dart';
import 'package:oportunidades_cce/src/authentication/login_view.dart';
import 'package:oportunidades_cce/src/authentication/register_view.dart';

import '../sample_feature/sample_item_list_view.dart';
import 'reactivate_account_view.dart';
import 'remove_account_view.dart';

class UnauthenticatedNavigator extends StatefulWidget {
  const UnauthenticatedNavigator({
    Key? key,
  }) : super(key: key);

  @override
  State<UnauthenticatedNavigator> createState() =>
      _UnauthenticatedNavigatorState();
}

class _UnauthenticatedNavigatorState extends State<UnauthenticatedNavigator> {
  String routeName = SampleItemListView.routeName;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        setState(() {
          routeName = SampleItemListView.routeName;
        });

        return true;
      },
      pages: [
        MaterialPage(
          child: SampleItemListView(
            onRouteChanged: (newRoute) {
              setState(() {
                routeName = newRoute;
              });
            },
          ),
        ),
        if (routeName == LoginView.routeName)
          const MaterialPage(child: LoginView()),
        if (routeName == RegisterView.routeName)
          const MaterialPage(child: RegisterView()),
        if (routeName == ForgotPasswordView.routeName)
          const MaterialPage(child: ForgotPasswordView()),
        if (routeName == ReactivateAccountView.routeName)
          const MaterialPage(child: ReactivateAccountView()),
        if (routeName == RemoveAccountView.routeName)
          const MaterialPage(child: RemoveAccountView()),
        // if (routeName == SettingsView.routeName)
        //   MaterialPage(
        //       child: SettingsView(controller: widget.settingsController)),
      ],
    );
  }
}
