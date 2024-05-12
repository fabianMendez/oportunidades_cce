import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:oportunidades_cce/src/home/blocs/html_text_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HTMLTextView extends StatelessWidget {
  const HTMLTextView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HTMLTextBloc, HTMLTextState>(
      builder: (context, state) {
        if (state is HTMLTextReady) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: /*
Html(
                data: '''
                <style>
                html, body {
                  font-size: 1.2rem;
                }
                </style>
                ${state.data}
                ''',
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
              )
              */
                  Text(state.data),
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
