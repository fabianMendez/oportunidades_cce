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
    final moneyFmt = NumberFormat('#,##0', 'es_CO');

    return BlocBuilder<ProcessSearchBloc, ProcessSearchState>(
      builder: (context, state) {
        final isLoading = state is ProcessSearchLoading;

        final keywords = state.filter.textos.map((it) => it.texto).toList();
        final ranges = state.filter.rangos
            .map((it) => Range(
                  min: double.parse(it.montoInferior),
                  max: double.parse(it.montoSuperior),
                ))
            .toList();
        final families = state.filter.familias;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                'Filtros (${state.filter.count})',
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
                                final newFamilies = families
                                    .followedBy(familiasSeleccionadas)
                                    .toList();

                                context.read<ProcessSearchBloc>().add(
                                    ProcessSearchFamiliesChanged(newFamilies));
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
                                      ProcessSearchFamiliesChanged(
                                          newFamilies));
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

                                context.read<ProcessSearchBloc>().add(
                                    ProcessSearchKeywordsChanged(newKeywords));
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
                                      ProcessSearchKeywordsChanged(
                                          newKeywords));
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
                              if (range != null &&
                                  range.isValid &&
                                  range.max > 0) {
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

                                  context.read<ProcessSearchBloc>().add(
                                      ProcessSearchRangesChanged(newRanges));
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
            Expanded(
              child: state.isEmpty
                  ? const Center(
                      child: Text(
                        'Ingresa un término de búsqueda',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : state.results.isEmpty
                          ? const Center(
                              child: Text(
                                'No hay procesos que coincidan con el término de búsqueda',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                context
                                    .read<ProcessSearchBloc>()
                                    .add(const ProcessSearchRefreshed());
                              },
                              child: ListView.builder(
                                itemCount: state.results.length,
                                itemBuilder: (context, index) {
                                  final result = state.results[index];
                                  return ProcessResultTile(result: result);
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

List<T> removeAt<T>(List<T> list, int index) {
  final copy = List<T>.from(list);
  copy.removeAt(index);
  return copy;
}
