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

class APIException extends Equatable implements Exception {
  const APIException({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
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

  Future<T> request<T>({
    required String path,
    required Map<String, Object?> body,
    required T Function(dynamic) convertFn,
  }) async {
    final uri = Uri.parse('$baseURL$path');
    final encodedBody = _encodeUrlParameters(body);
    print(encodedBody);
    /*
    var connectivityResult = await (Connectivity().checkConnectivity());
    InternetAddress.lookup('host');
    curl -I https://oportunidades.colombiacompra.gov.co/app
HTTP/2 502
content-type: text/html
server: ZENEDGE
x-cache-status: NOTCACHED
content-length: 145
date: Wed, 22 Sep 2021 20:57:39 GMT
x-zen-fury: cf2b98b8aca4c6a635eb08572486412a17695675
x-cdn: Served-By-Zenedge
*/

    final response = await httpClient.post(
      uri,
      body: encodedBody,
      headers: {
        'Authorization': 'OAuth2: token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      encoding: Encoding.getByName('utf8'),
    );

    final obj = json.decode(response.body);
    if (obj is Map<String, dynamic>) {
      if (obj['respuesta'] == 'No_Exito') {
        throw const APIException(message: 'No éxito');
      }
    }

    return convertFn(obj);
  }

  Future<List<T>> requestList<T>({
    required String path,
    required Map<String, Object?> body,
    required T Function(dynamic) convertFn,
  }) {
    return request(
      path: path,
      body: body,
      convertFn: (dynamic obj) {
        final List<dynamic> list = obj;
        return list.map((it) => convertFn(it)).toList();
      },
    );
  }

  Future<APIResponse> post({
    required String path,
    required Map<String, Object?> body,
  }) {
    return request(
      path: path,
      body: body,
      convertFn: (map) => APIResponse.fromJson(map),
    );
  }
}
