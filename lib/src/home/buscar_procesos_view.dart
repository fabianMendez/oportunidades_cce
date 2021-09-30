import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/filtro_repository.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';
import 'package:oportunidades_cce/src/home/process_search.dart';
import 'package:oportunidades_cce/src/home/process_search_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/logout_button.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class BuscarProcesosView extends StatelessWidget {
  const BuscarProcesosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar procesos'),
        actions: const [LogoutButton()],
      ),
      body: BlocProvider<ProcessSearchBloc>(
        create: (context) {
          return ProcessSearchBloc(
            userDetails: userDetails,
            procesoRepository: sl.get<ProcesoRepository>(),
            filtroRepository: sl.get<FiltroRepository>(),
          )..add(const ProcessSearchStarted());
        },
        child: const ProcessSearch(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
