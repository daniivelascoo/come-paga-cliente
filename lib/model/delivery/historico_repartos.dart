import 'package:json_annotation/json_annotation.dart';
import 'reparto.dart';

part 'historico_repartos.g.dart';

@JsonSerializable()
class HistoricoRepartos {
  @JsonKey(name: 'repartos')
  final List<Reparto>? repartos;

  HistoricoRepartos(
    this.repartos,
  );

  factory HistoricoRepartos.fromJson(Map<String, dynamic> json) =>
      _$HistoricoRepartosFromJson(json);

  Map<String, dynamic> toJson() => _$HistoricoRepartosToJson(this);
}
