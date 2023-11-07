// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reparto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reparto _$RepartoFromJson(Map<String, dynamic> json) => Reparto(
      json['id'] as String?,
      json['fecha_recogido'] as String?,
      json['fecha_entregado'] as String?,
    );

Map<String, dynamic> _$RepartoToJson(Reparto instance) => <String, dynamic>{
      'id': instance.id,
      'fecha_recogido': instance.fechaRecogido,
      'fecha_entregado': instance.fechaEntregado,
    };
