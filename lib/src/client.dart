import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

class APIResponse extends Equatable {
  const APIResponse({
    required this.message,
    required this.successful,
  });

  APIResponse.fromJson(Map<String, dynamic> map)
      : message = map['mensaje'],
        successful = map['respuesta'] == 'exito';

  final String message;
  final bool successful;

  @override
  List<Object?> get props => [message, successful];
}

class Client {
  Client({
    this.baseURL = 'https://oportunidades.colombiacompra.gov.co/app',
    required this.httpClient,
  });

  final String baseURL;
  final http.Client httpClient;

  String _encodeUrlParameters(Map<String, Object?> parameters) {
    final List<String> parts = <String>[];
    for (String key in parameters.keys) {
      final String part = Uri.encodeComponent(key) +
          '=' +
          Uri.encodeComponent(parameters[key]?.toString() ?? '');
      parts.add(part);
    }

    return parts.join('&');
  }

  Future<void> autenticar({
    required String correo,
    required String contrasena,
    required String token,
    required String uuid,
    required String plataforma,
  }) async {
    final uri = Uri.parse('$baseURL/ServletAutenticar');
    final body = {
      'correo': correo,
      'contrasena': contrasena,
      'token': token,
      'uuid': uuid,
      'plataforma': plataforma,
    };

    await httpClient
        .post(
      uri,
      body: _encodeUrlParameters(body),
      headers: {
        'Authorization': 'OAuth2: token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf8'),
    )
        .then<APIResponse>(
      (http.Response response) {
        print(response.body);
        final map = json.decode(response.body);
        return APIResponse.fromJson(map);
      },
    );
  }

  Future<void> crearCuenta({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
  }) async {
    final uri = Uri.parse('$baseURL/ServletCrearCuenta');
    final body = {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'contrasena': contrasena,
    };

    await httpClient
        .post(
      uri,
      body: _encodeUrlParameters(body),
      headers: {
        'Authorization': 'OAuth2: token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf8'),
    )
        .then<APIResponse>(
      (http.Response response) {
        final map = json.decode(response.body);
        return APIResponse.fromJson(map);
      },
    );
  }
}
