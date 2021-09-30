import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:oportunidades_cce/src/api_client.dart';
import 'package:oportunidades_cce/src/authentication/user_details_secure_storage.dart';
import 'package:oportunidades_cce/src/authentication/user_details_storage.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';
import 'package:oportunidades_cce/src/home/entidad_repository.dart';
import 'package:oportunidades_cce/src/home/filtro_repository.dart';
import 'package:oportunidades_cce/src/home/grupo_unspsc_repository.dart';
import 'package:oportunidades_cce/src/home/notificacion_repository.dart';
import 'package:oportunidades_cce/src/home/proceso_repository.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  final httpClient = http.Client();
  final apiClient = APIClient(httpClient: httpClient);

  sl.registerSingleton(UsuarioRepository(apiClient: apiClient));

  sl.registerSingleton<UserDetailsStorage>(UserDetailsSecureStorage());

  sl.registerSingleton(NotificacionRepository(apiClient: apiClient));

  sl.registerSingleton(GrupoUNSPSCRepository(apiClient: apiClient));

  sl.registerSingleton(ProcesoRepository(apiClient: apiClient));

  sl.registerSingleton(EntidadRepository(apiClient: apiClient));

  sl.registerSingleton(FiltroRepository(apiClient: apiClient));
}
