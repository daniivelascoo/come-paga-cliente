// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plato.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plato _$PlatoFromJson(Map<String, dynamic> json) {
  return Plato(
    id: json[Constants.idKey] as String,
    nombre: json[Constants.nombrePlatoKey] as String,
    descripcion: json[Constants.descripcionPlatoKey] as String,
    disponible: json[Constants.disponibleKey] as bool,
    precio: (json[Constants.precioKey] as num).toDouble(),
  );
}

Map<String, dynamic> _$PlatoToJson(Plato instance) => <String, dynamic>{
      Constants.idKey: instance.id,
      Constants.nombrePlatoKey: instance.nombre,
      Constants.descripcionPlatoKey: instance.descripcion,
      Constants.disponibleKey: instance.disponible,
      Constants.precioKey: instance.precio,
    };
