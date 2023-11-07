import 'package:comepaga/model/jsorn_serializer.dart';
import 'package:json_annotation/json_annotation.dart';
import '../restaurant/plato_pedido.dart';

part 'pedido.g.dart';

@JsonSerializable()
class Pedido extends JsonSerializer {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'cliente_id')
  String? usuarioId;

  @JsonKey(name: 'repartidor_id')
  String? repartidorId;

  @JsonKey(name: 'restaurante_id')
  String? restauranteId;

  @JsonKey(name: 'ubicacion_reparto')
  String? ubicacionReparto;

  @JsonKey(name: 'fecha_inicio')
  DateTime? fechaInicio;

  @JsonKey(name: 'fecha_entrega')
  DateTime? fechaEntrega;

  @JsonKey(name: 'platos_pedidos')
  List<PlatoPedido>? platosPedidos;

  @JsonKey(name: 'codigo_estado_pedido')
  String? codigoEstadoPedido;

  Pedido(
    this.id,
    this.usuarioId,
    this.repartidorId,
    this.restauranteId,
    this.ubicacionReparto,
    this.fechaInicio,
    this.fechaEntrega,
    this.platosPedidos,
    this.codigoEstadoPedido
  );

  factory Pedido.fromJson(Map<String, dynamic> json) => _$PedidoFromJson(json);

  Map<String, dynamic> toJson() => _$PedidoToJson(this);
}
