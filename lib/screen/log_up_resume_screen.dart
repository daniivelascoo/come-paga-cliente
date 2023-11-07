import 'package:comepaga/model/user/administrador.dart';
import 'package:comepaga/model/user/cliente.dart';
import 'package:comepaga/model/user/repartidor.dart';
import 'package:comepaga/model/user/ubicacion.dart';
import 'package:comepaga/model/user/usuario.dart';
import 'package:comepaga/screen/args/home_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:comepaga/widget/userdata/resume_field.dart';
import 'package:flutter/material.dart';

class LogUpResumeScreen extends StatelessWidget {
  final Map<String, dynamic> formvalues;
  final CallService<Cliente> service =
      CallService<Cliente>(uri: 'usuario', fromJson: Cliente.fromJson);

  LogUpResumeScreen({super.key, required this.formvalues});

  @override
  Widget build(BuildContext context) {
    int usernameSize = formvalues[Constants.nombreUsuarioKey]!.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: Scrollbar(
          controller: ScrollController(),
          thickness: 4,
          radius: const Radius.circular(50),
          thumbVisibility: true,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.height * 5 / 100),
                child: Wrap(
                  children: [
                    const Text(
                      "That's you ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 37.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        '@${formvalues[Constants.nombreUsuarioKey]!}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: (22 * 7.0 / usernameSize) < 13 ||
                                    (22 * 7.0 / usernameSize) > 20
                                ? 13
                                : 22 * 7.0 / usernameSize),
                      ),
                    ),
                    const Text(
                      " !",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 37.0),
                    )
                  ],
                ),
              ),
              Container(
                height: 230,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 13 / 100,
                    right: MediaQuery.of(context).size.width * 3 / 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ResumeField(
                        icon: Icons.person,
                        text:
                            '${formvalues[Constants.nombreKey]!} ${formvalues[Constants.primerApellidoKey]!} ${formvalues[Constants.segundoApellidoKey] == null ? '' : formvalues[Constants.segundoApellidoKey]!}'),
                    ResumeField(
                        icon: Icons.phone,
                        text: formvalues[Constants.numeroTelefonoKey]!),
                    ResumeField(
                        icon: Icons.email,
                        text: formvalues[Constants.correoKey]!),
                    ResumeField(
                        icon: Icons.home_rounded,
                        text:
                            '${formvalues[Constants.direccionKey]!}, ${formvalues[Constants.localizacionKey]!}')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: Stack(
                  children: [
                    Image.asset('assets/ComeYPaga.png'),
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 13 / 100,
                      ),
                      child: Text(
                          'You where born in\n${formvalues[Constants.fechaNacimientoKey]}'),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 42,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(Constants.previous)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 30,
                      child: TextButton(
                        onPressed: () {
                          Cliente Function(Map<String, dynamic>) fromJson =
                              Cliente.fromJson;

                          if (formvalues[Constants.tipoUsuarioKey] == null) {
                            formvalues[Constants.fechaCreacionKey] =
                                DateTime.now().toIso8601String();
                            formvalues[Constants.tipoUsuarioKey] = '1';
                            fromJson = Cliente.fromJson;
                          }

                          if (formvalues[Constants.ubicacionesKey] == null ||
                              (formvalues[Constants.ubicacionesKey] as List<dynamic>?)!.isEmpty) {
                            formvalues[Constants.ubicacionesKey] = [
                              Ubicacion(formvalues[Constants.localizacionKey],
                                      formvalues[Constants.direccionKey])
                                  .toJson()
                            ];
                          } else {
                            (formvalues[Constants.ubicacionesKey]
                                    as List<Map<String, dynamic>>)
                                .add(Ubicacion(
                                        formvalues[Constants.localizacionKey],
                                        formvalues[Constants.direccionKey])
                                    .toJson());
                          }

                          formvalues[Constants.ubicacionActualKey] = Ubicacion(
                                  formvalues[Constants.localizacionKey],
                                  formvalues[Constants.direccionKey])
                              .toJson();

                          service
                              .post(null, fromJson(formvalues), '/cliente')
                              .then((value) {
                            if (value != null) {
                              Navigator.popAndPushNamed(context, 'home',
                                  arguments: HomeScreenArgs(user: value));
                            } else {
                              // TODO: mostrar una ventana emergente señalando que ha habido un error con los datos introducidos
                            }
                          });
                        },
                        child: Row(children: const [
                          Text(
                            'Confirm',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
