
part of 'ubicacion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ubicacion _$UbicacionFromJson(Map<String, dynamic> json) {
  return Ubicacion(
    json['localizacion'] as String?,
    json['direccion'] as String?,
  );
}

Map<String, dynamic> _$UbicacionToJson(Ubicacion instance) => <String, dynamic>{
      'localizacion': instance.localizacion,
      'direccion': instance.direccion,
    };