import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/home/entity_details_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/favorite_entity_button.dart';
import 'package:oportunidades_cce/src/home/widgets/process_result_tile.dart';

class EntityDetails extends StatelessWidget {
  const EntityDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntityDetailsBloc, EntityDetailsState>(
      builder: (context, state) {
        const fontSize = 17.0;

        if (state is EntityDetailsReady) {
          final details = state.details;
          return Scaffold(
            appBar: AppBar(
              title: Text(details.nombre),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        details.nombre,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            'NIT: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                            ),
                          ),
                          Text(
                            details.nit,
                            style: const TextStyle(
                              fontSize: fontSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Departamento: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                            ),
                          ),
                          Text(
                            details.departamento,
                            style: const TextStyle(
                              fontSize: fontSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Municipio: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                            ),
                          ),
                          Text(
                            details.municipio,
                            style: const TextStyle(
                              fontSize: fontSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      FavoriteEntityButton(idEntidad: state.id),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Text(
                    'Procesos (${state.procesos.length})',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.procesos.length,
                    itemBuilder: (context, index) {
                      final result = state.procesos[index];
                      return ProcessResultTile(result: result);
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
