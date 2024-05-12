import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_bloc.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_keyword_bloc.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';
import 'package:provider/provider.dart';

class NotificacionesSettingsKeywordView extends StatelessWidget {
  const NotificacionesSettingsKeywordView({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(kFiltroPalabrasClave.actionMessage),
      ),
      body: BlocProvider<NotificacionesSettingsKeywordBloc>(
        create: (context) {
          return NotificacionesSettingsKeywordBloc(
            userDetails: userDetails,
            grupoUNSPSCRepository: sl.get<GrupoUNSPSCRepository>(),
          )..add(const NotificacionesSettingsKeywordStarted());
        },
        child: const NotificacionesSettingsKeywordListener(
          child: NotificacionesSettingsKeyword(),
        ),
      ),
    );
  }
}

class NotificacionesSettingsKeyword extends StatefulWidget {
  const NotificacionesSettingsKeyword({
    super.key,
    this.contentPadding = const EdgeInsets.all(16),
  });

  final EdgeInsets contentPadding;

  @override
  State<NotificacionesSettingsKeyword> createState() =>
      _NotificacionesSettingsKeywordState();
}

class _NotificacionesSettingsKeywordState
    extends State<NotificacionesSettingsKeyword> {
  String texto = '';

  Future<void> _submit(BuildContext context) async {
    BlocProvider.of<NotificacionesSettingsKeywordBloc>(context).add(
      NotificacionesSettingsKeywordSubmitted(texto: texto),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionesSettingsKeywordBloc,
        NotificacionesSettingsKeywordState>(
      builder: (context, state) {
        final isLoading = state is NotificacionesSettingsKeywordLoading;

        return Padding(
          padding: widget.contentPadding,
          child: Column(
            children: [
              TextField(
                enabled: !isLoading,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Texto'),
                ),
                onChanged: (value) {
                  setState(() {
                    texto = value;
                  });
                },
                onSubmitted: (_) => _submit(context),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading ? null : () => _submit(context),
                child: isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Insertar'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotificacionesSettingsKeywordListener extends StatelessWidget {
  const NotificacionesSettingsKeywordListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificacionesSettingsKeywordBloc,
        NotificacionesSettingsKeywordState>(
      listener: (BuildContext context,
          NotificacionesSettingsKeywordState state) async {
        if (state is NotificacionesSettingsKeywordFailure) {
          showMessage(
            context,
            title: 'Error al insertar filtro',
            message: state.error,
          );
        } else if (state is NotificacionesSettingsKeywordSuccess) {
          await showMessage(
            context,
            title: 'Filtro insertado',
            message: 'Inserción exitosa',
          );
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
