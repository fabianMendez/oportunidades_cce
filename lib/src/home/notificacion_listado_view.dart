import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oportunidades_cce/src/authentication/user_details.dart';
import 'package:oportunidades_cce/src/home/notificacion_listado_bloc.dart';
import 'package:oportunidades_cce/src/home/notificacion_repository.dart';
import 'package:oportunidades_cce/src/service_locator.dart';
import 'package:provider/provider.dart';

class NotificacionListadoView extends StatelessWidget {
  const NotificacionListadoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetails>(context);

    return BlocProvider<NotificacionListadoBloc>(
      create: (context) {
        return NotificacionListadoBloc(
          userDetails: userDetails,
          notificacionRepository: sl.get<NotificacionRepository>(),
        )..add(const NotificacionListadoStarted());
      },
      child: const NotificacionListado(),
    );
  }
}

class NotificacionListado extends StatelessWidget {
  const NotificacionListado({Key? key}) : super(key: key);

  void _refresh(BuildContext context) {
    context
        .read<NotificacionListadoBloc>()
        .add(const NotificacionListadoRefreshed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificacionListadoBloc, NotificacionListadoState>(
      builder: (context, state) {
        if (state is NotificacionListadoUninitialized ||
            state is NotificacionListadoLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (state is NotificacionListadoSuccess &&
                state.notificaciones.isEmpty)
              Container(
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  children: const [
                    Text(
                      'No hay oportunidades nuevas para tí, puedes configurar tus suscripciones para que te lleguen nuevas oportunidades.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                    // const SizedBox(height: 12),
                    // TextButton(
                    //   onPressed: _fetchFirst,
                    //   child: const Text('Reintentar'),
                    // ),
                  ],
                ),
              ),
            if (state is NotificacionListadoFailure)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '¡Rayos!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ha ocurrido un error inesperado:\n${state.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _refresh(context),
                        child: const Text('Reintentar'),
                      ),
                      // const SizedBox(height: 12),
                      SvgPicture.string(
                        '''
<svg xmlns="http://www.w3.org/2000/svg" width="690" height="448.759">
  <path d="M211.813 420.11c4.668-10.083 9.333-20.316 11.36-31.241s1.175-22.783-4.628-32.26-17.228-15.902-28.131-13.76c-8.955 1.76-16.146 8.813-20.357 16.91s-5.9 17.23-7.537 26.209c-.53-10.2-1.09-20.565-4.478-30.2s-10.06-18.615-19.57-22.343-21.878-.797-26.89 8.103c-7.06 12.538 2.302 30.125-5.817 42.006-1.393-11.917-13.855-21.333-25.7-19.416s-20.7 14.781-18.264 26.53c1.45 6.99 6.22 12.936 11.922 17.231s12.334 9.275 18.895 12.09Z" fill="#f2f2f2"/>
  <path d="M68.02 372.537c9.408 3.289 18.903 6.615 27.492 11.756 7.698 4.608 14.553 10.812 18.882 18.757a33.356 33.356 0 0 1 4.126 13.858c.063 1.018 1.655 1.025 1.592 0-.557-9.06-4.972-17.353-11.087-23.91-6.704-7.19-15.392-12.1-24.361-15.91-5.318-2.26-10.769-4.18-16.221-6.085-.969-.339-1.385 1.198-.423 1.534ZM122.287 335.004a143.383 143.383 0 0 1 13.792 30.616 145.117 145.117 0 0 1 6.36 32.968 143.305 143.305 0 0 1 .152 18.837c-.059 1.024 1.533 1.02 1.592 0a145.194 145.194 0 0 0-2.04-33.82 146.926 146.926 0 0 0-9.77-32.44 143.25 143.25 0 0 0-8.711-16.964.796.796 0 0 0-1.375.803ZM200.188 344.147a232.044 232.044 0 0 0-17.116 57.578q-1.343 8.365-2.078 16.812c-.09 1.02 1.503 1.015 1.591 0a231.21 231.21 0 0 1 12.738-58.025q2.834-7.892 6.24-15.562c.411-.928-.96-1.738-1.375-.803Z" fill="#fff"/>
  <path fill="#e6e6e6" d="m482.346 431.91.128 9.88-46.584.603-.128-9.88z"/>
  <path d="m499.027 443.996-6.653-.02-4.112-7.337 4.445-7.312 6.18.018a11.999 11.999 0 1 0 .14 14.65ZM419.208 443.996l6.653-.02 4.112-7.337-4.445-7.312-6.18.018a11.999 11.999 0 1 1-.14 14.65Z" fill="#e6e6e6"/>
  <path d="M689 420.97H1a1 1 0 0 1 0-2h688a1 1 0 0 1 0 2Z" fill="#3f3d56"/>
  <circle cx="540.486" cy="197.969" r="33" fill="#2f2e41"/>
  <path fill="#ffb8b8" d="m553.859 383.226 2.542 11.993 47.47-4.095-3.751-17.701-46.261 9.803z"/>
  <path d="m550.166 420.71-7.988-37.694 14.563-3.086 4.902 23.13a14.887 14.887 0 0 1-11.477 17.65Z" fill="#2f2e41"/>
  <path fill="#ffb8b8" d="m524.12 382.586-5.343 11.035-45.104-15.357 7.886-16.285 42.561 20.607z"/>
  <path d="m511.808 399.976 10.304-21.28 13.399 6.487-16.791 34.68a14.887 14.887 0 0 1-6.912-19.887Z" fill="#2f2e41"/>
  <path d="M435.26 360.793a10.743 10.743 0 0 0 12.708-10.48l74.374-68.571-18.47-14.306-67.337 71.944a10.8 10.8 0 0 0-1.276 21.413Z" fill="#ffb8b8"/>
  <circle cx="536.344" cy="207.898" r="24.561" fill="#ffb8b8"/>
  <path d="M558.386 352.273c-17.228 0-37.978-3.629-50.778-18.477l-.289-.335.297-.328c.097-.107 9.514-10.868.11-30.06L494.8 307.05l-12.87-16.989 7.13-21.39 29.177-23.503a26.75 26.75 0 0 1 14.61-5.79 80.21 80.21 0 0 0 27.785-7.912 27.906 27.906 0 0 1 12.8-2.799l.574.017a9.95 9.95 0 0 1 9.64 10.707c-1.978 25.63-5.472 87.544 4.792 108.861l.265.551-.592.15a136.113 136.113 0 0 1-29.724 3.32Z" fill="currentColor"/>
  <path d="M510.986 333.47s-65-6-72 13 1 28 13 32 41 9 41 9l13-16 34 2s37.885 21.972 48.36 45.473a30.762 30.762 0 0 0 25.777 18.239c8.398.584 15.863-2.588 15.863-15.713 0-30-42-73-42-73Z" fill="#2f2e41"/>
  <path d="M461.486 362.97s17-5 44 8M511.843 192.235a73.041 73.041 0 0 0 31.599 10.412l-3.33-3.991a24.477 24.477 0 0 0 7.56 1.501 8.28 8.28 0 0 0 6.75-3.159 7.702 7.702 0 0 0 .515-7.115 14.589 14.589 0 0 0-4.589-5.738 27.323 27.323 0 0 0-25.43-4.545 16.33 16.33 0 0 0-7.596 4.872 9.236 9.236 0 0 0-1.863 8.56M540.31 172.604a75.485 75.485 0 0 1 19.136-26.522c5.292-4.702 11.472-8.743 18.446-9.962s14.833.87 19.11 6.51c3.499 4.614 4.153 10.794 3.768 16.57s-1.677 11.496-1.553 17.284a35.468 35.468 0 0 0 50.527 31.351c-6.022 3.329-10.714 8.598-16.305 12.608s-12.963 6.76-19.312 4.11c-6.718-2.804-9.8-10.42-12.206-17.29l-10.732-30.64c-1.824-5.208-3.739-10.57-7.462-14.644s-9.765-6.557-14.89-4.51c-3.883 1.553-6.412 5.258-8.63 8.805s-4.557 7.32-8.303 9.18-9.299.714-10.523-3.286" fill="#2f2e41"/>
  <path fill="#e6e6e6" d="m532.728 328.27 6.897-7.078 33.366 32.514-6.896 7.077z"/>
  <path d="M566.51 354.289a9.882 9.882 0 1 0 13.975-.18 9.882 9.882 0 0 0-13.975.18Zm10.111 9.853a4.235 4.235 0 1 1-.077-5.99 4.235 4.235 0 0 1 .077 5.99ZM529.48 307.928l4.69 4.718-2.28 8.096-8.314 2.028-4.358-4.384a11.999 11.999 0 1 0 10.262-10.458Z" fill="#e6e6e6"/>
  <path d="M548.736 352.359a11.579 11.579 0 0 1-1.268-.07 11.023 11.023 0 0 1-9.68-9.682 11.003 11.003 0 0 1 10.93-12.25 10.625 10.625 0 0 1 1.467.11l33.578-35.745-3.505-11.685 17.605-7.892 4.934 12.06a20.49 20.49 0 0 1-6.177 23.673l-36.961 29.4a10.259 10.259 0 0 1 .06 1.08 11.018 11.018 0 0 1-3.664 8.196 10.872 10.872 0 0 1-7.319 2.805Z" fill="#ffb8b8"/>
  <path d="M574.986 233.47a9.453 9.453 0 0 1 12.628 5.155l17.372 43.844-27 18Z" fill="currentColor"/>
  <path d="M448.486 243.707V25.262A25.298 25.298 0 0 0 423.224 0H79.954a25.298 25.298 0 0 0-25.262 25.262v218.445a25.298 25.298 0 0 0 25.262 25.262h343.27a25.298 25.298 0 0 0 25.262-25.262Zm-368.532 22.29a22.317 22.317 0 0 1-22.29-22.29V25.262a22.317 22.317 0 0 1 22.29-22.29h343.27a22.317 22.317 0 0 1 22.29 22.29v218.445a22.317 22.317 0 0 1-22.29 22.29Z" fill="#3f3d56"/>
  <path d="M445.514 39.303H57.664a1.486 1.486 0 1 1 0-2.972h387.85a1.486 1.486 0 0 1 0 2.972Z" fill="#3f3d56"/>
  <circle cx="82.926" cy="20.804" r="7.43" fill="currentColor"/>
  <circle cx="108.188" cy="20.804" r="7.43" fill="currentColor"/>
  <circle cx="133.451" cy="20.804" r="7.43" fill="currentColor"/>
  <path d="M188.979 199.232a1 1 0 0 1-1-1c0-10.427-4.571-16.243-11.946-22.247a1 1 0 1 1 1.263-1.551c7.83 6.375 12.683 12.58 12.683 23.798a1 1 0 0 1-1 1ZM103.317 199.232a1 1 0 0 1-1-1c0-11.218 4.852-17.423 12.682-23.798a1 1 0 1 1 1.263 1.55c-7.375 6.005-11.945 11.822-11.945 22.248a1 1 0 0 1-1 1ZM180.413 130.701a1 1 0 0 1-.632-1.775c7.581-6.171 8.198-14.938 8.198-24.923a1 1 0 0 1 2 0c0 10.505-.673 19.747-8.935 26.474a.994.994 0 0 1-.63.224ZM111.882 130.166a.994.994 0 0 1-.63-.224c-8.263-6.727-8.935-15.727-8.935-25.94a1 1 0 0 1 2 0c0 10.037.603 18.206 8.197 24.389a1 1 0 0 1-.632 1.775ZM201.828 152.152h-21.415a1 1 0 0 1 0-2h21.415a1 1 0 1 1 0 2ZM111.883 152.152H90.467a1 1 0 0 1 0-2h21.416a1 1 0 0 1 0 2ZM146.148 194.948a1 1 0 0 1-1-1v-68.53a1 1 0 0 1 2 0v68.53a1 1 0 0 1-1 1Z"/>
  <path d="M146.148 194.948a35.305 35.305 0 0 1-35.265-35.265v-25.717c0-16.468 13.513-26.699 35.265-26.699 22.74 0 35.265 9.482 35.265 26.699v25.717a35.305 35.305 0 0 1-35.265 35.265Zm0-85.68c-16.081 0-33.265 6.488-33.265 24.698v25.717a33.265 33.265 0 1 0 66.53 0v-25.717c0-21.49-20.842-24.699-33.265-24.699Z"/>
  <path d="M125.651 113.441a1 1 0 0 1-.93-.63 14.088 14.088 0 0 1-.987-4.531 22.476 22.476 0 0 1 22.355-22.41h.115a22.467 22.467 0 0 1 22.36 22.357 12.227 12.227 0 0 1-.911 4.211 1 1 0 0 1-1.85-.76 10.195 10.195 0 0 0 .761-3.488 20.454 20.454 0 0 0-20.363-20.32h-.11a20.461 20.461 0 0 0-20.359 20.362 12.076 12.076 0 0 0 .847 3.838 1.001 1.001 0 0 1-.928 1.371Z"/>
  <path d="M247.71 108.003h-12a7 7 0 0 1 0-14h12a7 7 0 0 1 0 14ZM329.71 137.503h-12a7 7 0 0 1 0-14h12a7 7 0 0 1 0 14ZM367.71 137.503h-12a7 7 0 0 1 0-14h12a7 7 0 0 1 0 14ZM405.71 137.503h-12a7 7 0 0 1 0-14h12a7 7 0 0 1 0 14ZM330.71 108.503h-56a7 7 0 0 1 0-14h56a7 7 0 0 1 0 14ZM291.71 136.503h-56a7 7 0 0 1 0-14h56a7 7 0 0 1 0 14ZM401.71 108.503h-43a7 7 0 0 1 0-14h43a7 7 0 0 1 0 14ZM247.71 167.003h-12a7 7 0 0 1 0-14h12a7 7 0 0 1 0 14ZM330.71 167.503h-56a7 7 0 0 1 0-14h56a7 7 0 0 1 0 14ZM401.71 167.503h-43a7 7 0 0 1 0-14h43a7 7 0 0 1 0 14ZM382.71 191.003a7.008 7.008 0 0 1 7-7h12a7 7 0 0 1 0 14h-12a7.008 7.008 0 0 1-7-7ZM299.71 191.503a7.008 7.008 0 0 1 7-7h56a7 7 0 0 1 0 14h-56a7.008 7.008 0 0 1-7-7ZM228.71 191.503a7.008 7.008 0 0 1 7-7h43a7 7 0 0 1 0 14h-43a7.008 7.008 0 0 1-7-7Z" fill="#ccc"/>
</svg>
''',
                        currentColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
