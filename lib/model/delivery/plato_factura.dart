import 'package:json_annotation/json_annotation.dart';

part 'plato_factura.g.dart';

@JsonSerializable()
class PlatoFactura {
  @JsonKey(name: 'nombre')
  String nombre;

  @JsonKey(name: 'cantidad')
  int cantidad;

  @JsonKey(name: 'total')
  double total;

  PlatoFactura(this.nombre, this.cantidad, this.total);

  factory PlatoFactura.fromJson(Map<String, dynamic> json) =>
      _$PlatoFacturaFromJson(json);

  Map<String, dynamic> toJson() => _$PlatoFacturaToJson(this);
}