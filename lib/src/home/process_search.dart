import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oportunidades_cce/src/home/process_search_bloc.dart';
import 'package:oportunidades_cce/src/widgets/search_field.dart';

class ProcessSearch extends StatelessWidget {
  const ProcessSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneyFmt = NumberFormat('#,##0', 'es_CO');

    return BlocBuilder<ProcessSearchBloc, ProcessSearchState>(
      builder: (context, state) {
        final isLoading = state is ProcessSearchLoading;
        final isUninitialized = state is ProcessSearchUninitialized;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Búsqueda rápida',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchField(
                value: state.term,
                onSubmitted: (value) {
                  BlocProvider.of<ProcessSearchBloc>(context).add(
                    ProcessSearchTermChanged(term: value),
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
                                'No hay procesos que coincidan con el texto',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.results.length,
                              itemBuilder: (context, index) {
                                final result = state.results[index];
                                return ExpansionTile(
                                  title: Text(
                                    result.nombreEntidad,
                                  ),
                                  subtitle: Text(
                                    '\$${moneyFmt.format(result.proceso.tender.value.amount)} ${result.moneda}',
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // if (result.nitEntidad != null)
                                          //   Text('NIT: ${result.nitEntidad}'),
                                          // if (result.nitEntidad != null)
                                          //   const SizedBox(height: 4),
                                          // Text(
                                          //     'Fecha inicial: ${result.proceso.date}'),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Inicia',
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                  Text(
                                                    result.proceso.date,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              if (result.nitEntidad != null)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'NIT',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    Text(
                                                      result.nitEntidad!,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(result.descripcion),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            tooltip: 'Ver',
                                            icon: const Icon(Icons.open_in_new),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
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
