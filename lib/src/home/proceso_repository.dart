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
    required Map<String, dynamic> jfamilias,
    required Map<String, dynamic> jrangos,
    required Map<String, dynamic> jtextos,
  }) async {
    final res = await apiClient.request(
      path: '/ServletBusquedaProcesos',
      body: {
        'codigo': codigo,
        'jfamilias': jfamilias,
        'jrangos': jrangos,
        'jtextos': jtextos,
      },
    );

    // print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => ProcessSearchResult.fromJson(it)).toList();
  }

  Future<List<ProcessSearchResult>> getProcesosBusquedaRapida({
    required String codigo,
    required String texto,
  }) async {
    final res = await apiClient.request(
      path: '/ServletBusquedaRapidaProcesos',
      body: {
        'codigo': codigo,
        'texto': texto,
      },
    );

    // print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => ProcessSearchResult.fromJson(it)).toList();
  }

  Future<List<ProcessSearchResult>> getProcesosEntidad({
    required String codigo,
    required String idEntidad,
  }) async {
    final res = await apiClient.request(
      path: '/ServletProcesosEntidad',
      body: {
        'codigo': codigo,
        'idEntidad': idEntidad,
      },
    );

    // print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => ProcessSearchResult.fromJson(it)).toList();
  }

  Future<List<ProcessSearchResult>> getProcesosInteresantes({
    required String codigo,
  }) async {
    final res = await apiClient.request(
      path: '/ServletProcesosInteresantes',
      body: {'codigo': codigo},
    );

    // print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => ProcessSearchResult.fromJson(it)).toList();
  }

  Future<List<ProcessSearchResult>> getMisProcesos({
    required String codigo,
  }) async {
    final res = await apiClient.request(
      path: '/ServletMisProcesos',
      body: {'codigo': codigo},
    );

    // print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => ProcessSearchResult.fromJson(it)).toList();
  }

  Future<Proceso> getProceso({
    required String codigo,
    required int idProceso,
  }) async {
    final res = await apiClient.request(
      path: '/ServletProceso',
      body: {
        'codigo': codigo,
        'idProceso': idProceso,
      },
    );

    print(res.body);
    final map = json.decode(res.body);

    return Proceso.fromJson(map);
  }

  Future<bool> esSeguidorProceso({
    required String codigo,
    required int idProceso,
  }) async {
    final res = await apiClient.request(
      path: '/ServletEsSeguidorProceso',
      body: {
        'codigo': codigo,
        'idProceso': idProceso,
      },
    );

    // print(res.body);
    final map = json.decode(res.body);

    return map['esSeguidor'];
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
