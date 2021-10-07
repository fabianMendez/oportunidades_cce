import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/api_client.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/authentication/user_repository.dart';

class UserInformationBloc
    extends Bloc<UserInformationEvent, UserInformationState> {
  UserInformationBloc({
    required UserDetails userDetails,
    required UsuarioRepository usuarioRepository,
    required AuthenticationBloc authenticationBloc,
  }) : super(
          UserInformationInitial(userDetails: userDetails),
        ) {
    on<UserInformationUpdated>((event, emit) async {
      emit(state.loading());
      try {
        final response = await usuarioRepository.actualizarUsuario(
          codigo: userDetails.codigo,
          nombres: event.firstName,
          apellidos: event.lastName,
          recibirCorreos: event.receiveNotifications,
        );

        if (response.successful) {
          final map = json.decode(response.objeto!);
          final usuario = Usuario.fromJson(map);

          final updatedUserDetails = UserDetails(
            codigo: userDetails.codigo,
            estado: userDetails.estado,
            id: userDetails.id,
            uuid: userDetails.uuid,
            token: userDetails.token,
            usuario: usuario,
          );

          emit(state.success(updatedUserDetails));
          authenticationBloc.add(UserUpdated(userDetails: updatedUserDetails));
        } else {
          emit(state.failure(response.message));
        }
      } catch (err, str) {
        if (err is APIException) {
          emit(state.failure(err.message));
        } else {
          print(err);
          print(str);

          emit(state.failure(err.toString()));
        }
      }
    });
  }
}

abstract class UserInformationEvent extends Equatable {
  const UserInformationEvent();

  @override
  List<Object?> get props => [];
}

class UserInformationUpdated extends UserInformationEvent {
  const UserInformationUpdated({
    required this.firstName,
    required this.lastName,
    required this.receiveNotifications,
  });

  final String firstName;
  final String lastName;
  final bool receiveNotifications;

  @override
  List<Object?> get props => [
        ...super.props,
        firstName,
        lastName,
        receiveNotifications,
      ];
}

abstract class UserInformationState extends Equatable {
  const UserInformationState({
    required this.userDetails,
  });

  final UserDetails userDetails;

  UserInformationLoading loading() {
    return UserInformationLoading(userDetails: userDetails);
  }

  UserInformationSuccess success(UserDetails userDetails) {
    return UserInformationSuccess(userDetails: userDetails);
  }

  UserInformationFailure failure(String error) {
    return UserInformationFailure(error, userDetails: userDetails);
  }

  @override
  List<Object?> get props => [userDetails];
}

class UserInformationInitial extends UserInformationState {
  const UserInformationInitial({
    required UserDetails userDetails,
  }) : super(userDetails: userDetails);
}

class UserInformationLoading extends UserInformationState {
  const UserInformationLoading({
    required UserDetails userDetails,
  }) : super(userDetails: userDetails);
}

class UserInformationSuccess extends UserInformationState {
  const UserInformationSuccess({
    required UserDetails userDetails,
  }) : super(userDetails: userDetails);
}

class UserInformationFailure extends UserInformationState {
  const UserInformationFailure(
    this.error, {
    required UserDetails userDetails,
  }) : super(userDetails: userDetails);

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
