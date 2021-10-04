import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/home/favorite_processes_bloc.dart';
import 'package:oportunidades_cce/src/home/widgets/process_result_tile.dart';

class FavoriteProcesses extends StatelessWidget {
  const FavoriteProcesses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteProcessesBloc, FavoriteProcessesState>(
      builder: (context, state) {
        final isLoading = state is FavoriteProcessesLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Text(
            //     'Procesos que tú sigues',
            //     style: Theme.of(context).textTheme.headline5,
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : state.results.isEmpty
                      ? const Center(
                          child: Text(
                            'Actualmente no sigues ningún proceso',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            context
                                .read<FavoriteProcessesBloc>()
                                .add(const FavoriteProcessesStarted());
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
