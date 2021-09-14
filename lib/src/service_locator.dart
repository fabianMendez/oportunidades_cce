import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:oportunidades_cce/src/api_client.dart';
import 'package:oportunidades_cce/src/authentication/user_details_secure_storage.dart';
import 'package:oportunidades_cce/src/authentication/user_details_storage.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/home/notificacion_repository.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  final httpClient = http.Client();
  final apiClient = APIClient(httpClient: httpClient);

  sl.registerSingleton(UsuarioRepository(apiClient: apiClient));

  sl.registerSingleton<UserDetailsStorage>(UserDetailsSecureStorage());

  sl.registerSingleton(NotificacionRepository(apiClient: apiClient));
}
