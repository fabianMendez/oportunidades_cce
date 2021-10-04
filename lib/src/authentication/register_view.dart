import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/authentication/widgets/checkbox_link_field.dart';
import 'package:oportunidades_cce/src/authentication/widgets/password_field.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';

import 'register_bloc.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  static const routeName = '/auth/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: BlocProvider<RegisterBloc>(
        create: (_) => RegisterBloc(
          usuarioRepository: sl.get<UsuarioRepository>(),
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
        ),
        child: const SingleChildScrollView(child: RegisterForm()),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  bool termsAndConditions = false;
  bool privacyPolicy = false;
  bool obscurePassword = true;

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();

    BlocProvider.of<RegisterBloc>(context).add(
      RegisterSubmitted(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        privacyPolicy: privacyPolicy,
        termsAndConditions: termsAndConditions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegisterListener(
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  enabled: !isLoading,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    label: Text('Nombres'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      firstName = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  enabled: !isLoading,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    label: Text('Apellidos'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      lastName = value;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
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
                ),
                const SizedBox(height: 12),
                PasswordField(
                  enabled: !isLoading,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                CheckboxLinkField(
                  prefixText: 'He leído y acepto los ',
                  linkText: 'Términos y condiciones',
                  value: termsAndConditions,
                  onChanged: (_) {
                    setState(() {
                      termsAndConditions = !termsAndConditions;
                    });
                  },
                ),
                CheckboxLinkField(
                  prefixText: 'Autorizo el ',
                  linkText: 'tratamiento de mis datos personales',
                  value: privacyPolicy,
                  onChanged: (_) {
                    setState(() {
                      privacyPolicy = !privacyPolicy;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Crear'),
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

class RegisterListener extends StatelessWidget {
  const RegisterListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (BuildContext context, RegisterState state) async {
        if (state is RegisterFailure) {
          showMessage(
            context,
            title: 'Error al crear cuenta',
            message: state.error,
          );
        }

        if (state is RegisterSuccess) {
          await showMessage(
            context,
            title: 'Cuenta creada exitosamente',
            message:
                'Pronto te llegará un correo para actives la cuenta, es posible que el correo llegue a la bandeja de spam.',
          );
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
