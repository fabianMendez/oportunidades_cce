import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/filtro_repository.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';
import 'package:oportunidades_cce/src/home/process_search.dart';
import 'package:oportunidades_cce/src/home/process_search_bloc.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class BuscarProcesosView extends StatefulWidget {
  const BuscarProcesosView({Key? key}) : super(key: key);

  @override
  State<BuscarProcesosView> createState() => _BuscarProcesosViewState();
}

class _BuscarProcesosViewState extends State<BuscarProcesosView>
    with AutomaticKeepAliveClientMixin<BuscarProcesosView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final userDetails = Provider.of<UserDetails>(context);

    return BlocProvider<ProcessSearchBloc>(
      create: (context) {
        return ProcessSearchBloc(
          userDetails: userDetails,
          procesoRepository: sl.get<ProcesoRepository>(),
          filtroRepository: sl.get<FiltroRepository>(),
        )..add(const ProcessSearchStarted());
      },
      child: const ProcessSearch(),
    );
  }

  @override
  final bool wantKeepAlive = true;
}
