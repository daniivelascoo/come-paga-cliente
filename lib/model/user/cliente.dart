import 'package:comepaga/model/user/ubicacion.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'usuario.dart';

part 'cliente.g.dart';

@JsonSerializable()
class Cliente extends Usuario {

  @JsonKey(name: Constants.ubicacionesKey)
  List<Ubicacion>? ubicaciones;

  @JsonKey(name: Constants.ubicacionActualKey)
  Ubicacion? ubicacionActual;

  Cliente(
      super.nombreUsuario,
      super.fechaCreacion,
      super.nombre,
      super.password,
      super.primerApellido,
      super.segundoApellido,
      super.tipoUsuario,
      super.fechaNacimiento,
      this.ubicaciones,
      this.ubicacionActual,
      super.numeroTelefono);

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ClienteToJson(this);

  factory Cliente.empty() =>
      Cliente(null, null, null, null, null, null, null, null, null, null, null,);

  
}
