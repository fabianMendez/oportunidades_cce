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
        if (isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state.results.isEmpty) {
          return const Center(
            child: Text(
              'Actualmente no sigues ningún proceso',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<FavoriteProcessesBloc>()
                .add(const FavoriteProcessesStarted());
          },
          child: ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final contentPadding = index == 0
                  ? const EdgeInsets.symmetric(horizontal: 16) +
                      const EdgeInsets.only(top: 4)
                  : null;

              final result = state.results[index];
              return ProcessResultTile(
                result: result,
                contentPadding: contentPadding,
              );
            },
            // separatorBuilder: (_, __) =>
            //     const Divider(height: 16),
          ),
        );
      },
    );
  }
}
