import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entity_details.dart';
import 'package:oportunidades_cce/src/home/entity_details_bloc.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class EntityDetailsView extends StatelessWidget {
  const EntityDetailsView({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      body: BlocProvider<EntityDetailsBloc>(
        create: (context) {
          return EntityDetailsBloc(
            id: id,
            userDetails: userDetails,
            grupoUNSPSCRepository: sl.get<GrupoUNSPSCRepository>(),
          )..add(const EntityDetailsStarted());
        },
        child: const EntityDetails(),
      ),
    );
  }
}
