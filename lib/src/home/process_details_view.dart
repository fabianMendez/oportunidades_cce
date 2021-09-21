import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/process_details.dart';
import 'package:oportunidades_cce/src/home/process_details_bloc.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class ProcessDetailsView extends StatelessWidget {
  const ProcessDetailsView({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      body: BlocProvider<ProcessDetailsBloc>(
        create: (context) {
          return ProcessDetailsBloc(
            id: id,
            userDetails: userDetails,
            grupoUNSPSCRepository: sl.get<GrupoUNSPSCRepository>(),
          )..add(const ProcessDetailsStarted());
        },
        child: const ProcessDetails(),
      ),
    );
  }
}
