import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/favorite_entities.dart';
import 'package:oportunidades_cce/src/home/favorite_entities_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/logout_button.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class MisEntidadesView extends StatelessWidget {
  const MisEntidadesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis entidades'),
        actions: const [LogoutButton()],
      ),
      body: BlocProvider<FavoriteEntitiesBloc>(
        create: (context) {
          return FavoriteEntitiesBloc(
            userDetails: userDetails,
            entidadRepository: sl.get<EntidadRepository>(),
          )..add(const FavoriteEntitiesStarted());
        },
        child: const FavoriteEntities(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
