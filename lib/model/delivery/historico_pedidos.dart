import 'pedido.dart';
import 'package:json_annotation/json_annotation.dart';

part 'historico_pedidos.g.dart';

@JsonSerializable()
class HistoricoPedidos {
  @JsonKey(name: 'pedidos')
  List<Pedido>? pedidos;

  HistoricoPedidos(this.pedidos);

  factory HistoricoPedidos.fromJson(Map<String, dynamic> json) =>
      _$HistoricoPedidosFromJson(json);

  Map<String, dynamic> toJson() => _$HistoricoPedidosToJson(this);
}
