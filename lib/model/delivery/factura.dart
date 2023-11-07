import 'package:comepaga/model/delivery/plato_factura.dart';
import 'package:comepaga/model/jsorn_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'factura.g.dart';

@JsonSerializable()
class Factura extends JsonSerializer {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'fecha_creacion')
  DateTime fecha;

  @JsonKey(name: 'cliente_id')
  String clienteId;

  @JsonKey(name: 'total')
  double total;

  @JsonKey(name: 'paltos_factura')
  List<PlatoFactura> platosFactura;

  Factura(this.id, this.fecha, this.clienteId, this.total, this.platosFactura);

  factory Factura.fromJson(Map<String, dynamic> json) =>
      _$FacturaFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FacturaToJson(this);
}