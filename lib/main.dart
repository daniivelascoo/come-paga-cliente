import 'package:comepaga/router/app_routes.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/user/usuario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CallService<Usuario> service =
        CallService(uri: 'usuario', fromJson: Usuario.fromJson);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Come y Paga Application',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.initRoute.route,
      routes: AppRoutes.getAppRoutes(),
    );

    /*

    return FutureBuilder<Usuario?>(
        future: service.login('/login', {}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Colors.red,
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Text('Error'),
            );
          } else if (snapshot.hasData) {
            final Usuario usuario = snapshot.data!;
            ModalRoute.of(context)!.settings.arguments = HomeScreenArgs(usuario)

            return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Come y Paga Application',
  theme: AppTheme.theme,
  initialRoute: AppRoutes.homeRoute.route,
  onGenerateInitialRoutes: (String initialRoute) {
    return [
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(),
        settings: RouteSettings(
          name: AppRoutes.homeRoute.route,
          arguments: HomeScreenArgs(usuario),
        ),
      ),
    ];
  },
  routes: AppRoutes.getAppRoutes(),
);
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Come y Paga Application',
              theme: AppTheme.theme,
              initialRoute: AppRoutes.initRoute.route,
              routes: AppRoutes.getAppRoutes(),
            );
          }
        });*/
  }
}
