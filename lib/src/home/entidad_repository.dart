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
    return await apiClient.requestList(
      path: '/ServletBuscarEntidad',
      body: {
        'codigo': codigo,
        'texto': texto,
      },
      convertFn: (it) => EntitySearchResult.fromJson(it),
    );
  }

  Future<List<EntitySearchResult>> getMisEntidades({
    required String codigo,
  }) {
    return apiClient.requestList(
      path: '/ServletMisEntidades',
      body: {'codigo': codigo},
      convertFn: (it) => EntitySearchResult.fromJson(it),
    );
  }

  Future<EntitySearchResult> getEntidad({
    required String codigo,
    required int idEntidad,
  }) {
    return apiClient.request(
      path: '/ServletEntidad',
      body: {
        'codigo': codigo,
        'idEntidad': idEntidad,
      },
      convertFn: (map) => EntitySearchResult.fromJson(map),
    );
  }

  Future<bool> esSeguidorEntidad({
    required String codigo,
    required String idEntidad,
  }) {
    return apiClient.request(
      path: '/ServletEsSeguidorEntidad',
      body: {
        'codigo': codigo,
        'idEntidad': idEntidad,
      },
      convertFn: (map) => map['esSeguidor'],
    );
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
