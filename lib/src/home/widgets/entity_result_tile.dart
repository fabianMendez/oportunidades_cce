import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authenticated_navigator_bloc.dart';
import 'package:oportunidades_cce/src/home/models/entity_search_result.dart';

class EntityResultTile extends StatelessWidget {
  const EntityResultTile({
    Key? key,
    required this.result,
  }) : super(key: key);

  final EntitySearchResult result;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        result.nombre,
      ),
      subtitle: Text(result.nit),
      trailing: const Icon(Icons.open_in_new),
      onTap: () {
        BlocProvider.of<AuthenticatedNavigatorBloc>(context)
            .add(EntityDetailsPushed(id: result.id));
      },
    );
  }
}
