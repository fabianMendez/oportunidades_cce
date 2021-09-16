import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:oportunidades_cce/src/api_client.dart';

final _unescape = HtmlUnescape();

// {"codigo":"1","estado":1,"id":2,"nombre":"[A] MATERIAL VIVO ANIMAL Y VEGETAL"}
class GrupoUNSPSC extends Equatable {
  const GrupoUNSPSC({
    required this.codigo,
    required this.estado,
    required this.id,
    required this.nombre,
  });

  GrupoUNSPSC.fromJson(Map<String, dynamic> map)
      : codigo = map['codigo'],
        estado = map['estado'],
        id = map['id'],
        nombre = _unescape
            .convert(map['nombre'])
            .replaceAll('<b>', '')
            .replaceAll('</b>', '')
            .replaceAll('<br>', '\n')
            .replaceAll('<br/>', '\n');

  final String codigo;
  final int estado;
  final int id;
  final String nombre;

  @override
  List<Object?> get props => [codigo, estado, id, nombre];
}

class SegmentoUNSPSC extends Equatable {
  const SegmentoUNSPSC({
    required this.codigo,
    required this.nombre,
    required this.estado,
    required this.familias,
  });

  SegmentoUNSPSC.fromJson(Map<String, dynamic> map)
      : codigo = map['codigo'],
        nombre = _unescape.convert(map['nombre']),
        estado = map['estado'],
        familias = map['familias']
            .map((elm) => GrupoUNSPSC.fromJson(elm))
            .toList()
            .cast<GrupoUNSPSC>();

  final String codigo;
  final String nombre;
  final int estado;
  final List<GrupoUNSPSC> familias;

  @override
  List<Object?> get props => [codigo, nombre, estado, familias];
}

class FamiliaUNSPSC extends Equatable {
  const FamiliaUNSPSC();

  const FamiliaUNSPSC.fromJson(Map<String, dynamic> map);

  @override
  List<Object?> get props => [];
}

class GrupoUNSPSCRepository {
  GrupoUNSPSCRepository({
    required this.apiClient,
  });

  final APIClient apiClient;

  Future<List<GrupoUNSPSC>> getGruposUNSPSC({
    required String codigo,
  }) async {
    final res = await apiClient.request(
      path: '/ServletGruposUNSPSC',
      body: {'codigo': codigo},
    );

    print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => GrupoUNSPSC.fromJson(it)).toList();
  }

  Future<List<SegmentoUNSPSC>> buscarFamiliasUNSPSC({
    required String codigo,
    required String texto,
    required int idGrupo,
  }) async {
    final res = await apiClient.request(
      path: '/ServletBuscarSegmentosUNSPSCFamiliasUNSPSC',
      body: {
        'codigo': codigo,
        'texto': texto,
        'idGrupo': idGrupo,
      },
    );

    print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => SegmentoUNSPSC.fromJson(it)).toList();
  }

  Future<List<FamiliaUNSPSC>> getFamiliasClasesUsuarioGrupoUNSPSC({
    required String codigo,
    required int idGrupo,
  }) async {
    final res = await apiClient.request(
      path: '/ServletFamiliasUNSPSCGrupoUNSPSCUsuario',
      body: {'codigo': codigo, 'idGrupo': idGrupo},
    );

    print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => FamiliaUNSPSC.fromJson(it)).toList();
  }

  Future<APIResponse> inscribirseFamiliaUNSPSC({
    required String codigo,
    required int idGrupo,
    required int idFamilia,
    required bool inscribirse,
  }) {
    return apiClient.post(
      path: '/ServletInscribirseFamilia',
      body: {
        'codigo': codigo,
        'idGrupo': idGrupo,
        'idFamilia': idFamilia,
        'inscribirse': inscribirse
      },
    );
  }

  Future<List<FamiliaUNSPSC>> getFamiliasClasesUsuario({
    required String codigo,
  }) async {
    final res = await apiClient.request(
      path: '/ServletFamiliasUNSPSCUsuario',
      body: {'codigo': codigo},
    );

    print(res.body);
    // final List<dynamic> list = json.decode(res.body);

    // return list.map((it) => FamiliaUNSPSC.fromJson(it)).toList();
    return [];
  }

  Future<List<SegmentoUNSPSC>> getSegmentosFamiliasUNSPSC({
    required String codigo,
    required int idGrupo,
  }) async {
    final res = await apiClient.request(
      path: '/ServletSegmentosUNSPSCFamiliasUNSPSC',
      body: {'codigo': codigo, 'idGrupo': idGrupo},
    );

    print(res.body);
    final List<dynamic> list = json.decode(res.body);

    return list.map((it) => SegmentoUNSPSC.fromJson(it)).toList();
  }
}
