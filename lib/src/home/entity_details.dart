import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/home/entity_details_bloc.dart';

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
            body: Padding(
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
                ],
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
