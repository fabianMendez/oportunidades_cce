import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/favorite_process_button.dart';
import 'package:oportunidades_cce/src/home/process_details_bloc.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProcessDetails extends StatelessWidget {
  const ProcessDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);
    final moneyFmt = NumberFormat('#,##0', 'es_CO');
    final dateFmt = DateFormat('d \'de\' MMMM \'de\' yyyy', 'es_CO');

    return BlocBuilder<ProcessDetailsBloc, ProcessDetailsState>(
      builder: (context, state) {
        const fontSize = 17.0;

        if (state is ProcessDetailsReady) {
          final details = state.details;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${details.plataforma} · ${details.codigoInterno}',
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      details.buyer.name,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      details.tender.title,
                      style: const TextStyle(
                        height: 1.2,
                        fontSize: 15,
                        // fontStyle: FontStyle.italic,
                        // letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Fecha Inicial: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                        Text(
                          dateFmt.format(details.date),
                          style: const TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'Monto: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                        Text(
                          '\$${moneyFmt.format(details.tender.value.amount)}',
                          style: const TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                    if (details.url != null) const SizedBox(height: 4),
                    if (details.url != null)
                      TextButton.icon(
                        onPressed: () async {
                          final url = details.url!;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No fue posible abrir la URL'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text(
                          'Ver',
                          style: TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    TextButton.icon(
                      onPressed: () async {
                        final url =
                            'https://oportunidades.colombiacompra.gov.co/compartir/proceso/${details.codigoInterno}/${userDetails.id}';

                        await Share.share(
                          'Revisa este proceso de contratación que te comparten desde la aplicación Oportunidades CCE: $url',
                          subject: 'Proceso interesante',
                        );
                      },
                      icon: const Icon(Icons.share),
                      label: const Text(
                        'Compartir',
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FavoriteProcessButton(idProceso: state.id),
                  ],
                ),
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
