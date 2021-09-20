import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/home/favorite_entities_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/entity_result_tile.dart';

class FavoriteEntities extends StatelessWidget {
  const FavoriteEntities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteEntitiesBloc, FavoriteEntitiesState>(
      builder: (context, state) {
        final isLoading = state is FavoriteEntitiesLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : state.results.isEmpty
                      ? const Center(
                          child: Text(
                            'Actualmente no sigues ninguna entidad',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.results.length,
                          itemBuilder: (context, index) {
                            final result = state.results[index];
                            return EntityResultTile(result: result);
                          },
                          // separatorBuilder: (_, __) =>
                          //     const Divider(height: 16),
                        ),
            ),
          ],
        );
      },
    );
  }
}