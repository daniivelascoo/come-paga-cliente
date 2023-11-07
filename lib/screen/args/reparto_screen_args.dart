import 'package:comepaga/model/delivery/reparto.dart';
import 'package:comepaga/model/user/repartidor.dart';

class RepartoScreenArgs {
  final Repartidor repartidor;
  Reparto? reparto;

  RepartoScreenArgs(this.repartidor, [this.reparto]);
}
