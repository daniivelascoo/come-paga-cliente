// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historico_pedidos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoricoPedidos _$HistoricoPedidosFromJson(Map<String, dynamic> json) {
  return HistoricoPedidos(
    (json['pedidos'] as List<Pedido>)
        .map((e) =>
        Pedido.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$HistoricoPedidosToJson(HistoricoPedidos instance) =>
    <String, dynamic>{
      'pedidos': instance.pedidos?.map((e) => e.toJson()).toList(),
    };
