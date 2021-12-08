import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oportunidades_cce/src/home/blocs/html_text_bloc.dart';
import 'package:oportunidades_cce/src/home/texto_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

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
        child: const TermsAndConditions(),
      ),
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HTMLTextBloc, HTMLTextState>(
      builder: (context, state) {
        if (state is HTMLTextReady) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: Html(
                data: state.data,
                onAnchorTap: (urlString, _, __, ___) {
                  if (urlString != null) {
                    launch(urlString);
                  }
                },
                onLinkTap: (urlString, _, __, ___) {
                  if (urlString != null) {
                    launch(urlString);
                  }
                },
              ),
            ),
          );
        }
        if (state is HTMLTextFailure) {
          return Center(
            child: Text(state.error),
          );
        }

        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
