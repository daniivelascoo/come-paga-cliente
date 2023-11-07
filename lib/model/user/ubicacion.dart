import 'package:comepaga/model/jsorn_serializer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ubicacion.g.dart';

class Ubicacion extends JsonSerializer {
  @JsonKey(name: 'localizacion')
  String? localizacion;

  @JsonKey(name: 'direccion')
  String? direccion;

  Ubicacion(this.localizacion, this.direccion);

  factory Ubicacion.fromJson(Map<String, dynamic> json) =>
      _$UbicacionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UbicacionToJson(this);

  @override
  String toString() {
    if (localizacion == null) return '';
    if (direccion == null) return '';

    return '${direccion!}, ${localizacion!}';
  }
}
