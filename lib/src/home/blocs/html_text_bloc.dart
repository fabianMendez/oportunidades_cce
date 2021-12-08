import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oportunidades_cce/src/home/texto_repository.dart';

class HTMLTextBloc extends Bloc<HTMLTextEvent, HTMLTextState> {
  HTMLTextBloc({
    required String textCode,
    required TextoRepository textoRepository,
  }) : super(const HTMLTextInitial()) {
    on<HTMLTextStarted>((_, emit) async {
      emit(const HTMLTextLoading());
      try {
        final text = await textoRepository.getTextoSinAutenticar(textCode);
        emit(
          HTMLTextReady(
            data: text.data.replaceAll(
              '12pt',
              '1.2rem',
            ),
          ),
        );
      } catch (err, str) {
        log('$err');
        log('$str');
        emit(HTMLTextFailure(err.toString()));
      }
    });
  }
}

abstract class HTMLTextEvent extends Equatable {
  const HTMLTextEvent();

  @override
  List<Object?> get props => [];
}

class HTMLTextStarted extends HTMLTextEvent {
  const HTMLTextStarted();
}

abstract class HTMLTextState extends Equatable {
  const HTMLTextState();

  @override
  List<Object?> get props => [];
}

class HTMLTextInitial extends HTMLTextState {
  const HTMLTextInitial();
}

class HTMLTextLoading extends HTMLTextState {
  const HTMLTextLoading();
}

class HTMLTextReady extends HTMLTextState {
  const HTMLTextReady({
    required this.data,
  });

  final String data;

  @override
  List<Object?> get props => [...super.props, data];
}

class HTMLTextFailure extends HTMLTextState {
  const HTMLTextFailure(this.error);
  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
