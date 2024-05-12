import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';

import 'reactivate_account_bloc.dart';

class ReactivateAccountView extends StatelessWidget {
  const ReactivateAccountView({super.key});

  static const routeName = '/auth/reactivate_account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactivar cuenta'),
      ),
      body: BlocProvider<ReactivateAccountBloc>(
        create: (_) => ReactivateAccountBloc(
          usuarioRepository: sl.get<UsuarioRepository>(),
        ),
        child: const SingleChildScrollView(child: ReactivateAccountForm()),
      ),
    );
  }
}

class ReactivateAccountForm extends StatefulWidget {
  const ReactivateAccountForm({super.key});

  @override
  State<ReactivateAccountForm> createState() => _ReactivateAccountFormState();
}

class _ReactivateAccountFormState extends State<ReactivateAccountForm> {
  String email = '';

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();

    BlocProvider.of<ReactivateAccountBloc>(context).add(
      ReactivateAccountSubmitted(
        email: email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReactivateAccountListener(
      child: BlocBuilder<ReactivateAccountBloc, ReactivateAccountState>(
        builder: (context, state) {
          final isLoading = state is ReactivateAccountLoading;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Escribe tu correo y te enviaremos las instrucciones para reactivar tu cuenta',
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
                  onPressed: isLoading ? null : () => _submit(context),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Recuperar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ReactivateAccountListener extends StatelessWidget {
  const ReactivateAccountListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReactivateAccountBloc, ReactivateAccountState>(
      listener: (BuildContext context, ReactivateAccountState state) async {
        if (state is ReactivateAccountFailure) {
          showMessage(
            context,
            title: 'Error al reactivar cuenta',
            message: state.error,
          );
        }

        if (state is ReactivateAccountSuccess) {
          await showMessage(
            context,
            title: 'Cuenta reactivada exitosamente',
            message:
                'Pronto te llegará un correo para que actives la cuenta, es posible que el correo llegue a la bandeja de spam.',
          );

          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
