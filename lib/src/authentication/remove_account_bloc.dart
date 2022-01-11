import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';

class RemoveAccountBloc extends Bloc<RemoveAccountEvent, RemoveAccountState> {
  RemoveAccountBloc({
    required this.usuarioRepository,
  }) : super(const RemoveAccountInitial()) {
    on<RemoveAccountSubmitted>((event, emit) async {
      emit(const RemoveAccountLoading());

      if (event.email.trim().isEmpty) {
        emit(const RemoveAccountFailure('Correo requerido'));
        return;
      }

      if (!EmailValidator.validate(event.email)) {
        emit(const RemoveAccountFailure('El correo no es válido'));
        return;
      }

      try {
        final response = await usuarioRepository.solicitarBaja(
          correo: event.email,
        );

        if (response.successful) {
          emit(const RemoveAccountSuccess());
        } else {
          emit(RemoveAccountFailure(response.message));
        }
      } catch (err, str) {
        print(err);
        print(str);
        emit(RemoveAccountFailure(err.toString()));
      }
    });
  }

  final UsuarioRepository usuarioRepository;
}

abstract class RemoveAccountEvent extends Equatable {
  const RemoveAccountEvent();

  @override
  List<Object> get props => <Object>[];
}

class RemoveAccountSubmitted extends RemoveAccountEvent {
  const RemoveAccountSubmitted({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => <Object>[email];
}

abstract class RemoveAccountState extends Equatable {
  const RemoveAccountState();

  @override
  List<Object> get props => <Object>[];
}

class RemoveAccountInitial extends RemoveAccountState {
  const RemoveAccountInitial();
}

class RemoveAccountSuccess extends RemoveAccountState {
  const RemoveAccountSuccess();
}

class RemoveAccountLoading extends RemoveAccountState {
  const RemoveAccountLoading();
}

class RemoveAccountFailure extends RemoveAccountState {
  const RemoveAccountFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
