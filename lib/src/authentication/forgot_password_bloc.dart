import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required this.usuarioRepository,
  }) : super(const ForgotPasswordInitial());

  final UsuarioRepository usuarioRepository;

  @override
  Stream<ForgotPasswordState> mapEventToState(event) async* {
    if (event is ForgotPasswordSubmitted) {
      yield const ForgotPasswordLoading();

      if (event.email.trim().isEmpty) {
        yield const ForgotPasswordFailure('Correo requerido');
        return;
      }

      if (!EmailValidator.validate(event.email)) {
        yield const ForgotPasswordFailure('El correo no es válido');
        return;
      }

      try {
        final response = await usuarioRepository.olvidoContrasena(
          correo: event.email,
        );

        if (response.successful) {
          yield const ForgotPasswordSuccess();
        } else {
          yield ForgotPasswordFailure(response.message);
        }
      } catch (err, str) {
        print(err);
        print(str);
        yield ForgotPasswordFailure(err.toString());
      }
    }
  }
}

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => <Object>[];
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => <Object>[email];
}

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => <Object>[];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

class ForgotPasswordFailure extends ForgotPasswordState {
  const ForgotPasswordFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
