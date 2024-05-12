import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/home/entity_search_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/entity_result_tile.dart';
import 'package:oportunidades_cce/src/widgets/search_field.dart';

class EntitySearch extends StatelessWidget {
  const EntitySearch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntitySearchBloc, EntitySearchState>(
      builder: (context, state) {
        final hasResults = state.results.isNotEmpty;

        if (!hasResults) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(state: state),
              Expanded(
                child: state.isUninitialized
                    ? const Center(
                        child: Text(
                        'Ingresa un término de búsqueda',
                        style: TextStyle(fontSize: 16),
                      ))
                    : state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive())
                        : const Center(
                            child: Text(
                              'No hay entidades que coincidan con el texto',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
              ),
            ],
          );
        }

        final child = CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Header(state: state),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final result = state.results[index];
                  return EntityResultTile(result: result);
                },
                childCount: state.results.length,
                // separatorBuilder: (_, __) =>
                //     const Divider(height: 16),
              ),
            ),
          ],
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        );

        final canRefresh = state.isNotEmpty && !state.isLoading;
        if (canRefresh) {
          return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<EntitySearchBloc>()
                    .add(const EntitySearchRefreshed());
              },
              child: child);
        }

        return child;
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.state,
  });

  final EntitySearchState state;

  @override
  Widget build(BuildContext context) {
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
        if (state.isNotEmpty && !state.isLoading && state.results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              'Entidades (${state.results.length})',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
