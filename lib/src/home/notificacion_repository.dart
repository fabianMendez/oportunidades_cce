import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/api_client.dart';

class Notificacion extends Equatable {
  const Notificacion();

  const Notificacion.fromJson(Map<String, dynamic> map);

  @override
  List<Object?> get props => [];
}

class NotificacionRepository {
  NotificacionRepository({
    required this.apiClient,
  });

  final APIClient apiClient;

  /*
<!-- 	<option value = 'Todos'>Todos</option> -->
<!-- 	<option value = 'CreacionProceso'>Nuevos procesos</option> -->
<!-- 	<option value = 'CreacionProcesoEntidad'>Nuevo proceso entidad</option> -->
<!-- 	<option value = 'ActualizacionProceso'>Actualizaci&oacute;n de procesos</option> -->
  */
  Future<List<Notificacion>> getNotificaciones({
    required String codigo,
    required String tipoNotificacion,
  }) {
    return apiClient.requestList(
      path: '/ServletNotificaciones',
      body: {
        'codigo': codigo,
        'tipoNotificacion': tipoNotificacion,
      },
      convertFn: (it) => Notificacion.fromJson(it),
    );
  }
}
