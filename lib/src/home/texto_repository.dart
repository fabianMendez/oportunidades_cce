import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/api_client.dart';

class Texto extends Equatable {
  const Texto({
    required this.codigo,
    required this.estado,
    required this.data,
    required this.id,
  });

  final String codigo;
  final int estado;
  final String data;
  final int id;

  Texto.fromJson(Map<String, dynamic> map)
      : codigo = map['codigo'],
        estado = map['estado'],
        data = map['data'],
        id = map['id'];

  @override
  List<Object?> get props => [codigo, estado, data, id];
}

class TextoRepository {
  TextoRepository({
    required this.apiClient,
  });

  final APIClient apiClient;

  Future<Texto> getTextoSinAutenticar(String codigoTexto) {
    return apiClient.request(
      path: '/ServletTextosSinAutenticar',
      body: {'codigoTexto': codigoTexto},
      convertFn: (it) => Texto.fromJson(it),
    );
  }
}
