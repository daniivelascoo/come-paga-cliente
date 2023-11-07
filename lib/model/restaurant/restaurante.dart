import 'package:comepaga/model/jsorn_serializer.dart';
import 'package:comepaga/model/restaurant/plato.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurante.g.dart';

@JsonSerializable()
class Restaurante extends JsonSerializer{
  @JsonKey(name: 'id')
  String nombre;

  @JsonKey(name: 'descripcion')
  String descripcion;

  @JsonKey(name: 'categoria')
  String categoria;

  @JsonKey(name: 'valoracion_media')
  int valoracionMedia;

  @JsonKey(name: 'precio_medio')
  int precioMedio;

  @JsonKey(name: 'valoraciones')
  List<int> valoraciones;

  @JsonKey(name: 'platos_disponibles_crear')
  List<Plato>? platosCrear;

  @JsonKey(name: 'platos_disponibles')
  List<String> platosCreados;

  Restaurante({
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.valoracionMedia,
    required this.precioMedio,
    required this.valoraciones,
    this.platosCrear,
    required this.platosCreados,
  });

  factory Restaurante.fromJson(Map<String, dynamic> json) => _$RestauranteFromJson(json);

  Map<String, dynamic> toJson() => _$RestauranteToJson(this);
}
