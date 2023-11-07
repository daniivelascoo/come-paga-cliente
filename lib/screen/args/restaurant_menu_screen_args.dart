import 'package:comepaga/model/restaurant/restaurante.dart';
import 'package:comepaga/model/user/cliente.dart';

class RestaurantMenuScreenArgs {
  final Restaurante restaurante;
  final Cliente cliente;

  RestaurantMenuScreenArgs({required this.restaurante, required this.cliente});
}
