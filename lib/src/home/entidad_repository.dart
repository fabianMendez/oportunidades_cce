import 'dart:convert';

import 'package:oportunidades_cce/src/api_client.dart';
import 'package:oportunidades_cce/src/home/models/entity_search_result.dart';

class EntidadRepository {
  EntidadRepository({
    required this.apiClient,
  });

  final APIClient apiClient;

  Future<List<EntitySearchResult>> buscarEntidades({
    required String codigo,
    required String texto,
  }) async {
    final res = await apiClient.request(
      path: '/ServletBuscarEntidad',
      body: {
        'codigo': codigo,
        'texto': texto,
      },
    );

    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => EntitySearchResult.fromJson(it)).toList();
  }

  Future<List<EntitySearchResult>> getMisEntidades({
    required String codigo,
  }) async {
    final res = await apiClient.request(
      path: '/ServletMisEntidades',
      body: {'codigo': codigo},
    );

    // print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => EntitySearchResult.fromJson(it)).toList();
  }

  Future<EntitySearchResult> getEntidad({
    required String codigo,
    required int idEntidad,
  }) async {
    final res = await apiClient.request(
      path: '/ServletEntidad',
      body: {
        'codigo': codigo,
        'idEntidad': idEntidad,
      },
    );

    // print(res.body);
    final map = json.decode(res.body);

    return EntitySearchResult.fromJson(map);
  }

  Future<bool> esSeguidorEntidad({
    required String codigo,
    required String idEntidad,
  }) async {
    final res = await apiClient.request(
      path: '/ServletEsSeguidorEntidad',
      body: {
        'codigo': codigo,
        'idEntidad': idEntidad,
      },
    );

    // print(res.body);
    final map = json.decode(res.body);

    return map['esSeguidor'];
  }

  Future<APIResponse> seguirNoSeguirEntidad({
    required String codigo,
    required String idEntidad,
    required bool insertar,
  }) {
    return apiClient.post(
      path: '/ServletSeguirEntidadUsuarioEmpresa',
      body: {
        'codigo': codigo,
        'idEntidad': idEntidad,
        'insertar': insertar,
      },
    );
  }
}
