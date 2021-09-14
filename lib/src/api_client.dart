import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:http/http.dart' as http;

final _unescape = HtmlUnescape();

class APIResponse extends Equatable {
  const APIResponse({
    required this.message,
    required this.successful,
    this.objeto,
  });

  APIResponse.fromJson(Map<String, dynamic> map)
      : message = _unescape.convert(map['mensaje']),
        successful = map['respuesta'] == 'exito',
        objeto = map['objeto'];

  final String message;
  final bool successful;
  final String? objeto;

  @override
  List<Object?> get props => [message, successful, objeto];
}

class APIClient {
  APIClient({
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

  Future<APIResponse> post({
    required String path,
    required Map<String, Object?> body,
  }) async {
    final uri = Uri.parse('$baseURL$path');
    return await httpClient
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
}
