// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagen_restaurante.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImagenRestaurante _$ImagenRestauranteFromJson(Map<String, dynamic> json) =>
    ImagenRestaurante(
      json['_id'] as String?,
      File(json['imagen'] as String),
      json['_contentType'] as String,
    );

Map<String, dynamic> _$ImagenRestauranteToJson(ImagenRestaurante instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'imagen': instance.imagen.path,
      '_contentType': instance.contentType,
    };


