import 'package:comepaga/model/user/administrador.dart';

import '../../model/restaurant/restaurante.dart';

class UpdateRestaurantScreenArgs {
  final Restaurante restaurante;
  final Administrador administrador;

  UpdateRestaurantScreenArgs(this.restaurante, this.administrador);
}
