import 'package:equatable/equatable.dart';
import 'package:html/parser.dart' show parse, parseFragment;
import 'package:html_unescape/html_unescape_small.dart';
import 'package:intl/intl.dart';
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

  String get titulo => nombre.split('\n')[0].trim();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': codigo,
      'estado': estado,
      'nombre': nombre,
    };
  }

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

class ValueNotificationSetting extends Equatable {
  const ValueNotificationSetting({
    required this.estado,
    required this.id,
    required this.montoInferior,
    required this.montoSuperior,
  });

  final int estado;
  final int id;
  final String montoInferior;
  final String montoSuperior;

  ValueNotificationSetting.fromJson(Map<String, dynamic> map)
      : estado = map['estado'] ?? 0,
        id = map['id'],
        montoInferior = map['montoInferior'],
        montoSuperior = map['montoSuperior'];

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'id': id,
      'montoInferior': montoInferior,
      'montoSuperior': montoSuperior,
    };
  }

  @override
  List<Object?> get props => [estado, id, montoInferior, montoSuperior];
}

class KeywordNotificationSetting extends Equatable {
  const KeywordNotificationSetting({
    required this.estado,
    required this.id,
    required this.texto,
  });

  final int estado;
  final int id;
  final String texto;

  KeywordNotificationSetting.fromJson(Map<String, dynamic> map)
      : estado = map['estado'] ?? 0,
        id = map['id'],
        texto = map['texto'];

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'id': id,
      'texto': texto,
    };
  }

  @override
  List<Object?> get props => [estado, id, texto];
}

class ProcessSearchResult extends Equatable {
  const ProcessSearchResult({
    required this.mongoId,
    required this.descripcion,
    required this.estado,
    required this.codigoInterno,
    required this.proceso,
    required this.valor,
    required this.ultimaFechaActualizacion,
    required this.url,
    required this.nitEntidad,
    required this.fecha,
    required this.plataforma,
    required this.nombreEntidad,
    required this.moneda,
    required this.id,
    required this.ocid,
  });

  final String mongoId;
  final String descripcion;
  final int estado;
  final String codigoInterno;
  final Proceso proceso;
  final double valor;
  final String ultimaFechaActualizacion;
  final String url;
  final String? nitEntidad;
  final String fecha;
  final String plataforma;
  final String nombreEntidad;
  final String moneda;
  final int id;
  final String ocid;

  ProcessSearchResult.fromJson(Map<String, dynamic> map)
      : mongoId = map['mongoId'],
        descripcion = _unescape.convert(map['descripcion'] ?? ''),
        estado = map['estado'],
        codigoInterno = map['codigoInterno'],
        proceso = Proceso.fromJson(map['proceso']),
        valor = (map['valor'] as num).toDouble(),
        ultimaFechaActualizacion = map['ultimaFechaActualizacion'],
        url = map['url'],
        nitEntidad = map['nitEntidad'],
        fecha = map['fecha'],
        plataforma = map['plataforma'],
        nombreEntidad = _unescape.convert(map['nombreEntidad']),
        moneda = map['moneda'],
        id = map['id'],
        ocid = map['ocid'];

  @override
  List<Object?> get props => [
        mongoId,
        descripcion,
        estado,
        codigoInterno,
        proceso,
        valor,
        ultimaFechaActualizacion,
        url,
        nitEntidad,
        fecha,
        plataforma,
        nombreEntidad,
        moneda,
        id,
        ocid,
      ];
}

final _dateFormat = DateFormat('dd/MM/yyyy');

class Proceso extends Equatable {
  const Proceso({
    required this.date,
    required this.tender,
    required this.buyer,
    required this.codigoInterno,
    required this.plataforma,
    required this.url,
  });

  final DateTime date;
  final Tender tender;
  final Buyer buyer;

  final String? codigoInterno;
  final String? plataforma;
  final String? url;

  Proceso.fromJson(Map<String, dynamic> map)
      : date = _dateFormat.parse(map['date']),
        tender = Tender.fromJson(map['tender']),
        buyer = Buyer.fromJson(map['buyer']),
        codigoInterno = map['codigoInterno'],
        // url = map['url'],
        url = map['url'] != null
            ? parseFragment(map['url']).firstChild!.attributes['href']
            : null,
        plataforma = map['plataforma'];

