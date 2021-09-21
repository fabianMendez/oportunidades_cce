import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/entity_search.dart';
import 'package:oportunidades_cce/src/home/entity_search_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/logout_button.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class BuscarEntidadesView extends StatelessWidget {
  const BuscarEntidadesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar entidades'),
        actions: const [LogoutButton()],
      ),
      body: BlocProvider<EntitySearchBloc>(
        create: (context) {
          return EntitySearchBloc(
            userDetails: userDetails,
            entidadRepository: sl.get<EntidadRepository>(),
          )..add(const EntitySearchStarted());
        },
        child: const EntitySearch(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
