// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pedido _$PedidoFromJson(Map<String, dynamic> json) {
  return Pedido(
    json['id'] as String,
    json['cliente_id'] as String,
    json['repartidor_id'] as String?,
    json['restaurante_id'] as String,
    json['ubicacion_reparto'] as String,
    DateTime.parse(json['fecha_inicio'] as String),
    DateTime.parse(json['fecha_entrega'] as String),
    (json['platos_pedidos'] as List<dynamic>?)
        ?.map((e) => PlatoPedido.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['codigo_estado_pedido'] as String?
  );
}

Map<String, dynamic> _$PedidoToJson(Pedido instance) => <String, dynamic>{
      'id': instance.id,
      'cliente_id': instance.usuarioId,
      'repartidor_id': instance.repartidorId,
      'restaurante_id': instance.restauranteId,
      'ubicacion_reparto': instance.ubicacionReparto,
      'fecha_inicio': instance.fechaInicio?.toIso8601String(),
      'fecha_entrega': instance.fechaEntrega?.toIso8601String(),
      'platos_pedidos': instance.platosPedidos?.map((e) => e.toJson()).toList(),
      'codigo_estado_pedido': instance.codigoEstadoPedido
    };
