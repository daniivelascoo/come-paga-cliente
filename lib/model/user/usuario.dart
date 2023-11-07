import 'package:comepaga/model/jsorn_serializer.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario.g.dart';

@JsonSerializable()
class Usuario extends JsonSerializer {
  @JsonKey(name: Constants.nombreUsuarioKey)
  String? nombreUsuario;

  @JsonKey(name: Constants.fechaCreacionKey)
  DateTime? fechaCreacion;

  @JsonKey(name: Constants.nombreKey)
  String? nombre;

  @JsonKey(name: Constants.passwordKey)
  String? password;

  @JsonKey(name: Constants.primerApellidoKey)
  String? primerApellido;

  @JsonKey(name: Constants.segundoApellidoKey)
  String? segundoApellido;

  @JsonKey(name: Constants.tipoUsuarioKey)
  String? tipoUsuario;

  @JsonKey(name: Constants.fechaNacimientoKey)
  DateTime? fechaNacimiento;

  @JsonKey(name: Constants.numeroTelefonoKey)
  String? numeroTelefono;

  Usuario(
      this.nombreUsuario,
      this.fechaCreacion,
      this.nombre,
      this.password,
      this.primerApellido,
      this.segundoApellido,
      this.tipoUsuario,
      this.fechaNacimiento,
      this.numeroTelefono);

  factory Usuario.empty() =>
      Usuario(null, null, null, null, null, null, null, null, null);

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}
