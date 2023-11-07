// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurante.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurante _$RestauranteFromJson(Map<String, dynamic> json) {
  return Restaurante(
    nombre: json[Constants.nombreRestauranteKey] as String,
    descripcion: json[Constants.descripcionKey] as String,
    categoria: json[Constants.categoriaKey] as String,
    valoracionMedia: json[Constants.valoracionMediaKey] as int,
    precioMedio: json[Constants.precioMedioKey] as int,
    valoraciones:
        (json[Constants.valoracionesKey] as List).map((e) => e as int).toList(),
    platosCreados: (json[Constants.platosDisponiblesKey] as List)
        .map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$RestauranteToJson(Restaurante instance) =>
    <String, dynamic>{
      Constants.nombreRestauranteKey: instance.nombre,
      Constants.descripcionKey: instance.descripcion,
      Constants.categoriaKey: instance.categoria,
      Constants.valoracionMediaKey: instance.valoracionMedia,
      Constants.precioMedioKey: instance.precioMedio,
      Constants.valoracionesKey: instance.valoraciones,
      Constants.platosDisponiblesCrearKey:
          instance.platosCrear?.map((e) => e.toJson()).toList(),
      Constants.platosDisponiblesKey: instance.platosCreados,
    };
