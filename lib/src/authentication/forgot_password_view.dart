import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';

import 'forgot_password_bloc.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  static const routeName = '/auth/forgot_password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar la contraseña'),
      ),
      body: BlocProvider<ForgotPasswordBloc>(
        create: (_) => ForgotPasswordBloc(
          usuarioRepository: sl.get<UsuarioRepository>(),
        ),
        child: const SingleChildScrollView(child: ForgotPasswordForm()),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String email = '';

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();

    BlocProvider.of<ForgotPasswordBloc>(context).add(
      ForgotPasswordSubmitted(
        email: email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordListener(
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Escribe tu correo y te enviaremos las instrucciones para recuperar tu contraseña',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  enabled: !isLoading,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    label: Text('Correo'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Recuperar'),
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

class ForgotPasswordListener extends StatelessWidget {
  const ForgotPasswordListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (BuildContext context, ForgotPasswordState state) async {
        if (state is ForgotPasswordFailure) {
          showMessage(
            context,
            title: 'Error al restaurar contraseña',
            message: state.error,
          );
        }

        if (state is ForgotPasswordSuccess) {
          await showMessage(
            context,
            title: 'Contraseña restaurada exitosamente',
            message:
                'Pronto te llegará un correo para seguir el proceso de restauración de tu contraseña, es posible que el correo llegue a la bandeja de spam.',
          );

          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
