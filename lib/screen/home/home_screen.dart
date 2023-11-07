import 'package:comepaga/model/user/administrador.dart';
import 'package:comepaga/model/user/cliente.dart';
import 'package:comepaga/model/user/repartidor.dart';
import 'package:comepaga/model/user/usuario.dart';
import 'package:comepaga/screen/args/home_screen_args.dart';
import 'package:comepaga/screen/error_screen.dart';
import 'package:comepaga/screen/home/administrador_home_screen.dart';
import 'package:comepaga/screen/home/client_home_screen.dart';
import 'package:comepaga/screen/home/repartidor_home_screen.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget getUserTypeScreen(Usuario user) {
    switch (user.tipoUsuario) {
      case '0':
        return AdministradorHomeScreen(
          user: user as Administrador,
        );
      case '1':
        return ClienteHomeScreen(
          user: user as Cliente,
        );
      case '2':
        return RepartidorHomeScreen(
          user: user as Repartidor,
        );
      default:
        return const ErrorScreen(errorMessage: Constants.errorWithUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as HomeScreenArgs;

    return getUserTypeScreen(args.user);
  }
}
