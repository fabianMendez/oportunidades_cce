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
                      : RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<FavoriteEntitiesBloc>()
                                .add(const FavoriteEntitiesRefreshed());
                          },
                          child: ListView.builder(
                            itemCount: state.results.length,
                            itemBuilder: (context, index) {
                              final contentPadding = index == 0
                                  ? const EdgeInsets.symmetric(horizontal: 16) +
                                      const EdgeInsets.only(top: 4)
                                  : null;
                              final result = state.results[index];
                              return EntityResultTile(
                                result: result,
                                contentPadding: contentPadding,
                              );
                            },
                            // separatorBuilder: (_, __) =>
                            //     const Divider(height: 16),
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }
}
