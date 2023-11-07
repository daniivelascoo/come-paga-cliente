// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historico_repartos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoricoRepartos _$HistoricoRepartosFromJson(Map<String, dynamic> json) {
  return HistoricoRepartos((json['repartos'] as List<dynamic>)
      .map((e) => Reparto.fromJson(e as Map<String, dynamic>))
      .toList());
}

Map<String, dynamic> _$HistoricoRepartosToJson(HistoricoRepartos instance) =>
    <String, dynamic>{
      'repartos': instance.repartos?.map((e) => e.toJson()).toList(),
    };
