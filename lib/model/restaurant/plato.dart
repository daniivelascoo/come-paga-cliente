import 'package:comepaga/model/jsorn_serializer.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'plato.g.dart';

@JsonSerializable()
class Plato extends JsonSerializer{
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'nombre')
  String nombre;

  @JsonKey(name: 'descripcion')
  String descripcion;

  @JsonKey(name: 'disponible')
  bool disponible;

  @JsonKey(name: 'precio')
  double precio;

  Plato({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.disponible,
    required this.precio,
  });

  factory Plato.fromJson(Map<String, dynamic> json) => _$PlatoFromJson(json);

  Map<String, dynamic> toJson() => _$PlatoToJson(this);
}