  @override
  List<Object?> get props => [
        date,
        tender,
        buyer,
        codigoInterno,
        plataforma,
        url,
      ];
}

class Buyer extends Equatable {
  const Buyer({
    required this.name,
    required this.id,
  });

  final String name;
  final String? id;

  Buyer.fromJson(Map<String, dynamic> map)
      : name = _unescape.convert(map['name']),
        id = map['id'];

  @override
  List<Object?> get props => [name, id];
}

class Tender extends Equatable {
  const Tender({
    required this.title,
    required this.value,
  });
  final String title;
  final Value value;

  Tender.fromJson(Map<String, dynamic> map)
      : title = _unescape.convert(map['title']),
        value = Value.fromJson(map['value']);

  @override
  List<Object?> get props => [title, value];
}

class Value extends Equatable {
  const Value({
    required this.amount,
  });

  final double amount;

  Value.fromJson(Map<String, dynamic> map)
      : amount = (map['amount'] as num).toDouble();

  @override
  List<Object?> get props => [amount];
}

class GrupoUNSPSCRepository {
  GrupoUNSPSCRepository({
    required this.apiClient,
  });

  final APIClient apiClient;

  Future<List<GrupoUNSPSC>> getGruposUNSPSC({
    required String codigo,
  }) {
    return apiClient.requestList(
      path: '/ServletGruposUNSPSC',
      body: {'codigo': codigo},
      convertFn: (it) => GrupoUNSPSC.fromJson(it),
    );
  }

  Future<List<SegmentoUNSPSC>> buscarFamiliasUNSPSC({
    required String codigo,
    required String texto,
    required int idGrupo,
  }) {
    return apiClient.requestList(
      path: '/ServletBuscarSegmentosUNSPSCFamiliasUNSPSC',
      body: {
        'codigo': codigo,
        'texto': texto,
        'idGrupo': idGrupo,
      },
      convertFn: (it) => SegmentoUNSPSC.fromJson(it),
    );
  }

  Future<List<FamiliaUNSPSC>> getFamiliasClasesUsuarioGrupoUNSPSC({
    required String codigo,
    required int idGrupo,
  }) {
    return apiClient.requestList(
      path: '/ServletFamiliasUNSPSCGrupoUNSPSCUsuario',
      body: {'codigo': codigo, 'idGrupo': idGrupo},
      convertFn: (it) => FamiliaUNSPSC.fromJson(it),
    );
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
  }) {
    return apiClient.requestList(
      path: '/ServletFamiliasUNSPSCUsuario',
      body: {'codigo': codigo},
      convertFn: (it) => FamiliaUNSPSC.fromJson(it),
    );
  }

  Future<List<SegmentoUNSPSC>> getSegmentosFamiliasUNSPSC({
    required String codigo,
    required int idGrupo,
  }) {
    return apiClient.requestList(
      path: '/ServletSegmentosUNSPSCFamiliasUNSPSC',
      body: {'codigo': codigo, 'idGrupo': idGrupo},
      convertFn: (it) => SegmentoUNSPSC.fromJson(it),
    );
  }

  Future<List<ValueNotificationSetting>> getMontosConfiguracion(
      {required String codigo}) async {
    return apiClient.requestList(
      path: '/ServletMontoConfiguracions',
      body: {'codigo': codigo},
      convertFn: (it) => ValueNotificationSetting.fromJson(it),
    );
  }

  Future<APIResponse> insertarMontosConfiguracion({
    required String codigo,
    required double montoInferior,
    required double montoSuperior,
  }) {
    return apiClient.post(
      path: '/ServletInsertarMontoConfiguracion',
      body: {
        'codigo': codigo,
        'montoInferior': montoInferior,
        'montoSuperior': montoSuperior,
      },
    );
  }

  Future<List<KeywordNotificationSetting>> getTextosConfiguracion(
      {required String codigo}) {
    return apiClient.requestList(
      path: '/ServletTextoContratacions',
      body: {'codigo': codigo},
      convertFn: (it) => KeywordNotificationSetting.fromJson(it),
    );
  }

  Future<APIResponse> insertarTextoContratacion({
    required String codigo,
    required String texto,
  }) {
    return apiClient.post(
      path: '/ServletInsertarTextoContratacion',
      body: {'codigo': codigo, 'texto': texto},
    );
  }
}
