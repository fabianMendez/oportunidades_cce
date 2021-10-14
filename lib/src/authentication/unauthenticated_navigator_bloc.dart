import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class UnauthenticatedNavigatorBloc
    extends Bloc<UnauthenticatedNavigatorEvent, UnauthenticatedNavigatorState> {
  UnauthenticatedNavigatorBloc()
      : super(UnauthenticatedNavigatorState.initial) {
    on<LoginViewPushed>((_, emit) {
      emit(const UnauthenticatedNavigatorState(isLoginView: true));
    });

    on<RegisterViewPushed>((_, emit) {
      emit(const UnauthenticatedNavigatorState(isRegisterView: true));
    });

    on<ForgotPasswordViewPushed>((_, emit) {
      emit(const UnauthenticatedNavigatorState(
        isForgotPasswordView: true,
        isLoginView: true,
      ));
    });

    on<UnauthenticatedNavigatorPopped>((_, emit) {
      if (state.isForgotPasswordView) {
        emit(const UnauthenticatedNavigatorState(isLoginView: true));
      } else {
        emit(UnauthenticatedNavigatorState.initial);
      }
    });
  }
}

abstract class UnauthenticatedNavigatorEvent extends Equatable {
  const UnauthenticatedNavigatorEvent();

  @override
  List<Object?> get props => [];
}

class UnauthenticatedNavigatorPopped extends UnauthenticatedNavigatorEvent {
  const UnauthenticatedNavigatorPopped({
    this.result,
  });

  final dynamic result;

  @override
  List<Object?> get props => [...super.props, result];
}

class LoginViewPushed extends UnauthenticatedNavigatorEvent {
  const LoginViewPushed();
}

class RegisterViewPushed extends UnauthenticatedNavigatorEvent {
  const RegisterViewPushed();
}

class ForgotPasswordViewPushed extends UnauthenticatedNavigatorEvent {
  const ForgotPasswordViewPushed();
}

class UnauthenticatedNavigatorState extends Equatable {
  const UnauthenticatedNavigatorState({
    this.isLoginView = false,
    this.isRegisterView = false,
    this.isForgotPasswordView = false,
  });

  static const UnauthenticatedNavigatorState initial =
      UnauthenticatedNavigatorState();

  final bool isLoginView;
  final bool isRegisterView;
  final bool isForgotPasswordView;

  @override
  List<Object?> get props => [
        isLoginView,
        isRegisterView,
        isForgotPasswordView,
      ];
}
