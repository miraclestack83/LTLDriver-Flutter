import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opentrip/Helpers/navigator_service.dart';
import 'package:opentrip/Pages/App/Styles/colors.dart';
import 'package:opentrip/Pages/App/navigator_builder.dart';
import 'package:opentrip/Pages/SignInPage/signin_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'Provider/app_provider.dart';
import 'Provider/auth_provider.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: OverlaySupport.global(
        toastTheme: ToastThemeData(
          background: Color.fromARGB(239, 50, 19, 189),
        ),
        child: MaterialApp(
          navigatorKey: NavigationService.instance.navigationKey,
          debugShowCheckedModeBanner: false,
          title: 'OpenTrip',
          theme: ThemeData(
            fontFamily: 'ProductSans',
            primaryColor: const Color.fromARGB(239, 50, 19, 189),
            primaryColorLight: const Color.fromARGB(239, 50, 19, 189),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                elevation: 0, foregroundColor: Colors.white),
            brightness: Brightness.light,
            // accentColor: const Color.fromARGB(255, 118, 0, 253),
            dividerColor: Colors.black.withOpacity(0.1),
            focusColor: Colors.black.withOpacity(1),
            hintColor: Colors.black.withOpacity(0.2),
            // cardColor: Color(0xFFCEAD81),
            primaryColorDark: const Color.fromARGB(255, 44, 42, 40),
            highlightColor: const Color.fromARGB(255, 115, 12, 212),
            textTheme: TextTheme(
              headline5: const TextStyle(
                  fontSize: 22.0, color: Colors.black, height: 1.3),
              headline4: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3),
              headline3: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              headline2: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              headline1: const TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.4),
              subtitle1: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.3),
              headline6: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.3),
              bodyText2: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.2),
              bodyText1: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.3),
              caption: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.5),
                  height: 1.2),
            ),
          ),
          home: NavigatorBuilder(),
        ),
      ),
    );
  }
}
