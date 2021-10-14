import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/authentication/unauthenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/authentication/widgets/text_link.dart';
import 'package:oportunidades_cce/src/home/widgets/submit_button.dart';
import 'package:provider/src/provider.dart';

class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: 128),
              const SizedBox(height: 12),
              Text(
                'OPORTUNIDADES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'CCE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              SubmitButton(
                child: const Text('Iniciar sesión'),
                onPressed: () {
                  context
                      .read<UnauthenticatedNavigatorBloc>()
                      .add(const LoginViewPushed());
                },
                width: null,
              ),
              const SizedBox(height: 12),
              TextLink(
                prefixText: 'No tengo una cuenta. ',
                linkText: 'Registrarme',
                onTap: () {
                  context
                      .read<UnauthenticatedNavigatorBloc>()
                      .add(const RegisterViewPushed());
                },
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
