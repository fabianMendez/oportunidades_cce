import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/unauthenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/authentication/widgets/password_field.dart';
import 'package:oportunidades_cce/src/authentication/widgets/text_link.dart';
import 'package:oportunidades_cce/src/home/widgets/submit_button.dart';
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
        child: const LoginListener(child: LoginForm()),
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

  late LoginBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<LoginBloc>();
  }

  Future<void> _submit() async {
    _bloc.add(
      LoginSubmitted(
        username: username,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

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
                      TextField(
                        autofocus: true,
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
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      PasswordField(
                        enabled: !isLoading,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        onSubmitted: (_) => _submit(),
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextLink(
                          prefixText: '',
                          linkText: 'Olvidé mi contraseña',
                          onTap: () {
                            context
                                .read<UnauthenticatedNavigatorBloc>()
                                .add(const ForgotPasswordViewPushed());
                          },
                        ),
                      )
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
                  child: const Text('INGRESAR'),
                ),
              ),
            ),
          ],
        );
      },
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
