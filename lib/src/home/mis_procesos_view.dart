import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/favorite_processes.dart';
import 'package:oportunidades_cce/src/home/favorite_processes_bloc.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/widgets/logout_button.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class MisProcesosView extends StatelessWidget {
  const MisProcesosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis procesos'),
        actions: const [LogoutButton()],
      ),
      body: BlocProvider<FavoriteProcessesBloc>(
        create: (context) {
          return FavoriteProcessesBloc(
            userDetails: userDetails,
            grupoUNSPSCRepository: sl.get<GrupoUNSPSCRepository>(),
          )..add(const FavoriteProcessesStarted());
        },
        child: const FavoriteProcesses(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
