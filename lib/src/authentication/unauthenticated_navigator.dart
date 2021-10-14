import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/forgot_password_view.dart';
import 'package:oportunidades_cce/src/authentication/login_view.dart';
import 'package:oportunidades_cce/src/authentication/register_view.dart';
import 'package:oportunidades_cce/src/authentication/unauthenticated_navigator_bloc.dart';
import 'package:provider/src/provider.dart';

import '../sample_feature/sample_item_list_view.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

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
    return BlocProvider(
      create: (context) => UnauthenticatedNavigatorBloc(),
      child: WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
        child: BlocBuilder<UnauthenticatedNavigatorBloc,
            UnauthenticatedNavigatorState>(
          builder: (context, state) {
            return Navigator(
              key: _navigatorKey,
              onPopPage: (route, result) {
                if (!route.didPop(result)) {
                  return false;
                }

                context
                    .read<UnauthenticatedNavigatorBloc>()
                    .add(const UnauthenticatedNavigatorPopped());

                return true;
              },
              pages: [
                const MaterialPage(child: SampleItemListView()),
                if (state.isLoginView) const MaterialPage(child: LoginView()),
                if (state.isRegisterView)
                  const MaterialPage(child: RegisterView()),
                if (state.isForgotPasswordView)
                  const MaterialPage(child: ForgotPasswordView()),

                // if (routeName == ReactivateAccountView.routeName)
                //   const MaterialPage(child: ReactivateAccountView()),
                // if (routeName == RemoveAccountView.routeName)
                //   const MaterialPage(child: RemoveAccountView()),
                // if (routeName == SettingsView.routeName)
                //   MaterialPage(
                //       child: SettingsView(controller: widget.settingsController)),
              ],
            );
          },
        ),
      ),
    );
  }
}
