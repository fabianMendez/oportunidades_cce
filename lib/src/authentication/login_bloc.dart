import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/api_client.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';

import 'authentication_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.usuarioRepository,
    required this.authenticationBloc,
  }) : super(const LoginInitial());

  final UsuarioRepository usuarioRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  Stream<LoginState> mapEventToState(event) async* {
    if (event is LoginSubmitted) {
      yield const LoginLoading();

      if (event.username.trim().isEmpty || event.password.trim().isEmpty) {
        yield const LoginFailure('Correo y contraseña requeridos');
        return;
      }

      try {
        const token = '';
        const uuid = '1234567890';

        final response = await usuarioRepository.autenticar(
          correo: event.username,
          contrasena: event.password,
          token: token,
          uuid: uuid,
          // TODO(fmendez): calcular valor
          plataforma: 'Android',
        );

        if (response.successful) {
          final map = json.decode(response.objeto!);
          final userDetails = UserDetails.fromJson(map);

          authenticationBloc.add(LoggedIn(
            userDetails: userDetails,
          ));

          yield const LoginInitial();
        } else {
          yield LoginFailure(response.message);
        }
      } catch (err, str) {
        if (err is APIException) {
          yield LoginFailure(err.message);
        } else {
          print(err);
          print(str);
          yield LoginFailure(err.toString());
        }
      }
    }
  }
}

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => <Object>[username, password];
}

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => <Object>[];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginFailure extends LoginState {
  const LoginFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
