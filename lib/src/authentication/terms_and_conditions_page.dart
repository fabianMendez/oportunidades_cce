import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/home/blocs/html_text_bloc.dart';
import 'package:oportunidades_cce/src/home/texto_repository.dart';
import 'package:oportunidades_cce/src/home/widgets/html_text_view.dart';
import 'package:oportunidades_cce/src/service_locator.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y condiciones'),
      ),
      body: BlocProvider<HTMLTextBloc>(
        create: (BuildContext context) {
          return HTMLTextBloc(
            textCode: 'terminosCondiciones',
            textoRepository: sl.get<TextoRepository>(),
          )..add(const HTMLTextStarted());
        },
        child: const HTMLTextView(),
      ),
    );
  }
}
