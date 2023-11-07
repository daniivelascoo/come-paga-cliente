part of 'factura.dart';

Factura _$FacturaFromJson(Map<String, dynamic> json) {
  return Factura(
    json['id'] as String,
    DateTime.parse(json['fecha_creacion'] as String),
    json['cliente_id'] as String,
    (json['total'] as num).toDouble(),
    (json['paltos_factura'] as List<dynamic>)
        .map((e) => PlatoFactura.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$FacturaToJson(Factura instance) => <String, dynamic>{
      'id': instance.id,
      'fecha_creacion': instance.fecha.toIso8601String(),
      'cliente_id': instance.clienteId,
      'total': instance.total,
      'paltos_factura': instance.platosFactura.map((e) => e.toJson()).toList(),
    };