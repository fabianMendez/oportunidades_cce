import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/favorite_process_button_bloc.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class FavoriteProcessButton extends StatelessWidget {
  const FavoriteProcessButton({
    Key? key,
    required this.idProceso,
    this.initial,
  }) : super(key: key);

  final int idProceso;
  final bool? initial;

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return BlocProvider(
      create: (context) {
        return FavoriteProcessButtonBloc(
          userDetails: userDetails,
          idProceso: idProceso,
          procesoRepository: sl.get<ProcesoRepository>(),
        )..add(const FavoriteProcessButtonStarted());
      },
      child: const FavoriteProcessButtonBuilder(),
    );
  }
}

class FavoriteProcessButtonBuilder extends StatelessWidget {
  const FavoriteProcessButtonBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const fontSize = 17.0;

    return BlocBuilder<FavoriteProcessButtonBloc, FavoriteProcessButtonState>(
      builder: (context, state) {
        final isFavorite =
            state is FavoriteProcessButtonReady && state.isFavorite;
        final isLoading = state is FavoriteProcessButtonLoading;

        return Column(
          children: [
            TextButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<FavoriteProcessButtonBloc>().add(
                            FavoriteProcessButtonChanged(
                                isFavorite: !isFavorite),
                          );
                    },
              icon: isLoading
                  ? const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_outline),
              label: Text(
                isFavorite ? 'SIGUIENDO' : 'SEGUIR',
                style: const TextStyle(
                  fontSize: fontSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
