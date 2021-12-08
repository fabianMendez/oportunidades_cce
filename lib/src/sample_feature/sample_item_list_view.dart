import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oportunidades_cce/src/authentication/unauthenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/authentication/widgets/text_link.dart';
import 'package:oportunidades_cce/src/home/widgets/submit_button.dart';
import 'package:provider/provider.dart';

class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    const lightRed = 'ff5555';
    const red = 'ff2a2a';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return SvgPicture.string(
                  '''
<svg version="1.1" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
    <path d="m370.99 273.88c-25.281 93.454-111.87 151.33-111.87 151.33s-45.605-93.641-20.324-187.09c25.281-93.454 111.87-151.33 111.87-151.33s45.605 93.641 20.324 187.09z" fill="#$lightRed"/>
    <path d="m141.01 273.88c25.281 93.454 111.87 151.33 111.87 151.33s45.605-93.641 20.324-187.09c-25.281-93.454-111.87-151.33-111.87-151.33s-45.605 93.641-20.324 187.09z" fill="#$lightRed"/>
    <path d="m316.38 270.08c-0.20449 85.739-60.75 155.1-60.75 155.1s-60.218-69.651-60.012-155.39c0.20449-85.739 60.75-155.1 60.75-155.1s60.218 69.651 60.012 155.39z" fill="#$red" />
    <path d="m178.16 253.8c69.372 67.531 77.845 171.34 77.845 171.34s-104-5.678-173.37-73.209c-69.372-67.531-77.845-171.34-77.845-171.34s104 5.678 173.37 73.209z" fill="currentColor"/>
    <path d="m333.84 253.8c-69.372 67.531-77.845 171.34-77.845 171.34s104-5.678 173.37-73.209c69.372-67.531 77.845-171.34 77.845-171.34s-104 5.678-173.37 73.209z" fill="currentColor"/>
</svg>
                  ''',
                  width: constraints.maxWidth * 0.7,
                  currentColor: Theme.of(context).primaryColor,
                );
              }),
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
                'COL',
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
