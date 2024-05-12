import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/favorite_processes.dart';
import 'package:oportunidades_cce/src/home/favorite_processes_bloc.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class MisProcesosView extends StatefulWidget {
  const MisProcesosView({super.key});

  @override
  State<MisProcesosView> createState() => _MisProcesosViewState();
}

class _MisProcesosViewState extends State<MisProcesosView>
    with AutomaticKeepAliveClientMixin<MisProcesosView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      body: BlocProvider<FavoriteProcessesBloc>(
        create: (context) {
          return FavoriteProcessesBloc(
            userDetails: userDetails,
            procesoRepository: sl.get<ProcesoRepository>(),
          )..add(const FavoriteProcessesStarted());
        },
        child: const FavoriteProcesses(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  @override
  final bool wantKeepAlive = true;
}
