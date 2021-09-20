import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/models/entity_search_result.dart';

class EntityResultTile extends StatelessWidget {
  const EntityResultTile({
    Key? key,
    required this.result,
  }) : super(key: key);

  final EntitySearchResult result;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        result.nombre,
      ),
      subtitle: Text(result.nit),
    );
  }
}
