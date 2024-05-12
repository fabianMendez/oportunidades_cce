import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_bloc.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_monto_bloc.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';
import 'package:provider/provider.dart';

class NotificacionesSettingsMontoView extends StatelessWidget {
  const NotificacionesSettingsMontoView({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(kFiltroValores.actionMessage),
      ),
      body: BlocProvider<NotificacionesSettingsMontoBloc>(
        create: (context) {
          return NotificacionesSettingsMontoBloc(
            userDetails: userDetails,
            grupoUNSPSCRepository: sl.get<GrupoUNSPSCRepository>(),
          )..add(const NotificacionesSettingsMontoStarted());
        },
        child: const NotificacionesSettingsMontoListener(
          child: NotificacionesSettingsMonto(),
        ),
      ),
    );
  }
}

class NotificacionesSettingsMonto extends StatefulWidget {
  const NotificacionesSettingsMonto({
    super.key,
    this.contentPadding = const EdgeInsets.all(16),
  });

  final EdgeInsets contentPadding;

  @override
  State<NotificacionesSettingsMonto> createState() =>
      _NotificacionesSettingsMontoState();
}

class _NotificacionesSettingsMontoState
    extends State<NotificacionesSettingsMonto> {
  String montoInferior = '';
  String montoSuperior = '';

  Future<void> _submit(BuildContext context) async {
    BlocProvider.of<NotificacionesSettingsMontoBloc>(context).add(
      NotificacionesSettingsMontoSubmitted(
        montoInferior: montoInferior,
        montoSuperior: montoSuperior,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionesSettingsMontoBloc,
        NotificacionesSettingsMontoState>(
      builder: (context, state) {
        final isLoading = state is NotificacionesSettingsMontoLoading;

        return Padding(
          padding: widget.contentPadding,
          child: Column(
            children: [
              TextField(
                enabled: !isLoading,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Monto inferior'),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    montoInferior = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                enabled: !isLoading,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Monto superior'),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    montoSuperior = value;
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

class NotificacionesSettingsMontoListener extends StatelessWidget {
  const NotificacionesSettingsMontoListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificacionesSettingsMontoBloc,
        NotificacionesSettingsMontoState>(
      listener:
          (BuildContext context, NotificacionesSettingsMontoState state) async {
        if (state is NotificacionesSettingsMontoFailure) {
          showMessage(
            context,
            title: 'Error al insertar filtro',
            message: state.error,
          );
        } else if (state is NotificacionesSettingsMontoSuccess) {
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
