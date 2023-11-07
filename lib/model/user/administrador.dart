import 'package:json_annotation/json_annotation.dart';
import '../../utils/constants.dart';
import 'usuario.dart';

part 'administrador.g.dart';

@JsonSerializable()
class Administrador extends Usuario {
  Administrador(
      super.nombreUsuario,
      super.fechaCreacion,
      super.nombre,
      super.password,
      super.primerApellido,
      super.segundoApellido,
      super.tipoUsuario,
      super.fechaNacimiento,
      super.numeroTelefono);

  factory Administrador.fromJson(Map<String, dynamic> json) =>
      _$AdministradorFromJson(json);

  Map<String, dynamic> toJson() => _$AdministradorToJson(this);
}
