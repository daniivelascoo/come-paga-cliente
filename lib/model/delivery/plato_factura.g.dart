part of 'plato_factura.dart';

PlatoFactura _$PlatoFacturaFromJson(Map<String, dynamic> json) {
  return PlatoFactura(
    json['nombre'] as String,
    json['cantidad'] as int,
    (json['total'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PlatoFacturaToJson(PlatoFactura instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'cantidad': instance.cantidad,
      'total': instance.total,
    };
