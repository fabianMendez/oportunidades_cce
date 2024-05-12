import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/blocs/favorite_entity_button_bloc.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class FavoriteEntityButton extends StatelessWidget {
  const FavoriteEntityButton({
    super.key,
    required this.idEntidad,
    this.initial,
  });

  final int idEntidad;
  final bool? initial;

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return BlocProvider(
      create: (context) {
        return FavoriteEntityButtonBloc(
          userDetails: userDetails,
          idEntidad: idEntidad,
          entidadRepository: sl.get<EntidadRepository>(),
        )..add(const FavoriteEntityButtonStarted());
      },
      child: const FavoriteEntityButtonBuilder(),
    );
  }
}

class FavoriteEntityButtonBuilder extends StatelessWidget {
  const FavoriteEntityButtonBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    const fontSize = 17.0;

    return BlocBuilder<FavoriteEntityButtonBloc, FavoriteEntityButtonState>(
      builder: (context, state) {
        final isFavorite =
            state is FavoriteEntityButtonReady && state.isFavorite;
        final isLoading = state is FavoriteEntityButtonLoading;

        return Column(
          children: [
            TextButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<FavoriteEntityButtonBloc>().add(
                            FavoriteEntityButtonChanged(
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
