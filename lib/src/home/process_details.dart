import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oportunidades_cce/src/home/process_details_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProcessDetails extends StatelessWidget {
  const ProcessDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneyFmt = NumberFormat('#,##0', 'es_CO');

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
            body: Padding(
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
                        details.date,
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
                      icon: const Icon(Icons.open_in_new),
                      label: const Text(
                        'Ver',
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
