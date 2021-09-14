import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';

import 'authentication_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required this.usuarioRepository,
    required this.authenticationBloc,
  }) : super(const RegisterInitial());

  final UsuarioRepository usuarioRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  Stream<RegisterState> mapEventToState(event) async* {
    if (event is RegisterSubmitted) {
      yield const RegisterLoading();

      if (event.firstName.trim().isEmpty) {
        yield const RegisterFailure('Nombres requeridos');
        return;
      }

      if (event.lastName.trim().isEmpty) {
        yield const RegisterFailure('Apellidos requeridos');
        return;
      }

      if (event.email.trim().isEmpty) {
        yield const RegisterFailure('Correo requerido');
        return;
      }

      if (!EmailValidator.validate(event.email)) {
        yield const RegisterFailure('El correo no es válido');
        return;
      }

      if (event.password.trim().isEmpty) {
        yield const RegisterFailure('Contraseña requerida');
        return;
      }

      if (event.password.trim().length < 8) {
        yield const RegisterFailure(
            'La contraseña debe tener por lo menos 8 caracteres');
        return;
      }

      try {
        final response = await usuarioRepository.crearCuenta(
          nombres: event.firstName,
          apellidos: event.lastName,
          correo: event.email,
          contrasena: event.password,
        );

        if (response.successful) {
          // authenticationBloc.add(const LoggedIn());
          yield const RegisterSuccess();
        } else {
          yield RegisterFailure(response.message);
        }
      } catch (err, str) {
        print(err);
        print(str);
        yield RegisterFailure(err.toString());
      }
    }
  }
}

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => <Object>[];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  @override
  List<Object> get props => <Object>[firstName, lastName, email, password];
}

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => <Object>[];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterFailure extends RegisterState {
  const RegisterFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
