import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:oportunidades_cce/src/authentication/user_details_secure_storage.dart';
import 'package:oportunidades_cce/src/authentication/user_details_storage.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  final http.Client httpClient = http.Client();

  sl.registerSingleton(UsuarioRepository(httpClient: httpClient));

  sl.registerSingleton<UserDetailsStorage>(UserDetailsSecureStorage());
}
