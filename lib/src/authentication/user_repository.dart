import 'package:oportunidades_cce/src/api_client.dart';

class UsuarioRepository {
  UsuarioRepository({
    required this.apiClient,
  });

  final APIClient apiClient;

  Future<APIResponse> autenticar({
    required String correo,
    required String contrasena,
    required String token,
    required String uuid,
    required String plataforma,
  }) {
    return apiClient.post(
      path: '/ServletAutenticar',
      body: {
        'correo': correo,
        'contrasena': contrasena,
        'token': token,
        'uuid': uuid,
        'plataforma': plataforma,
      },
    );
  }

  Future<APIResponse> crearCuenta({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
  }) {
    return apiClient.post(
      path: '/ServletCrearCuenta',
      body: {
        'nombres': nombres,
        'apellidos': apellidos,
        'correo': correo,
        'contrasena': contrasena,
      },
    );
  }

  Future<APIResponse> olvidoContrasena({required String correo}) {
    return apiClient.post(
      path: '/ServletOlvidoContrasena',
      body: {'correo': correo},
    );
  }

  Future<APIResponse> reactivarContrasena({required String correo}) {
    return apiClient.post(
      path: '/ServletSolicitarCorreoActivacion',
      body: {'correo': correo},
    );
  }

  Future<APIResponse> solicitarBaja({required String correo}) {
    return apiClient.post(
      path: '/ServletSolicitarBaja',
      body: {'correo': correo},
    );
  }
}
