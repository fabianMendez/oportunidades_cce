import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/authentication/user_details_storage.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required this.userDetailsStorage,
  }) : super(const AuthenticationUninitialized());

  final UserDetailsStorage userDetailsStorage;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is LoggedOut) {
      try {
        yield const AuthenticationLoading();

        await userDetailsStorage.deleteUserDetails();
      } finally {
        yield const AuthenticationUnauthenticated();
      }
    } else if (event is LoggedIn) {
      final userDetails = event.userDetails;
      try {
        yield const AuthenticationLoading();

        await userDetailsStorage.saveUserDetails(userDetails);
        yield AuthenticationSuccessful(userDetails: userDetails);
      } catch (err, trace) {
        print(err);
        print(trace);
        await userDetailsStorage.deleteUserDetails();
        yield const AuthenticationUnauthenticated();
      }
    } else if (event is UserUpdated) {
      final userDetails = event.userDetails;
      try {
        await userDetailsStorage.saveUserDetails(userDetails);
        yield AuthenticationSuccessful(userDetails: userDetails);
      } catch (err, trace) {
        print(err);
        print(trace);
      }
    } else if (event is AppStarted) {
      final hasUserDetails = await userDetailsStorage.hasUserDetails();
      if (!hasUserDetails) {
        yield const AuthenticationUnauthenticated();
        return;
      }

      try {
        yield const AuthenticationLoading();

        final userDetails = await userDetailsStorage.getUserDetails();
        yield AuthenticationSuccessful(userDetails: userDetails);
      } catch (err, trace) {
        print(err);
        print(trace);
        await userDetailsStorage.deleteUserDetails();
        yield const AuthenticationUnauthenticated();
      }
    }
  }
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
