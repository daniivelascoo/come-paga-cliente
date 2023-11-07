// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plato_pedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatoPedido _$PlatoPedidoFromJson(Map<String, dynamic> json) => PlatoPedido(
      plato: json['id_plato'] as String,
      cantidad: json['cantidad'] as int,
    );

Map<String, dynamic> _$PlatoPedidoToJson(PlatoPedido instance) =>
    <String, dynamic>{
      'id_plato': instance.plato,
      'cantidad': instance.cantidad,
    };
