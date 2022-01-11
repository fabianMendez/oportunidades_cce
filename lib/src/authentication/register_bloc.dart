import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';

import 'authentication_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required this.usuarioRepository,
    required this.authenticationBloc,
  }) : super(const RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(const RegisterLoading());

      if (event.firstName.trim().isEmpty) {
        emit(const RegisterFailure('Nombres requeridos'));
        return;
      }

      if (event.lastName.trim().isEmpty) {
        emit(const RegisterFailure('Apellidos requeridos'));
        return;
      }

      if (event.email.trim().isEmpty) {
        emit(const RegisterFailure('Correo requerido'));
        return;
      }

      if (!EmailValidator.validate(event.email)) {
        emit(const RegisterFailure('El correo no es válido'));
        return;
      }

      if (event.password.trim().isEmpty) {
        emit(const RegisterFailure('Contraseña requerida'));
        return;
      }

      if (event.password.trim().length < 8) {
        emit(const RegisterFailure(
            'La contraseña debe tener por lo menos 8 caracteres'));
        return;
      }

      if (!event.termsAndConditions) {
        emit(const RegisterFailure('Debes aceptar los términos y condiciones'));
        return;
      }

      if (!event.privacyPolicy) {
        emit(const RegisterFailure(
            'Debe autorizar la política de tratamiento de datos'));
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
          emit(const RegisterSuccess());
        } else {
          emit(RegisterFailure(response.message));
        }
      } catch (err, str) {
        print(err);
        print(str);
        emit(RegisterFailure(err.toString()));
      }
    });
  }

  final UsuarioRepository usuarioRepository;
  final AuthenticationBloc authenticationBloc;
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
    required this.termsAndConditions,
    required this.privacyPolicy,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool termsAndConditions;
  final bool privacyPolicy;

  @override
  List<Object> get props => <Object>[
        firstName,
        lastName,
        email,
        password,
        termsAndConditions,
        privacyPolicy,
      ];
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
