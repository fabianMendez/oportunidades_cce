import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/home/widgets/submit_button.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';

import 'forgot_password_bloc.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

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
        child: const ForgotPasswordForm(),
      ),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String email = '';

  late ForgotPasswordBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<ForgotPasswordBloc>();
  }

  Future<void> _submit() async {
    _bloc.add(ForgotPasswordSubmitted(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordListener(
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;

          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Padding(
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
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SubmitButton(
                    onPressed: _submit,
                    isLoading: isLoading,
                    child: const Text('RECUPERAR'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ForgotPasswordListener extends StatelessWidget {
  const ForgotPasswordListener({
    super.key,
    required this.child,
  });

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
