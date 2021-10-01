import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/api_client.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';

class SavedFilter extends Equatable {
  const SavedFilter({
    this.id = 0,
    this.nombre = '',
    this.recibirNotificacionesApp = false,
    this.recibirNotificacionesCorreo = false,
    this.rangos = const [],
    this.textos = const [],
    this.familias = const [],
  });

  SavedFilter.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        nombre = map['nombre'],
        recibirNotificacionesApp = map['recibirNotificacionesApp'],
        recibirNotificacionesCorreo = map['recibirNotificacionesCorreo'],
        rangos = map['rangos']
            .map((elm) => ValueNotificationSetting.fromJson(elm))
            .toList()
            .cast<ValueNotificationSetting>(),
        textos = map['textos']
            .map((elm) => KeywordNotificationSetting.fromJson(elm))
            .toList()
            .cast<KeywordNotificationSetting>(),
        familias = map['familias']
            .map((elm) => GrupoUNSPSC.fromJson(elm))
            .toList()
            .cast<GrupoUNSPSC>();

  final int id;
  final String nombre;
  final bool recibirNotificacionesApp;
  final bool recibirNotificacionesCorreo;
  final List<ValueNotificationSetting> rangos;
  final List<KeywordNotificationSetting> textos;
  final List<GrupoUNSPSC> familias;

  bool get isEmpty =>
      rangos.isEmpty &&
      (textos.isEmpty || textos.every((it) => it.texto.isEmpty)) &&
      familias.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [
        id,
        recibirNotificacionesApp,
        recibirNotificacionesCorreo,
        nombre,
        rangos,
        textos,
        familias,
      ];
}

class FiltroRepository {
  FiltroRepository({
    required this.apiClient,
  });

  final APIClient apiClient;

  Future<List<SavedFilter>> getFiltros({required String codigo}) {
    return apiClient.requestList(
      path: '/ServletFiltros',
      body: {'codigo': codigo},
      convertFn: (it) => SavedFilter.fromJson(it),
    );

    // final c = JsonEncoder.withIndent('  ');
    // final obj = json.decode(resp.body);
    // final str = c.convert(obj);
    // str.split('\n').forEach(print);
  }
}
