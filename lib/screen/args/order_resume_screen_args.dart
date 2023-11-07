import 'package:comepaga/model/restaurant/restaurante.dart';
import 'package:comepaga/model/user/cliente.dart';

class OrderResumeScreenArgs {
  final Cliente cliente;
  final String origin;
  final Restaurante? restaurante;

  OrderResumeScreenArgs(this.cliente, this.origin, this.restaurante);
}
