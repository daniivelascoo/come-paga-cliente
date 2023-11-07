part of 'administrador.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Administrador _$AdministradorFromJson(Map<String, dynamic> json) =>
    Administrador(
        json[Constants.nombreUsuarioKey] as String,
        DateTime.parse(json[Constants.fechaCreacionKey] as String),
        json[Constants.nombreKey] as String,
        json[Constants.passwordKey] as String,
        json[Constants.primerApellidoKey] as String,
        json[Constants.segundoApellidoKey] as String?,
        json[Constants.tipoUsuarioKey] as String,
        json[Constants.fechaNacimientoKey] == null
            ? null
            : DateTime.parse(json[Constants.fechaCreacionKey] as String),
        json[Constants.numeroTelefonoKey] as String?);

Map<String, dynamic> _$AdministradorToJson(Administrador instance) =>
    <String, dynamic>{
      Constants.nombreUsuarioKey: instance.nombreUsuario,
      Constants.fechaCreacionKey: instance.fechaCreacion!.toIso8601String(),
      Constants.nombreKey: instance.nombre,
      Constants.passwordKey: instance.password,
      Constants.primerApellidoKey: instance.primerApellido,
      Constants.segundoApellidoKey: instance.segundoApellido,
      Constants.tipoUsuarioKey: instance.tipoUsuario,
      Constants.fechaNacimientoKey: instance.fechaNacimiento?.toIso8601String(),
      Constants.numeroTelefonoKey: instance.numeroTelefono
    };
