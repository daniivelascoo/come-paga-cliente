import 'package:comepaga/model/menu_option.dart';
import 'package:comepaga/screen/create_restaurant_screen.dart';
import 'package:comepaga/screen/draweroption/orders_screen.dart';
import 'package:comepaga/screen/home/home_screen.dart';
import 'package:comepaga/screen/homeoption/bills_screen.dart';
import 'package:comepaga/screen/homeoption/manage_repartidores_screen.dart';
import 'package:comepaga/screen/homeoption/manage_restaurants_screen.dart';
import 'package:comepaga/screen/homeoption/pedidos_pendientes_screen.dart';
import 'package:comepaga/screen/homeoption/reparto_screen.dart';
import 'package:comepaga/screen/homeoption/restaurantes_screen.dart';
import 'package:comepaga/screen/log_up_screen.dart';
import 'package:comepaga/screen/login_screen.dart';
import 'package:comepaga/screen/ordergateway/bill_resume_screen.dart';
import 'package:comepaga/screen/ordergateway/order_resume_screen.dart';
import 'package:comepaga/screen/ordergateway/restaurant_menu_screen.dart';
import 'package:comepaga/screen/update_delete_restaurant_screen.dart';
import 'package:comepaga/screen/update_order_screen.dart';
import 'package:comepaga/screen/update_restaurant_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static final initRoute = MenuOption(
      route: 'login', name: 'Come y Paga', screen: const LoginScreen());

  static final homeRoute =
      MenuOption(route: 'home', name: 'Home', screen: const HomeScreen());

  static final homeOptions = <MenuOption>[
    MenuOption(
        route: 'restaurants',
        name: 'Restaurants',
        screen: const RestaurantesScreen()),
    MenuOption(route: 'bills', name: 'Bills', screen: BillsScreen()),
    MenuOption(
        route: 'reparto',
        name: 'Reparto Actual',
        screen: const RepartoScreen()),
    MenuOption(
        route: 'pedidos_pendientes',
        name: 'Pedidos Pendientes',
        screen: const PedidosPendientesScreen()),
    MenuOption(
        route: 'manage_restaurants',
        name: 'Restaurants',
        screen: const ManageRestaurantsScreen()),
    MenuOption(
        route: 'manage_repartidores',
        name: 'Repartidores',
        screen: const ManageRepartidoresScreen())
  ];

  static final singInOptions = <MenuOption>[
    MenuOption(route: 'log_up', name: 'Log Up', screen: const LogUpScreen())
  ];

  static final orderGatewayScreens = <MenuOption>[
    MenuOption(
        route: 'restaurant_menu',
        name: 'Restaurant Menu',
        screen: const RestaurantMenuScreen()),
    MenuOption(
        route: 'order_resume',
        name: 'Order Resume',
        screen: const OrderResumeScreen()),
    MenuOption(
        route: 'bill_resume',
        name: 'Bill Resume',
        screen: const BillResumeScreen())
  ];

  static final otherScreens = <MenuOption>[
    MenuOption(
        route: 'create_restaurant',
        name: 'Create Restaurant',
        screen: const CreateRestaurantScreen()),
    MenuOption(
        route: 'update_delete_restaurant',
        name: 'Restaurant Operations',
        screen: const UpdateDeleteRestaurantScreen()),
    MenuOption(
        route: 'update_restaurant',
        name: 'Update Restaurant',
        screen: const UpdateRestaurantScreen()),
    MenuOption(route: 'orders', name: 'Orders', screen: const OrdersScreen()),
    MenuOption(
        route: 'update_order',
        name: 'Update Order',
        screen: const UpdateOrderScreen())
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    appRoutes.addAll(
        {initRoute.route: ((BuildContext context) => initRoute.screen)});
    appRoutes.addAll(
        {homeRoute.route: ((BuildContext context) => homeRoute.screen)});

    for (var element in homeOptions) {
      appRoutes
          .addAll({element.route: ((BuildContext context) => element.screen)});
    }

    for (var element in otherScreens) {
      appRoutes
          .addAll({element.route: ((BuildContext context) => element.screen)});
    }

    for (var element in singInOptions) {
      appRoutes
          .addAll({element.route: ((BuildContext context) => element.screen)});
    }

    for (var element in orderGatewayScreens) {
      appRoutes
          .addAll({element.route: ((BuildContext context) => element.screen)});
    }

    return appRoutes;
  }
}
