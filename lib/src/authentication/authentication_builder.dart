import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/loading_view.dart';
import 'package:oportunidades_cce/src/authentication/login_view.dart';
import 'package:oportunidades_cce/src/authentication/splash_view.dart';
import 'package:oportunidades_cce/src/home/home_view.dart';
import 'package:provider/provider.dart';

class AuthenticationBuilder extends StatelessWidget {
  const AuthenticationBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationUninitialized) {
          return const SplashView();
        }

        if (state is AuthenticationUnauthenticated) {
          return const LoginView();
        }

        if (state is AuthenticationSuccessful) {
          return Provider.value(
            value: state.userDetails,
            child: const HomeView(),
          );
        }

        assert(state is AuthenticationLoading);
        return const LoadingView();
      },
    );
  }
}
