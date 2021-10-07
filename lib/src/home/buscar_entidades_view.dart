import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/entity_search.dart';
import 'package:oportunidades_cce/src/home/entity_search_bloc.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class BuscarEntidadesView extends StatefulWidget {
  const BuscarEntidadesView({Key? key}) : super(key: key);

  @override
  State<BuscarEntidadesView> createState() => _BuscarEntidadesViewState();
}

class _BuscarEntidadesViewState extends State<BuscarEntidadesView>
    with AutomaticKeepAliveClientMixin<BuscarEntidadesView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final userDetails = Provider.of<UserDetails>(context);

    return BlocProvider<EntitySearchBloc>(
      create: (context) {
        return EntitySearchBloc(
          userDetails: userDetails,
          entidadRepository: sl.get<EntidadRepository>(),
        )..add(const EntitySearchStarted());
      },
      child: const EntitySearch(),
    );
  }

  @override
  final bool wantKeepAlive = true;
}
