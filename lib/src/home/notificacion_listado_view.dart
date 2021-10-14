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

        if (state is NotificacionListadoSuccess &&
            state.notificaciones.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text(
                        'No hay oportunidades nuevas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Puedes configurar tus suscripciones para que te lleguen nuevas oportunidades.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  LayoutBuilder(builder: (_, constraints) {
                    return SvgPicture.string(
                      '''
<svg data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1055.523 852.056">
  <ellipse cx="502.363" cy="821.89" rx="250.304" ry="8.939" fill="#3f3d56"/>
  <circle cx="385.682" cy="332.888" r="89.563" fill="#ff6584"/>
  <ellipse cx="280.159" cy="791.481" rx="75.486" ry="6.958" fill="#3f3d56"/>
  <path d="M417.676 822.501s62.652-167.07 28.113-269.883-61.848-98.797-61.848-98.797-46.587-12.048-104.42 23.294-73.093 45.784-106.025 31.326-39.358-36.949-119.68-34.539c0 0 42.57-23.293 84.338-2.41s69.88 32.13 112.452 0 101.206-73.896 158.235-48.996c0 0-41.768-40.965-55.423-40.965s-77.912-6.425-98.796-28.112c0 0-29.72-20.884-82.732 30.522s-40.161 51.406-87.551 47.39S0 404.021 0 404.021s55.422 22.49 89.158 11.246 62.651-53.816 92.37-68.274 47.39-33.736 87.552-12.852c0 0-16.868-69.077-48.997-63.455s15.262-16.064 15.262-16.064-8.836-117.27-25.704-125.303-6.425-28.916-37.751-32.932c0 0 38.555-4.82 45.784 21.687s57.029 169.48 57.029 169.48 30.522 61.045 64.257 46.587-12.851-95.583-12.851-95.583l-57.832-26.507s43.374-1.606 69.88 23.294 28.113 105.222 28.113 105.222 66.668 9.639 82.732 45.784c0 0 10.442-32.13-9.639-51.407-5.02-4.819-10.291-13.203-15.374-23.067-19.438-37.724-26.032-80.727-19.917-122.721 2.992-20.55 4.834-40.644 1.556-45.379-7.23-10.442-37.752-74.7-40.161-91.567S367.877 0 367.877 0s.803 43.374 10.441 57.029 36.949 81.126 36.949 81.126 0 85.141 22.49 126.909 65.864 88.354 63.455 118.877v17.67s48.193-45.783 44.98-61.044-7.229-51.406-37.751-73.093-50.603-56.226-28.916-106.026 21.687-58.635 21.687-58.635l-14.458 61.848s-8.033 55.422 14.458 74.7 52.21 54.619 52.21 54.619l-6.427-115.664 20.884 45.783s44.98-57.832 97.993-77.109 85.945-86.748 85.945-86.748L796.798 24.9 759.85 69.077s-11.245 52.21-74.7 89.158-104.42 91.568-106.829 125.303-4.82 63.455-4.82 63.455 118.878-4.016 145.384-56.226 28.916-155.825 54.62-172.693S847.4 80.322 847.4 80.322L793.585 124.5s-11.245 36.145-8.835 61.848-17.671 49.8-17.671 49.8l-15.262 44.98-16.867 38.555s69.077 1.607 105.222 42.571 126.106 53.013 126.106 53.013l-50.603 13.655s-48.193-16.065-93.977-45.784-40.965-56.226-97.993-26.507-134.942 54.62-134.942 54.62 44.98-20.884 126.106 29.719-40.161-8.836-76.306 10.442-53.013-4.82-67.47 43.374-40.965 179.922-10.443 253.819l30.523 73.896Z" fill="#3f3d56"/>
  <path d="M720.104 290.767c-21.535 42.417-104.038 53.024-134.23 55.51-.847 10.889-1.406 17.775-1.406 17.775s118.877-4.016 145.384-56.226 28.916-155.825 54.62-172.693a212.286 212.286 0 0 1 8.853-5.473c.883-3.241 1.479-5.16 1.479-5.16l53.816-44.178s-48.194 20.884-73.897 37.752-28.113 120.483-54.62 172.693ZM581.588 209.62c-.175 19.777-2.742 31.539-2.742 31.539s44.961-57.808 97.96-77.097a304.171 304.171 0 0 1 9.562-5.827c63.455-36.948 74.7-89.158 74.7-89.158L798.016 24.9l-44.98 35.342s-32.932 67.47-85.945 86.748c-36.136 13.14-68.534 44.19-85.503 62.63ZM512.178 401v17.671s48.194-45.784 44.98-61.045c-2.456-11.671-5.398-35.552-20.292-55.844 6.714 15.335 8.757 30.293 10.545 38.785 2.304 10.944-21.826 37.581-35.663 51.778a36.63 36.63 0 0 1 .43 8.655ZM447.531 279.733c.382.814.775 1.615 1.192 2.39 12.318 22.875 30.887 47.19 44.781 69.525-11.229-22.118-30.77-47.412-45.973-71.915ZM486.69 245.537c-6.477-15.87-7.544-34.755-.103-56.884a173.592 173.592 0 0 1 1.385-23.992l12.648-54.103c-2.332 7.802-7.668 22.854-19.877 50.89-15.457 35.493-9.688 63.228 5.947 84.09ZM841.39 362.254c-25.066-28.41-65.965-37.887-88.685-41.029l-6.789 15.517s69.078 1.607 105.223 42.571c20.044 22.717 56.632 36.537 85.257 44.346l31.1-8.392s-89.96-12.049-126.105-53.013ZM349.927 351.2c33.735-14.458-12.852-95.583-12.852-95.583l-1.274-.585c11.614 24.505 28.459 68.789 4.378 79.11-22.533 9.656-43.63-14.37-55.158-31.392l.648 1.863s30.523 61.045 64.258 46.587ZM459.969 403.41s10.165-31.334-8.932-50.68c4.683 16.666-.816 33.62-.816 33.62-12.428-27.96-55.129-40.057-73.833-44.102.726 9.309.849 15.378.849 15.378s66.667 9.639 82.732 45.784ZM500.62 110.558c1.81-6.057 1.81-7.745 1.81-7.745ZM99.637 432.48c.162-.053.326-.1.487-.154 33.736-11.245 62.652-53.816 92.371-68.274s47.39-33.736 87.551-12.852c0 0-7.026-28.76-20.641-47.654a187.39 187.39 0 0 1 10.893 30.595c-40.16-20.884-57.832-1.606-87.55 12.852-29.72 14.458-58.636 57.029-92.372 68.274S1.22 404.022 1.22 404.022s36.948 23.293 84.338 27.31c5.421.459 10.047.864 14.08 1.147ZM434.51 822.501c14.718-45.116 50.112-169.874 22.246-252.824-12.034-35.823-23.189-58.666-32.618-73.239 7.051 13.796 14.761 32.043 22.87 56.18C481.546 655.43 418.895 822.5 418.895 822.5ZM120.83 480.363a81.993 81.993 0 0 1 28.291 8.189c32.987 16.493 57.462 26.953 87.263 14.804 6.789-3.586 14.382-8.024 23.14-13.307.682-.498 1.358-.977 2.048-1.497 42.571-32.13 101.207-73.897 158.235-48.997 0 0-11.525-11.301-24.445-22.032-52.271-12.823-104.618 24.596-143.538 53.97-42.57 32.128-70.683 20.883-112.451 0s-84.339 2.409-84.339 2.409c31.035-.931 51.033 1.857 65.795 6.46ZM202.36 121.521a21.012 21.012 0 0 0 3.302 4.223 23.705 23.705 0 0 0-3.303-4.223ZM349.124 252.404a39.108 39.108 0 0 1 3.482 3.754c-3.519-8.458-7.864-15.772-13.23-20.813-26.507-24.9-69.88-23.294-69.88-23.294l54.395 24.931a77.68 77.68 0 0 1 25.233 15.422ZM406.846 143.777c3.278 4.735 1.437 24.828-1.556 45.379-6.115 41.994.48 84.997 19.918 122.72a142.934 142.934 0 0 0 8.558 14.693c-18.509-37.151-24.715-79.234-18.728-120.354 2.993-20.55 4.835-40.644 1.557-45.379-7.23-10.442-37.752-74.7-40.162-91.567a116.894 116.894 0 0 1-.503-19.71C369.69 31.856 369.095 0 369.095 0s-4.82 35.342-2.41 52.21 32.932 81.125 40.161 91.567ZM482.201 32.734a22.985 22.985 0 0 0-1.458-4.621s.617 1.733 1.458 4.621ZM198.5 113.63c7.078.866 15.221 3.038 21.432 8.075-.405-1.37-.758-2.599-1.04-3.631-7.229-26.506-45.784-21.687-45.784-21.687 17.424 2.234 21.924 9.686 25.391 17.242Z" opacity=".1"/>
  <path d="M398.137 788.182c5.727 21.17 25.343 34.281 25.343 34.281s10.331-21.212 4.604-42.383-25.343-34.281-25.343-34.281-10.33 21.212-4.604 42.383Z" fill="#3f3d56"/>
  <path d="M406.553 783.632c15.715 15.298 17.634 38.814 17.634 38.814s-23.56-1.286-39.274-16.584-17.634-38.814-17.634-38.814 23.559 1.286 39.274 16.584ZM354.467 209.64c-1.366 21.89-17.955 38.667-17.955 38.667s-14.374-18.71-13.008-40.6 17.955-38.666 17.955-38.666 14.374 18.71 13.008 40.6ZM181.54 71.265c18.553 11.696 25.32 34.3 25.32 34.3s-23.313 3.639-41.865-8.057-25.318-34.3-25.318-34.3 23.312-3.64 41.864 8.057ZM140.111 338.118c18.552 11.697 25.319 34.3 25.319 34.3s-23.312 3.64-41.864-8.057-25.318-34.3-25.318-34.3 23.312-3.639 41.863 8.057ZM238.81 440.473c18.553 11.696 25.32 34.3 25.32 34.3s-23.313 3.64-41.865-8.057-25.318-34.3-25.318-34.3 23.312-3.64 41.864 8.057ZM517.264 110.276c-5.595 21.206-25.128 34.44-25.128 34.44s-10.463-21.148-4.869-42.354 25.129-34.439 25.129-34.439 10.463 21.148 4.868 42.353ZM693.748 126.811c-6.576 20.922-26.705 33.232-26.705 33.232s-9.467-21.612-2.891-42.534 26.704-33.232 26.704-33.232 9.467 21.612 2.892 42.534ZM884.498 359.665c-11.911 18.414-34.592 24.917-34.592 24.917s-3.368-23.353 8.544-41.767 34.592-24.918 34.592-24.918 3.368 23.353-8.544 41.768Z" fill="currentColor"/>
  <path d="M585.035 510.239s-1.913 7.016 1.914 9.567 5.102 14.668 5.102 14.668l-7.654 21.047-20.408 3.826-7.654-14.668v-21.685s2.552-10.842 1.914-14.03 26.786 1.275 26.786 1.275Z" fill="#ffb9b9"/>
  <path d="M585.035 510.239s-1.913 7.016 1.914 9.567 5.102 14.668 5.102 14.668l-7.654 21.047-20.408 3.826-7.654-14.668v-21.685s2.552-10.842 1.914-14.03 26.786 1.275 26.786 1.275Z" opacity=".2"/>
  <path d="m605.444 630.778 16.582 3.189s1.275 18.495 0 22.96-2.551 9.566-1.276 10.842-5.74 33.802-5.102 35.715 1.914 7.653 1.276 11.48-2.551 2.55-1.276 6.377 2.551 4.465 1.276 7.016-7.653 64.415-9.567 65.053-19.133 1.275-19.133 0 5.74-10.842 3.827-13.394.637-45.92.637-47.832 3.827-5.103 1.914-6.378-3.19-2.551-2.551-4.465 1.913-2.55.637-4.464-1.275-40.18-5.74-41.455c0 0-5.74 28.062-3.826 35.077s-.638 9.567-.638 9.567l8.929 7.653-12.118 22.96-12.755-14.669s0-3.826-2.551-4.464-3.827-1.276-3.827-3.19-4.464-14.03-4.464-14.03-12.756-40.18-6.378-60.588 8.835-19.734 8.835-19.734Z" fill="#2f2e41"/>
  <path fill="#ffb9b9" d="m615.648 762.797 7.016 7.653-2.551 21.046h-5.74l-8.929-19.771 10.204-8.928z"/>
  <path d="M620.113 776.828s-2.551 5.74-4.465 4.464-2.547-3.189-5.419-3.189-5.423.638-4.785 1.913 8.29 15.307 8.29 15.307a18.028 18.028 0 0 1 0 15.306c-3.826 8.291 10.205 12.756 12.756 3.827s3.19-19.133 2.551-22.96 3.19-23.597 3.19-23.597-10.304-4.75-13.443-4.926c0 0 2.6 11.303 1.325 13.855ZM602.893 790.859l2.55 7.653s0 7.653 2.552 11.48 5.102 12.117-5.102 12.755-14.669-3.189-14.669-3.189 1.913-5.102 0-7.015 0-5.74 0-5.74l1.913-15.307Z" fill="#2f2e41"/>
  <path d="M585.673 727.081h5.74l28.7 37.629s-5.102 12.118-12.756 13.393c0 0-1.275-.638-7.015-4.464s-21.047-22.96-21.047-22.96l-1.913-10.842Z" fill="#2f2e41"/>
  <circle cx="571.642" cy="498.121" r="20.409" fill="#ffb9b9"/>
  <path d="m596.515 524.27-6.378-2.551s-.637 22.322-12.755 22.322-24.873-3.189-24.873-9.567-10.204 11.48-10.204 11.48 9.566 63.777 8.928 64.415 7.016 34.44 7.016 34.44 32.526 1.275 43.368-3.189 14.031-12.755 14.031-12.755l-4.464-56.124-8.929-43.369Z" fill="currentColor"/>
  <path d="M585.677 518.53s2.547-2.551 6.374 0 27.424 8.291 27.424 10.204v24.236s.638 3.826-1.276 6.377-6.377 12.118-3.826 16.582 12.117 56.124 10.204 62.502-7.015 12.118-7.015 12.118-27.425-58.037-27.425-74.62.267-36.925.267-36.925Z" fill="#575a89"/>
  <path d="M613.735 529.372h5.74s21.684 41.455 21.684 49.746-14.03 54.21-15.306 54.849-5.103-7.016-5.103-7.016l-3.188-25.51s6.377-15.307 4.464-17.858-11.48-22.322-11.48-22.322ZM557.279 518.53s-7.321 5.102-8.597 7.016-20.408 12.755-21.046 15.306 14.668 24.235 14.668 24.235 6.378 35.716 6.378 38.267 2.551 45.92 2.551 45.92 26.149 7.652 26.149 3.188.638-68.241-3.189-82.272-16.914-51.66-16.914-51.66Z" fill="#575a89"/>
  <path d="M561.438 650.549s21.684 29.337 10.204 28.7-19.133-25.511-19.133-25.511Z" fill="#ffb9b9"/>
  <path d="m535.289 538.939-7.653 1.913s-6.378 56.124-2.551 63.777 24.235 57.4 24.235 55.486 17.953-5.323 17.268-7.126-4.513-9.456-5.788-12.007-3.189-5.74-2.551-8.929-7.016-16.838-7.016-16.838-1.913-8.035-2.55-11.861-6.379-45.92-6.379-45.92Z" fill="#575a89"/>
  <path d="M591.652 482.323a5.071 5.071 0 0 0-2.309-2.837 10.867 10.867 0 0 0-.488-3.745c-1.27-3.535-4.28-3.332-7.119-4.895-1.232-.678-1.156-1.277-1.797-2.391a9.154 9.154 0 0 0-3.633-3.49 13.511 13.511 0 0 0-5.9-2.355c-4.529-.29-8.001 3.72-12.33 5.006-1.908.567-3.958.59-5.876 1.127s-3.832 1.816-4.118 3.68c-.132.86.101 1.743-.033 2.604-.266 1.71-1.86 2.907-2.927 4.313-2.359 3.11-2.09 7.504-.202 10.888a15.22 15.22 0 0 0 1.36 2.004 11.795 11.795 0 0 0 1.437 4.577c1.886 3.384 5.133 5.913 8.525 8.014a17.896 17.896 0 0 1-.503-3.417 2.23 2.23 0 0 1 .154-1.133c.378-.743 1.376-.94 2.137-1.347a4.982 4.982 0 0 0 2.24-4.415c.045-1.706-.34-3.414-.15-5.111a2.73 2.73 0 0 1 1.017-2.054 3.685 3.685 0 0 1 1.915-.43c3.229-.124 6.603-.18 9.451-1.617a14.363 14.363 0 0 1 2.942-1.401c2.421-.594 4.895 1.003 6.29 2.957s2.091 4.28 3.378 6.3 3.511 3.82 6 3.58a1.024 1.024 0 0 0 .743-.31.998.998 0 0 0 .137-.597l.139-8.954a12.775 12.775 0 0 0-.48-4.551Z" fill="#2f2e41"/>
  <ellipse cx="930.046" cy="843.116" rx="125.477" ry="8.939" fill="#3f3d56"/>
  <path d="M886.127 822.165s-10.712 9.02-16.35 8.457-16.35-.564-11.84 5.638 23.116 9.585 31.01 10.148 25.37 1.128 24.243-2.255-2.255-19.17-6.766-20.297-20.297-1.691-20.297-1.691ZM947.61 813.308s-7.894 11.568-13.476 12.54-15.9 3.851-9.889 8.613 24.842 3.02 32.596 1.441 24.741-5.733 22.746-8.688-7.324-17.858-11.972-17.732-20.005 3.826-20.005 3.826Z" fill="#575a89"/>
  <path d="M879.852 647.87s-7.256 49.694-5.565 58.715 2.82 23.116 2.82 23.116-1.128 11.84 0 17.478 7.893 59.2 7.893 60.327-1.128 4.51 0 7.33 3.382.563 0 5.074-1.128 5.638-.564 5.638 22.552 2.255 23.68 0-.564-2.82 0-5.638 1.127-3.383 2.255-3.947 3.383.564 1.691-2.255-5.638-6.202-4.51-7.894-.564-14.095-.564-14.095-1.128-27.626-1.691-44.54 5.074-34.393 5.074-34.393a64.508 64.508 0 0 0 14.659 37.775c14.659 17.478 21.988 50.18 21.988 50.18s3.383 5.073 1.692 9.584-6.766 1.691-1.692 4.51 22.553-1.127 24.244-2.819-2.255-3.946-1.128-8.457 5.638-3.383 1.692-5.638-5.075-1.691-5.075-3.946-10.148-51.307-25.935-65.402l-1.127-51.306s14.095-36.084-.564-39.467-59.273 10.07-59.273 10.07Z" fill="#2f2e41"/>
  <path d="M890.074 514.327s9.585 23.68 7.33 27.063 27.626-11.277 27.626-11.277-9.585-23.68-9.585-26.498-25.371 10.712-25.371 10.712Z" fill="#a0616a"/>
  <circle cx="897.121" cy="499.386" r="20.861" fill="#a0616a"/>
  <path d="M925.03 520.529s-14.66-1.692-21.989 7.33-8.457 11.275-8.457 11.275-17.478 28.19-14.095 42.286a40.783 40.783 0 0 1 2.255 3.946c1.128 2.256 1.128 33.829 0 38.903s-2.255 6.766-1.127 14.095-9.021 19.17 2.819 21.425 20.86.564 24.807-4.51.564-8.458 12.968-8.458a29.835 29.835 0 0 0 20.297-8.457s-6.202-6.765-3.947-7.893 0-3.947-1.127-6.766-1.128-5.074.563-5.074.564-1.128-.563-3.947 19.733-51.306 7.329-65.401-18.606-21.989-18.606-21.989 2.256-8.457-1.127-6.765Z" fill="currentColor"/>
  <path d="M892.893 574.09v24.808L874.85 658.66s-11.84 31.01 0 31.01 11.206-29.598 11.206-29.598l25.442-44.825s10.148-35.52 9.02-38.339-27.626-2.819-27.626-2.819Z" fill="#a0616a"/>
  <path d="M902.478 537.443s-16.915 6.766-12.404 24.807 0 17.478 0 17.478 23.116-2.255 30.445 2.82l1.692-6.766s6.765-38.903-19.733-38.34Z" fill="currentColor"/>
  <path d="M889.998 483.725a8.323 8.323 0 0 1-7.818-1.216 6.298 6.298 0 0 1-1.777-7.436c1.08-2.118 3.389-3.28 5.603-4.147a52.075 52.075 0 0 1 15.26-3.446c2.495-.178 5.114-.15 7.34.99 1.101.564 2.058 1.377 3.149 1.961 2.005 1.074 4.339 1.313 6.506 2.004a16.286 16.286 0 0 1 9.953 9.149 19.624 19.624 0 0 1 1.226 4.541 25.296 25.296 0 0 1-1.316 12.663c-2.403 6.4-7.444 11.994-7.728 18.823-3.085-2.238-4.23-6.278-6.702-9.18a12.486 12.486 0 0 0-7.126-4.133 3.97 3.97 0 0 1-2.124-.774 3.42 3.42 0 0 1-.776-1.81l-2.11-9.967c-.43-2.029-.973-4.24-2.64-5.473a7.988 7.988 0 0 0-3.441-1.212 53.973 53.973 0 0 0-8.814-.804" fill="#2f2e41"/>
</svg>
               ''',
                      width: constraints.maxWidth,
                      currentColor: Theme.of(context).primaryColor,
                      alignment: Alignment.topCenter,
                      allowDrawingOutsideViewBox: false,
                      clipBehavior: Clip.antiAlias,
                      fit: BoxFit.scaleDown,
                    );
                  }),
                  // const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _refresh(context),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is NotificacionListadoFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
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
                    ],
                  ),
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
                  TextButton(
                    onPressed: () => _refresh(context),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
