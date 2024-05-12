import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/authentication/widgets/checkbox_link_field.dart';
import 'package:oportunidades_cce/src/home/user/user_information_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/submit_button.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';
import 'package:oportunidades_cce/src/widgets/xtext_field.dart';
import 'package:provider/provider.dart';

class UserInformationView extends StatelessWidget {
  const UserInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: BlocProvider<UserInformationBloc>(
        create: (context) => UserInformationBloc(
          userDetails: userDetails,
          usuarioRepository: sl.get<UsuarioRepository>(),
          authenticationBloc: context.read<AuthenticationBloc>(),
        ),
        child: const SafeArea(
          child: UserInformationListener(
            child: UserInformationForm(),
          ),
        ),
      ),
    );
  }
}

class UserInformationForm extends StatefulWidget {
  const UserInformationForm({super.key});

  @override
  State<UserInformationForm> createState() => _UserInformationFormState();
}

class _UserInformationFormState extends State<UserInformationForm> {
  String firstName = '';
  String lastName = '';
  bool receiveNotifications = false;

  late UserInformationBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = context.read<UserInformationBloc>();

    final usuario = bloc.state.userDetails.usuario;
    firstName = usuario.nombres;
    lastName = usuario.apellidos;
    receiveNotifications = usuario.enviarCorreo;
  }

  Future<void> _update() async {
    bloc.add(
      UserInformationUpdated(
        firstName: firstName,
        lastName: lastName,
        receiveNotifications: receiveNotifications,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInformationBloc, UserInformationState>(
      builder: (context, state) {
        final usuario = state.userDetails.usuario;
        final isLoading = state is UserInformationLoading;

        return Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // const Text(
                      //   'Información',
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // const SizedBox(height: 24),
                      XTextField(
                        enabled: !isLoading,
                        label: 'Nombres',
                        onChanged: (value) {
                          setState(() {
                            firstName = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        value: firstName,
                      ),
                      const SizedBox(height: 12),
                      XTextField(
                        enabled: !isLoading,
                        label: 'Apellidos',
                        onChanged: (value) {
                          setState(() {
                            lastName = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        value: lastName,
                      ),
                      const SizedBox(height: 12),
                      XTextField(
                        enabled: false,
                        autocorrect: false,
                        label: 'Correo',
                        onChanged: (_) {},
                        value: usuario.correo,
                      ),
                      const SizedBox(height: 12),
                      CheckboxField(
                        enabled: !isLoading,
                        value: receiveNotifications,
                        onChanged: (value) {
                          setState(() {
                            receiveNotifications = value;
                          });
                        },
                        child: const Text('Recibir notificaciones'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SubmitButton(onPressed: _update, isLoading: isLoading),
              ),
            ),
          ],
        );
      },
    );
  }
}

class UserInformationListener extends StatelessWidget {
  const UserInformationListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInformationBloc, UserInformationState>(
      listener: (context, state) {
        if (state is UserInformationFailure) {
          showMessage(context, title: 'Error', message: state.error);
        } else if (state is UserInformationSuccess) {
          final messenger = ScaffoldMessenger.of(context);

          messenger.clearMaterialBanners();

          messenger.showMaterialBanner(MaterialBanner(
            content: const Text('Información actualizada'),
            actions: [
              TextButton(
                child: const Text('ACEPTAR'),
                onPressed: () {
                  messenger.clearMaterialBanners();
                },
              ),
            ],
            onVisible: () {
              Future.delayed(const Duration(milliseconds: 1000)).then((value) {
                messenger.clearMaterialBanners();
              });
            },
          ));
        }
      },
      child: child,
    );
  }
}
