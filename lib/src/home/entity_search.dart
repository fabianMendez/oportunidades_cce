import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/home/entity_search_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/entity_result_tile.dart';
import 'package:oportunidades_cce/src/widgets/search_field.dart';

class EntitySearch extends StatelessWidget {
  const EntitySearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntitySearchBloc, EntitySearchState>(
      builder: (context, state) {
        final isLoading = state is EntitySearchLoading;
        final isUninitialized = state is EntitySearchUninitialized;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchField(
                value: state.term,
                onSubmitted: (value) {
                  BlocProvider.of<EntitySearchBloc>(context).add(
                    EntitySearchTermChanged(term: value),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isUninitialized
                  ? const Center(
                      child: Text(
                      'Ingresa un término de búsqueda',
                      style: TextStyle(fontSize: 16),
                    ))
                  : isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : state.results.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay entidades que coincidan con el texto',
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
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                            ),
            ),
          ],
        );
      },
    );
  }
}
