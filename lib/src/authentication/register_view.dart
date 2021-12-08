import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/privacy_policy_page.dart';
import 'package:oportunidades_cce/src/authentication/terms_and_conditions_page.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/authentication/widgets/checkbox_link_field.dart';
import 'package:oportunidades_cce/src/authentication/widgets/password_field.dart';
import 'package:oportunidades_cce/src/authentication/widgets/text_link.dart';
import 'package:oportunidades_cce/src/home/widgets/submit_button.dart';
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
        child: const RegisterListener(
          child: RegisterForm(),
        ),
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

  late RegisterBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<RegisterBloc>();
  }

  Future<void> _submit() async {
    _bloc.add(
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
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        final isLoading = state is RegisterLoading;

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
                    children: [
                      TextField(
                        autofocus: true,
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
                      CheckboxField(
                        child: TextLink(
                          prefixText: 'He leído y acepto los ',
                          linkText: 'términos y condiciones',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return const TermsAndConditionsPage();
                                },
                              ),
                            );
                          },
                        ),
                        value: termsAndConditions,
                        onChanged: (_) {
                          setState(() {
                            termsAndConditions = !termsAndConditions;
                          });
                        },
                      ),
                      CheckboxField(
                        child: TextLink(
                          prefixText: 'Autorizo el ',
                          linkText: 'tratamiento de mis datos personales',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return const PrivacyPolicyPage();
                                },
                              ),
                            );
                          },
                        ),
                        value: privacyPolicy,
                        onChanged: (_) {
                          setState(() {
                            privacyPolicy = !privacyPolicy;
                          });
                        },
                      ),
                      const SizedBox(height: 48 + 16 * 2),
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
                ),
              ),
            ),
          ],
        );
      },
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
