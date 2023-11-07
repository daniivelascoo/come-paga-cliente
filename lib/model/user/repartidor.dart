import 'package:json_annotation/json_annotation.dart';
import '../../utils/constants.dart';
import 'usuario.dart';

part 'repartidor.g.dart';

@JsonSerializable()
class Repartidor extends Usuario {

  String? pedidoId;

  Repartidor(
      super.nombreUsuario,
      super.fechaCreacion,
      super.nombre,
      super.password,
      super.primerApellido,
      super.segundoApellido,
      super.tipoUsuario,
      super.fechaNacimiento,
      super.numeroTelefono, 
      this.pedidoId);

  factory Repartidor.fromJson(Map<String, dynamic> json) =>
      _$RepartidorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RepartidorToJson(this);
}
