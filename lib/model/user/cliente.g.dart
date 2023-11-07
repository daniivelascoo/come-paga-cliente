part of 'cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cliente _$ClienteFromJson(Map<String, dynamic> json) => Cliente(
    json[Constants.nombreUsuarioKey] as String?,
    DateTime.parse(json[Constants.fechaCreacionKey] as String),
    json[Constants.nombreKey] as String?,
    json[Constants.passwordKey] as String?,
    json[Constants.primerApellidoKey] as String?,
    json[Constants.segundoApellidoKey] as String?,
    json[Constants.tipoUsuarioKey] as String?,
    json[Constants.fechaNacimientoKey] == null
        ? null
        : DateTime.parse(json[Constants.fechaCreacionKey] as String),
    (json[Constants.ubicacionesKey] as List<dynamic>?)
        ?.map((e) => Ubicacion.fromJson(e as Map<String, dynamic>))
        .toList(),
    json[Constants.ubicacionActualKey] == null
        ? null
        : Ubicacion.fromJson(
            json[Constants.ubicacionActualKey] as Map<String, dynamic>),
    json[Constants.numeroTelefonoKey] as String?);

Map<String, dynamic> _$ClienteToJson(Cliente instance) => <String, dynamic>{
      Constants.nombreUsuarioKey: instance.nombreUsuario,
      Constants.fechaCreacionKey: instance.fechaCreacion!.toIso8601String(),
      Constants.nombreKey: instance.nombre,
      Constants.passwordKey: instance.password,
      Constants.primerApellidoKey: instance.primerApellido,
      Constants.segundoApellidoKey: instance.segundoApellido,
      Constants.tipoUsuarioKey: instance.tipoUsuario,
      Constants.fechaNacimientoKey: instance.fechaNacimiento?.toIso8601String(),
      Constants.numeroTelefonoKey: instance.numeroTelefono,
      Constants.ubicacionActualKey: instance.ubicacionActual?.toJson(),
      Constants.ubicacionesKey: instance.ubicaciones?.map((e) => e.toJson()).toList()
    };
