import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';

import 'login_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  static const routeName = '/auth/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
      ),
      body: BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(
          usuarioRepository: sl.get<UsuarioRepository>(),
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ),
        child: const SingleChildScrollView(child: LoginForm()),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String username = '';
  String password = '';

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();

    BlocProvider.of<LoginBloc>(context).add(
      LoginSubmitted(
        username: username,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginListener(
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  enabled: !isLoading,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    label: Text('Correo'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  enabled: !isLoading,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Contraseña'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Ingresar'),
                  onPressed: isLoading ? null : () => _submit(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LoginListener extends StatelessWidget {
  const LoginListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state is LoginFailure) {
          showMessage(
            context,
            title: 'Error de inicio de sesion',
            message: state.error,
          );
        }
      },
      child: child,
    );
  }
}
