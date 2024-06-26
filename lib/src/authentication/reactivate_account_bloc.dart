import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';

class ReactivateAccountBloc
    extends Bloc<ReactivateAccountEvent, ReactivateAccountState> {
  ReactivateAccountBloc({
    required this.usuarioRepository,
  }) : super(const ReactivateAccountInitial()) {
    on<ReactivateAccountSubmitted>((event, emit) async {
      emit(const ReactivateAccountLoading());

      if (event.email.trim().isEmpty) {
        emit(const ReactivateAccountFailure('Correo requerido'));
        return;
      }

      if (!EmailValidator.validate(event.email)) {
        emit(const ReactivateAccountFailure('El correo no es válido'));
        return;
      }

      try {
        final response = await usuarioRepository.reactivarContrasena(
          correo: event.email,
        );

        if (response.successful) {
          emit(const ReactivateAccountSuccess());
        } else {
          emit(ReactivateAccountFailure(response.message));
        }
      } catch (err, str) {
        log('$err');
        log('$str');
        emit(ReactivateAccountFailure(err.toString()));
      }
    });
  }

  final UsuarioRepository usuarioRepository;
}

abstract class ReactivateAccountEvent extends Equatable {
  const ReactivateAccountEvent();

  @override
  List<Object> get props => <Object>[];
}

class ReactivateAccountSubmitted extends ReactivateAccountEvent {
  const ReactivateAccountSubmitted({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => <Object>[email];
}

abstract class ReactivateAccountState extends Equatable {
  const ReactivateAccountState();

  @override
  List<Object> get props => <Object>[];
}

class ReactivateAccountInitial extends ReactivateAccountState {
  const ReactivateAccountInitial();
}

class ReactivateAccountSuccess extends ReactivateAccountState {
  const ReactivateAccountSuccess();
}

class ReactivateAccountLoading extends ReactivateAccountState {
  const ReactivateAccountLoading();
}

class ReactivateAccountFailure extends ReactivateAccountState {
  const ReactivateAccountFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
