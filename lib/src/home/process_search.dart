import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/home/process_search_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/process_result_tile.dart';
import 'package:oportunidades_cce/src/widgets/multi_text_field.dart';
import 'package:oportunidades_cce/src/widgets/search_field.dart';

class ProcessSearch extends StatelessWidget {
  const ProcessSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: SearchField(
                value: state.term,
                onSubmitted: (value) {
                  context
                      .read<ProcessSearchBloc>()
                      .add(ProcessSearchTermChanged(term: value));
                },
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Text('Textos'),
                  MultiTextField(
                    onChanged: (keywords) {
                      context
                          .read<ProcessSearchBloc>()
                          .add(ProcessSearchKeywordsChanged(keywords));
                    },
                    values: state.filter.textos.map((it) => it.texto).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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
                                'No hay procesos que coincidan con el texto',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.results.length,
                              itemBuilder: (context, index) {
                                final result = state.results[index];
                                return ProcessResultTile(result: result);
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
