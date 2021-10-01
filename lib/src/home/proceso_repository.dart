import 'dart:convert';

import 'package:oportunidades_cce/src/api_client.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';

class ProcesoRepository {
  ProcesoRepository({
    required this.apiClient,
  });

  final APIClient apiClient;

  Future<List<ProcessSearchResult>> busquedaProcesos({
    required String codigo,
    required List<ValueNotificationSetting> rangos,
    required List<KeywordNotificationSetting> textos,
    required List<GrupoUNSPSC> familias,
  }) {
    final jfamilias = json.encode(familias);
    final jrangos = json.encode(rangos);
    final jtextos = json.encode(textos);

    return apiClient.requestList(
      path: '/ServletBusquedaProcesos',
      body: {
        'codigo': codigo,
        'jfamilias': jfamilias,
        'jrangos': jrangos,
        'jtextos': jtextos,
      },
      convertFn: (it) => ProcessSearchResult.fromJson(it),
    );
  }

  Future<List<ProcessSearchResult>> getProcesosBusquedaRapida({
    required String codigo,
    required String texto,
  }) {
    return apiClient.requestList(
      path: '/ServletBusquedaRapidaProcesos',
      body: {
        'codigo': codigo,
        'texto': texto,
      },
      convertFn: (it) => ProcessSearchResult.fromJson(it),
    );
  }

  Future<List<ProcessSearchResult>> getProcesosEntidad({
    required String codigo,
    required String idEntidad,
  }) {
    return apiClient.requestList(
      path: '/ServletProcesosEntidad',
      body: {
        'codigo': codigo,
        'idEntidad': idEntidad,
      },
      convertFn: (it) => ProcessSearchResult.fromJson(it),
    );
  }

  Future<List<ProcessSearchResult>> getProcesosInteresantes({
    required String codigo,
  }) {
    return apiClient.requestList(
      path: '/ServletProcesosInteresantes',
      body: {'codigo': codigo},
      convertFn: (it) => ProcessSearchResult.fromJson(it),
    );
  }

  Future<List<ProcessSearchResult>> getMisProcesos({
    required String codigo,
  }) {
    return apiClient.requestList(
      path: '/ServletMisProcesos',
      body: {'codigo': codigo},
      convertFn: (it) => ProcessSearchResult.fromJson(it),
    );
  }

  Future<Proceso> getProceso({
    required String codigo,
    required int idProceso,
  }) {
    return apiClient.request(
      path: '/ServletProceso',
      body: {
        'codigo': codigo,
        'idProceso': idProceso,
      },
      convertFn: (map) => Proceso.fromJson(map),
    );
  }

  Future<bool> esSeguidorProceso({
    required String codigo,
    required int idProceso,
  }) {
    return apiClient.request(
      path: '/ServletEsSeguidorProceso',
      body: {
        'codigo': codigo,
        'idProceso': idProceso,
      },
      convertFn: (map) => map['esSeguidor'],
    );
  }

  Future<APIResponse> seguirNoSeguirProceso({
    required String codigo,
    required int idProceso,
    required bool insertar,
  }) {
    return apiClient.post(
      path: '/ServletInsertarEliminarSeguidorProceso',
      body: {
        'codigo': codigo,
        'insertar': insertar,
        'idProceso': idProceso,
      },
    );
  }
}
