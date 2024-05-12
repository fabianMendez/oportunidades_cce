import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/favorite_entities.dart';
import 'package:oportunidades_cce/src/home/favorite_entities_bloc.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class MisEntidadesView extends StatefulWidget {
  const MisEntidadesView({super.key});

  @override
  State<MisEntidadesView> createState() => _MisEntidadesViewState();
}

class _MisEntidadesViewState extends State<MisEntidadesView>
    with AutomaticKeepAliveClientMixin<MisEntidadesView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final userDetails = Provider.of<UserDetails>(context);

    return BlocProvider<FavoriteEntitiesBloc>(
      create: (context) {
        return FavoriteEntitiesBloc(
          userDetails: userDetails,
          entidadRepository: sl.get<EntidadRepository>(),
        )..add(const FavoriteEntitiesStarted());
      },
      child: const FavoriteEntities(),
    );
  }

  @override
  final bool wantKeepAlive = true;
}
