import 'package:json_annotation/json_annotation.dart';

part 'plato_pedido.g.dart';

@JsonSerializable()
class PlatoPedido {
  @JsonKey(name: 'id_plato')
  String plato;

  @JsonKey(name: 'cantidad')
  int cantidad;

  PlatoPedido({required this.plato, required this.cantidad});

  PlatoPedido.empty()
      : plato = '',
        cantidad = 0;

  factory PlatoPedido.fromJson(Map<String, dynamic> json) =>
      _$PlatoPedidoFromJson(json);
  Map<String, dynamic> toJson() => _$PlatoPedidoToJson(this);

  void incrementCantidad() {
    if (cantidad < 20) {
      cantidad++;
    }
  }

  void decrementCantidad() {
    if (cantidad > 0) cantidad--;
  }
}
