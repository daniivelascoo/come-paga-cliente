import 'package:comepaga/model/user/administrador.dart';
import 'package:comepaga/model/user/usuario.dart';
import 'package:comepaga/screen/args/manage_repartidores_screen_args.dart';
import 'package:comepaga/screen/args/manage_restaurants_screen_args.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../utils/cookie_config.dart';
import '../../widget/custom_drawer_list_title.dart';
import '../../widget/custom_header_home_screen.dart';
import '../../widget/custom_home_option.dart';
import '../args/pedidos_pendientes_args.dart';
import '../args/reparto_screen_args.dart';
import '../log_up_screen.dart';

class AdministradorHomeScreen extends StatelessWidget {
  final Administrador user;

  const AdministradorHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    Text('@${user.nombreUsuario}')
                  ]),
            ),
            CustomDrawerListTitle(
                onTap: () {
                  var result = user.toJson().map((key, value) =>
                      MapEntry(key.toString(), value?.toString()));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LogUpScreen(
                                initformvalues: result,
                              )));
                },
                label: 'My Information',
                icon: Icons.person),
            CustomDrawerListTitle(
                onTap: () {}, label: 'My Orders', icon: Icons.shopping_basket),
            CustomDrawerListTitle(
                onTap: () {
                  CookieConfig.jar.deleteAll();
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, 'login');
                },
                label: 'Log Out',
                icon: Icons.logout_outlined)
          ],
        ),
      ),
      backgroundColor: AppTheme.primaryColor,
      body: SizedBox(
          child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 6 / 100),
                child: const CustomHeaderHomeScreen()),
            const SizedBox(
              height: 80,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 20,
              spacing: 20,
              children: [
                CustomHomeOption(
                  optionImage: Image.asset('assets/restaurantes.jpg'),
                  route: 'manage_restaurants',
                  args: ManageRestaurantsScreenArgs(user),
                ),
                CustomHomeOption(
                  optionImage: Image.asset('assets/reparto_imagen.jpg'),
                  route: 'manage_repartidores',
                  args: ManageRepartidoresScreenArgs(user),
                ),
              ],
            ),
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                ),
                Image.asset('assets/ComeYPaga.png'),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
