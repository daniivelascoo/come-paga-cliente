import 'package:comepaga/model/jsorn_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reparto.g.dart';

@JsonSerializable()
class Reparto extends JsonSerializer {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'fecha_recogido')
  String? fechaRecogido;

  @JsonKey(name: 'fecha_entregado')
  String? fechaEntregado;

  Reparto(this.id, this.fechaRecogido, this.fechaEntregado);

  factory Reparto.empty() => Reparto(null, null, null);

  factory Reparto.fromJson(Map<String, dynamic> json) =>
      _$RepartoFromJson(json);

  Map<String, dynamic> toJson() => _$RepartoToJson(this);

  String? get getId => id;
  set setId(String? id) => this.id = id;

  String? get getFechaRecogido => fechaRecogido;
  set setFechaRecogido(String? fechaRecogido) =>
      this.fechaRecogido = fechaRecogido;

  String? get getFechaEntregado => fechaEntregado;
  set setFechaEntregado(String? fechaEntregado) =>
      this.fechaEntregado = fechaEntregado;
}
