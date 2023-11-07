import 'package:comepaga/model/delivery/factura.dart';
import 'package:comepaga/model/user/cliente.dart';

class BillResumeScreenArgs {
  final Factura factura;
  final Cliente client;

  BillResumeScreenArgs(this.factura, this.client);
}
