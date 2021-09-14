import 'package:equatable/equatable.dart';

class UserDetails extends Equatable {
  const UserDetails({
    required this.codigo,
    required this.estado,
    required this.id,
    required this.uuid,
    required this.token,
    required this.usuario,
  });

  UserDetails.fromJson(Map<String, dynamic> map)
      : codigo = map['codigo'],
        estado = map['estado'],
        id = map['id'],
        uuid = map['uuid'],
        token = map['token'],
        usuario = Usuario.fromJson(map['usuario']);

  final String codigo;
  final int estado;
  final int id;
  final String uuid;
  final String token;
  final Usuario usuario;

  static const kInvalid = UserDetails(
    codigo: '',
    estado: 0,
    id: 0,
    uuid: '',
    token: '',
    usuario: Usuario.kInvalid,
  );

  bool get isValid => this != kInvalid;

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'estado': estado,
      'id': id,
      'uuid': uuid,
      'token': token,
      'usuario': usuario.toJson(),
    };
  }

  @override
  List<Object?> get props => [codigo, estado, id, uuid, token, usuario];
}

class Usuario extends Equatable {
  const Usuario({
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.estado,
    required this.id,
    required this.enviarCorreo,
    required this.aceptoTerminosCondiciones,
    required this.fechaAceptacionTerminosCondiciones,
  });

  Usuario.fromJson(Map<String, dynamic> map)
      : nombres = map['nombres'],
        apellidos = map['apellidos'],
        correo = map['correo'],
        estado = map['estado'],
        id = map['id'],
        enviarCorreo = map['enviarCorreo'],
        aceptoTerminosCondiciones = map['aceptoTerminosCondiciones'],
        fechaAceptacionTerminosCondiciones =
            map['fechaAceptacionTerminosCondiciones'];

  final String nombres;
  final String apellidos;
  final String correo;
  final int estado;
  final int id;
  final bool enviarCorreo;
  final bool aceptoTerminosCondiciones;
  final String fechaAceptacionTerminosCondiciones;

  static const kInvalid = Usuario(
    nombres: '',
    apellidos: '',
    correo: '',
    estado: 0,
    id: 0,
    enviarCorreo: false,
    aceptoTerminosCondiciones: false,
    fechaAceptacionTerminosCondiciones: '',
  );

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'estado': estado,
      'id': id,
      'enviarCorreo': enviarCorreo,
      'aceptoTerminosCondiciones': aceptoTerminosCondiciones,
      'fechaAceptacionTerminosCondiciones': fechaAceptacionTerminosCondiciones,
    };
  }

  @override
  List<Object?> get props => [
        nombres,
        apellidos,
        correo,
        estado,
        id,
        enviarCorreo,
        aceptoTerminosCondiciones,
        fechaAceptacionTerminosCondiciones,
      ];
}
