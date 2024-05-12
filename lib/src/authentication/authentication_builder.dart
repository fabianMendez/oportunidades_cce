import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/loading_view.dart';
import 'package:oportunidades_cce/src/authentication/splash_view.dart';
import 'package:oportunidades_cce/src/authentication/unauthenticated_navigator.dart';
import 'package:provider/provider.dart';

class AuthenticationBuilder extends StatelessWidget {
  const AuthenticationBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationUninitialized) {
          return const SplashView();
        }

        if (state is AuthenticationUnauthenticated) {
          return const UnauthenticatedNavigator();
        }

        if (state is AuthenticationSuccessful) {
          return Provider.value(
            value: state.userDetails,
            child: BlocProvider<AuthenticatedNavigatorBloc>(
              create: (_) {
                return AuthenticatedNavigatorBloc();
              },
              child: const AuthenticatedNavigator(),
            ),
          );
        }

        assert(state is AuthenticationLoading);
        return const LoadingView();
      },
    );
  }
}
