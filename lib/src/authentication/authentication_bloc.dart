import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/authentication/user_details_storage.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required this.userDetailsStorage,
  }) : super(const AuthenticationUninitialized()) {
    on<LoggedOut>((event, emit) async {
      try {
        emit(const AuthenticationLoading());

        await userDetailsStorage.deleteUserDetails();
      } finally {
        emit(const AuthenticationUnauthenticated());
      }
    });

    on<LoggedIn>((event, emit) async {
      final userDetails = event.userDetails;
      try {
        emit(const AuthenticationLoading());

        await userDetailsStorage.saveUserDetails(userDetails);
        emit(AuthenticationSuccessful(userDetails: userDetails));
      } catch (err, trace) {
        log('$err');
        log('$trace');
        await userDetailsStorage.deleteUserDetails();
        emit(const AuthenticationUnauthenticated());
      }
    });

    on<UserUpdated>((event, emit) async {
      final userDetails = event.userDetails;
      try {
        await userDetailsStorage.saveUserDetails(userDetails);
        emit(AuthenticationSuccessful(userDetails: userDetails));
      } catch (err, trace) {
        log('$err');
        log('$trace');
      }
    });

    on<AppStarted>((event, emit) async {
      final hasUserDetails = await userDetailsStorage.hasUserDetails();
      if (!hasUserDetails) {
        emit(const AuthenticationUnauthenticated());
        return;
      }

      try {
        emit(const AuthenticationLoading());

        final userDetails = await userDetailsStorage.getUserDetails();
        emit(AuthenticationSuccessful(userDetails: userDetails));
      } catch (err, trace) {
        log('$err');
        log('$trace');
        await userDetailsStorage.deleteUserDetails();
        emit(const AuthenticationUnauthenticated());
      }
    });
  }

  final UserDetailsStorage userDetailsStorage;
}

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthenticationEvent {
  const AppStarted();
}

class LoggedIn extends AuthenticationEvent {
  const LoggedIn({required this.userDetails});

  final UserDetails userDetails;

  @override
  List<Object?> get props => [...super.props, userDetails];
}

class LoggedOut extends AuthenticationEvent {
  const LoggedOut();
}

class UserUpdated extends AuthenticationEvent {
  const UserUpdated({required this.userDetails});

  final UserDetails userDetails;

  @override
  List<Object?> get props => [...super.props, userDetails];
}

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {
  const AuthenticationUninitialized();
}

class AuthenticationUnauthenticated extends AuthenticationState {
  const AuthenticationUnauthenticated();
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();
}

class AuthenticationSuccessful extends AuthenticationState {
  const AuthenticationSuccessful({
    required this.userDetails,
  });

  final UserDetails userDetails;

  @override
  List<Object?> get props => [...super.props, userDetails];
}
