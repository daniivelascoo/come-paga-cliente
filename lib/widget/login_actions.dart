import 'package:comepaga/model/user/administrador.dart';
import 'package:comepaga/model/user/cliente.dart';
import 'package:comepaga/model/user/repartidor.dart';
import 'package:comepaga/model/user/usuario.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/utils/constants.dart';
import 'package:flutter/material.dart';

import '../screen/args/home_screen_args.dart';

class LoginActions extends StatelessWidget {
  final Map<String, String?> formvalues;
  final GlobalKey<FormState> formkey;

  const LoginActions(
      {super.key, required this.formvalues, required this.formkey});

  @override
  Widget build(BuildContext context) {
    CallService<Usuario> usuarioService =
        CallService(uri: 'usuario', fromJson: Usuario.fromJson);

    return Padding(
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height * 5 / 100),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!formkey.currentState!.validate()) return;

                  usuarioService
                      .get({}, '/${formvalues[Constants.nombreUsuarioKey]}').then(
                          (value) {
                    if (value != null) {
                      var service = CallService(
                          uri: 'usuario', fromJson: Usuario.fromJson);
                      switch (value.tipoUsuario) {
                        case '0':
                          service = CallService<Administrador>(
                              uri: 'usuario', fromJson: Administrador.fromJson);
                          break;
                        case '1':
                          service = CallService<Cliente>(
                              uri: 'usuario', fromJson: Cliente.fromJson);
                          break;
                        case '2':
                          service = CallService<Repartidor>(
                              uri: 'usuario', fromJson: Repartidor.fromJson);
                          break;
                      }

                      service.login('/login', formvalues).then((value) {
                        if (value != null) {
                          Navigator.popAndPushNamed(context, 'home',
                              arguments: HomeScreenArgs(user: value));
                        } else {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: ((context) => AlertDialog(
                                    content: const Text(
                                        'Invalid credentials. Please try again.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Ok',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ))
                                    ],
                                  )));
                        }
                      });
                    }
                  });
                },
                child: const SizedBox(
                  width: 40,
                  child: Text(
                    Constants.logIn,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('log_up');
                  },
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size(150, 30))),
                  child: const Text(
                    Constants.logUp,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ))
            ],
          ),
          Row(children: [
            TextButton(
                onPressed: () {},
                child: Positioned(
                  right: MediaQuery.of(context).size.width - 20,
                  child: const Text(
                    Constants.forgotPassword,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )),
          ]),
        ],
      ),
    );
  }
}
