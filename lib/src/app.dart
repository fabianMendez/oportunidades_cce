import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tailwindcss_defaults/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oportunidades_cce/src/authentication/authentication_bloc.dart';
import 'package:oportunidades_cce/src/authentication/authentication_builder.dart';
import 'package:oportunidades_cce/src/authentication/user_details_storage.dart';
import 'package:oportunidades_cce/src/service_locator.dart';

/// The Widget that configures your application.
class OportunidadesCCEApp extends StatelessWidget {
  OportunidadesCCEApp({super.key});

  final routerDelegate = OportunidadesCCERouterDelegate();
  final routeInformationParser = OportunidadesCCERouteInformationParser();

  @override
  Widget build(BuildContext context) {
    const primaryColor = TailwindColors.blue;
    // const primaryColor = Colors.indigo;
    // Glue the SettingsController to the MaterialApp.
    //
    final colorScheme = ColorScheme.fromSwatch(primarySwatch: primaryColor);
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return BlocProvider<AuthenticationBloc>(
      create: (_) {
        return AuthenticationBloc(
          userDetailsStorage: sl.get<UserDetailsStorage>(),
        )..add(const AppStarted());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthenticationBuilder(),
        // Providing a restorationScopeId allows the Navigator built by the
        // MaterialApp to restore the navigation stack when a user leaves and
        // returns to the app after it has been killed while running in the
        // background.
        restorationScopeId: 'app',

        // Provide the generated AppLocalizations to the MaterialApp. This
        // allows descendant Widgets to display the correct translations
        // depending on the user's locale.
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', ''), // Spanish, no country code
        ],

        // Use AppLocalizations to configure the correct application title
        // depending on the user's locale.
        //
        // The appTitle is defined in .arb files found in the localization
        // directory.
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,

        // Define a light and dark color theme. Then, read the user's
        // preferred ThemeMode (light, dark, or system default) from the
        // SettingsController to display the correct theme.
        theme: ThemeData(
          primaryColor: primaryColor,
          colorScheme: colorScheme,
          // textTheme: GoogleFonts.workSansTextTheme(
          //   Theme.of(context).textTheme,
          // ),
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
          indicatorColor: colorScheme.secondary,
          tabBarTheme: const TabBarTheme(
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        darkTheme: ThemeData.dark(),
        // themeMode: settingsController.themeMode,
      ),
    );
  }
}

class OportunidadesCCERouterDelegate
    extends RouterDelegate<OportunidadesCCERoutePath>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<OportunidadesCCERoutePath> {
  OportunidadesCCERouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Future<void> setNewRoutePath(OportunidadesCCERoutePath configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
// class OportunidadesCCERouterDelegate extends {

// }

class OportunidadesCCERoutePath extends Equatable {
  const OportunidadesCCERoutePath({
    required this.isHome,
  });

  const OportunidadesCCERoutePath.home() : isHome = true;

  final bool isHome;

  @override
  List<Object?> get props => [];
}

class OportunidadesCCERouteInformationParser
    extends RouteInformationParser<OportunidadesCCERoutePath> {
  @override
  Future<OportunidadesCCERoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location ?? '/');

    // root
    if (uri.pathSegments.isEmpty) {
      return const OportunidadesCCERoutePath.home();
    }

    return const OportunidadesCCERoutePath(isHome: false);
  }
}
