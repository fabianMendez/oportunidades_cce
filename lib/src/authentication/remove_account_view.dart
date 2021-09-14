import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';

import 'remove_account_bloc.dart';

class RemoveAccountView extends StatelessWidget {
  const RemoveAccountView({Key? key}) : super(key: key);

  static const routeName = '/auth/remove_account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eliminar cuenta'),
      ),
      body: BlocProvider<RemoveAccountBloc>(
        create: (_) => RemoveAccountBloc(
          usuarioRepository: sl.get<UsuarioRepository>(),
        ),
        child: const SingleChildScrollView(child: RemoveAccountForm()),
      ),
    );
  }
}

class RemoveAccountForm extends StatefulWidget {
  const RemoveAccountForm({Key? key}) : super(key: key);

  @override
  State<RemoveAccountForm> createState() => _RemoveAccountFormState();
}

class _RemoveAccountFormState extends State<RemoveAccountForm> {
  String email = '';

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();

    BlocProvider.of<RemoveAccountBloc>(context).add(
      RemoveAccountSubmitted(
        email: email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RemoveAccountListener(
      child: BlocBuilder<RemoveAccountBloc, RemoveAccountState>(
        builder: (context, state) {
          final isLoading = state is RemoveAccountLoading;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Eliminar cuenta',
                    style: TextStyle(
                      fontSize: 24,
                      height: 1.25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Escribe tu correo y te enviaremos las instrucciones para finalizar este proceso',
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

class RemoveAccountListener extends StatelessWidget {
  const RemoveAccountListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoveAccountBloc, RemoveAccountState>(
      listener: (BuildContext context, RemoveAccountState state) async {
        if (state is RemoveAccountFailure) {
          showMessage(
            context,
            title: 'Error al eliminar cuenta',
            message: state.error,
          );
        }

        if (state is RemoveAccountSuccess) {
          await showMessage(
            context,
            title: 'Cuenta eliminada exitosamente',
            message:
                'Pronto te llegará un correo para que elimines la cuenta, es posible que el correo llegue a la bandeja de spam.',
          );

          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
