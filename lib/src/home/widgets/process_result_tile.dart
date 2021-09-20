import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';

class ProcessResultTile extends StatelessWidget {
  const ProcessResultTile({
    Key? key,
    required this.result,
  }) : super(key: key);

  final ProcessSearchResult result;

  @override
  Widget build(BuildContext context) {
    final moneyFmt = NumberFormat('#,##0', 'es_CO');

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // if (result.nitEntidad != null)
              //   Text('NIT: ${result.nitEntidad}'),
              // if (result.nitEntidad != null)
              //   const SizedBox(height: 4),
              // Text(
              //     'Fecha inicial: ${result.proceso.date}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inicia',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        result.proceso.date,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  if (result.nitEntidad != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NIT',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(
                          result.nitEntidad!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
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
            mainAxisAlignment: MainAxisAlignment.end,
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
  }
}