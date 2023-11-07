import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
part 'imagen_restaurante.g.dart';

@JsonSerializable()
class ImagenRestaurante {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'imagen')
  File imagen;

  @JsonKey(name: '_contentType')
  String contentType;

  ImagenRestaurante(this.id, this.imagen, this.contentType);

  factory ImagenRestaurante.fromJson(Map<String, dynamic> json) =>
      _$ImagenRestauranteFromJson(json);

  Map<String, dynamic> toJson() => _$ImagenRestauranteToJson(this);
}


