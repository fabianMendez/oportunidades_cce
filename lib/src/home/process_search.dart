import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/notificaciones_settings_filtro_bienes_servicios_view.dart';
import 'package:oportunidades_cce/src/home/process_search_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/process_result_tile.dart';
import 'package:oportunidades_cce/src/utils/dialogs.dart';
import 'package:oportunidades_cce/src/widgets/search_field.dart';

class ProcessSearch extends StatelessWidget {
  const ProcessSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProcessSearchBloc, ProcessSearchState>(
      builder: (context, state) {
        final hasResults = state.results.isNotEmpty;

        if (!hasResults) {
          return Column(
            children: [
              _Header(state: state),
              Expanded(
                child: Center(
                  child: state.isEmpty
                      ? const Text(
                          'Ingresa un término de búsqueda',
                          style: TextStyle(fontSize: 16),
                        )
                      : state.isLoading
                          ? const CircularProgressIndicator.adaptive()
                          : const Text(
                              'No hay procesos que coincidan con el término de búsqueda',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
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
                  final result = state.sortedResults[index];
                  return ProcessResultTile(
                    key: ValueKey(result.id),
                    result: result,
                  );
                },
                childCount: state.sortedResults.length,
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
                  .read<ProcessSearchBloc>()
                  .add(const ProcessSearchRefreshed());
            },
            child: child,
          );
        }

        return child;
      },
    );
  }
}

List<T> removeAt<T>(List<T> list, int index) {
  final copy = List<T>.from(list);
  copy.removeAt(index);
  return copy;
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.state,
  }) : super(key: key);

  final ProcessSearchState state;

  @override
  Widget build(BuildContext context) {
    final moneyFmt = NumberFormat('#,##0', 'es_CO');

    final keywords = state.filter.textos.map((it) => it.texto).toList();
    final ranges = state.filter.rangos
        .map((it) => Range(
              min: double.parse(it.montoInferior),
              max: double.parse(it.montoSuperior),
            ))
        .toList();
    final families = state.filter.familias;

    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchField(
            value: state.term,
            onSubmitted: (value) {
              context
                  .read<ProcessSearchBloc>()
                  .add(ProcessSearchTermChanged(term: value));
            },
          ),
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          title: Text(
            'Filtros${state.filter.count == 0 ? '' : ' (${state.filter.count})'}',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          // trailing: const Icon(Icons.filter_list),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bienes y servicios',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final familiasSeleccionadas =
                              await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return const NotificacionesSettingsFiltroBienesServiciosView();
                            }),
                          );
                          if (familiasSeleccionadas is List<GrupoUNSPSC> &&
                              familiasSeleccionadas.isNotEmpty) {
                            final newFamilies = familiasSeleccionadas
                                .where((it) => !families.contains(it));

                            final allFamilies =
                                families.followedBy(newFamilies).toList();

                            context
                                .read<ProcessSearchBloc>()
                                .add(ProcessSearchFamiliesChanged(allFamilies));
                          }
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      for (int i = 0; i < families.length; i++)
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: Chip(
                            label: Text(families[i].titulo),
                            onDeleted: () {
                              final newFamilies = removeAt(families, i);
                              context.read<ProcessSearchBloc>().add(
                                  ProcessSearchFamiliesChanged(newFamilies));
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Palabras clave',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final keyword = await showPrompt(
                            context,
                            title: 'Agregar palabra clave',
                          );
                          if (keyword != null && keyword.isNotEmpty) {
                            final newKeywords =
                                keywords.followedBy([keyword]).toList();

                            context
                                .read<ProcessSearchBloc>()
                                .add(ProcessSearchKeywordsChanged(newKeywords));
                          }
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      for (int i = 0; i < keywords.length; i++)
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: Chip(
                            label: Text(keywords[i]),
                            // deleteIcon: const Icon(Icons.delete),
                            onDeleted: () {
                              final newKeywords = removeAt(keywords, i);
                              context.read<ProcessSearchBloc>().add(
                                  ProcessSearchKeywordsChanged(newKeywords));
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rangos de precio',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final range = await showValueRangePrompt(
                            context,
                            title: 'Agregar rango',
                          );
                          if (range != null && range.isValid && range.max > 0) {
                            final newRanges =
                                ranges.followedBy([range]).toList();

                            context
                                .read<ProcessSearchBloc>()
                                .add(ProcessSearchRangesChanged(newRanges));
                          }
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      for (int i = 0; i < ranges.length; i++)
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: Chip(
                            label: Text(
                                '\$${moneyFmt.format(ranges[i].min)}-\$${moneyFmt.format(ranges[i].max)}'),
                            onDeleted: () {
                              final newRanges = removeAt(ranges, i);

                              context
                                  .read<ProcessSearchBloc>()
                                  .add(ProcessSearchRangesChanged(newRanges));
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // const SizedBox(height: 12),
        if (state.isNotEmpty && !state.isLoading && state.results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Procesos (${state.results.length})',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          state.sort.displayName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.sort,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    final newSort = await showDialog<ProcessSort>(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text('Ordenar por'),
                          children: [
                            for (final value in ProcessSort.values)
                              RadioListTile(
                                title: Text(value.displayName),
                                value: value,
                                groupValue: state.sort,
                                onChanged: (ProcessSort? value) {
                                  Navigator.of(context).pop(value);
                                },
                              ),
                          ],
                        );
                      },
                    );

                    if (newSort != null) {
                      context
                          .read<ProcessSearchBloc>()
                          .add(ProcessSearchSortChanged(newSort));
                    }
                  },
                ),
              ],
            ),
          ),
        /*
                  ,*/
      ],
    );
  }
}
