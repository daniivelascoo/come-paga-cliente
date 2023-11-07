import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:comepaga/screen/args/home_screen_args.dart';
import 'package:comepaga/screen/args/update_restaurant_screen_args.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/widget/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../exception/image_not_found_error.dart';
import '../model/restaurant/plato.dart';
import '../model/restaurant/restaurante.dart';
import '../service/call_service.dart';
import '../utils/utils.dart';
import '../widget/custom_snack_bar.dart';
import 'package:http/http.dart' as http;

class UpdateRestaurantScreen extends StatefulWidget {
  const UpdateRestaurantScreen({super.key});

  @override
  State<UpdateRestaurantScreen> createState() => _UpdateRestaurantScreenState();
}

class _UpdateRestaurantScreenState extends State<UpdateRestaurantScreen> {
  final GlobalKey<FormState> formkey = GlobalKey();
  final Map<String, dynamic> formvalues = {};
  final picker = ImagePicker();
  File? file;
  File? uploadFile;
  final Map<String, num> _expaders = {};
  final Map<String, Map<String, dynamic>> platoFormvalues = {};
  final Map<String, GlobalKey<FormState>> platoFormkeys = {};
  bool intiValues = false;
  int preciomedio = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as UpdateRestaurantScreenArgs;

    if (!intiValues) {
      for (var e in args.restaurante.platosCreados) {
        _expaders[e] = 8;
        getPlatoById(e).then((value) {
          if (value != null) {
            platoFormvalues[value.id!] = {
              'nombre_plato': value.nombre,
              'descripcion_plato': value.descripcion,
              'precio_plato': value.precio.toString()
            };

            platoFormkeys[value.id!] = GlobalKey();
          }
        });
      }

      formvalues['nombre'] = args.restaurante.nombre;
      formvalues['descripcion'] = args.restaurante.descripcion;
      intiValues = true;
    }

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey.shade300,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!formkey.currentState!.validate()) {
              final validationError = CustomSnackBar(
                content: const Text(
                  'Errors have been found in the form!',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              );
              ScaffoldMessenger.of(context)
                  .showSnackBar(validationError.build());
            } else {
              if (detectErrorsOnForm()) {
                final validationError = CustomSnackBar(
                  content: const Text(
                    'Errors have been found in the form!',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(validationError.build());
              } else {
                CallService<Restaurante> service = CallService(
                    uri: 'restaurante', fromJson: Restaurante.fromJson);

                List<Plato> platosCrear = [];

                platoFormvalues.forEach((key, value) {
                  Plato plato = Plato(
                      id: key,
                      nombre: value['nombre_plato'],
                      descripcion: value['descripcion_plato'],
                      disponible: true,
                      precio: double.parse(value['precio_plato']));

                  platosCrear.add(plato);
                });

                calculateHalfPrice(platosCrear);

                Restaurante restaurante = Restaurante(
                    nombre: args.restaurante.nombre,
                    descripcion: formvalues['descripcion'],
                    categoria: args.restaurante.categoria,
                    valoracionMedia: args.restaurante.valoracionMedia,
                    precioMedio: preciomedio,
                    valoraciones: args.restaurante.valoraciones,
                    platosCreados: args.restaurante.platosCreados,
                    platosCrear: platosCrear);

                convertImgToMultiPartFile().then((value) {
                  service
                      .postMultiPart('/${args.restaurante.nombre}',
                          {'body': jsonEncode(restaurante)}, value)
                      .then((value) {
                    if (value != null) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'home', (route) => false,
                          arguments: HomeScreenArgs(user: args.administrador));
                    }
                  });
                });
              }
            }
          },
          backgroundColor: Colors.grey.shade300.withOpacity(0.5),
          child: const Icon(Icons.check),
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      height: constraint.maxHeight * 0.25,
                      width: constraint.maxWidth,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade300, width: 1.5))),
                      child: LayoutBuilder(
                        builder: (context, constraint) {
                          return Row(
                            children: [
                              SizedBox(
                                height: constraint.maxHeight,
                                width: constraint.maxWidth * 0.4,
                                child: FutureBuilder<ImageProvider>(
                                  future:
                                      getRestaurantImg(args.restaurante.nombre),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        margin: EdgeInsets.all(
                                            constraint.maxWidth * 0.05),
                                        child: GestureDetector(
                                          onTap: () async {
                                            XFile? picked =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            if (picked != null) {
                                              file = File(picked.path);
                                              setState(() {});
                                            }
                                          },
                                          child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: file == null
                                                  ? snapshot.data!
                                                  : FileImage(file!)),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                          margin: EdgeInsets.all(
                                              constraint.maxWidth * 0.1),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                                color: AppTheme.primaryColor),
                                          ));
                                    }
                                  },
                                ),
                              ),
                              Form(
                                key: formkey,
                                child: SizedBox(
                                    height: constraint.maxHeight,
                                    width: constraint.maxWidth * 0.6,
                                    child: ListView(
                                      children: [
                                        SizedBox(
                                          child: CustomInputField(
                                            hintText: 'Name',
                                            jsonKey: 'nombre',
                                            formvalues: formvalues,
                                            isRequired: true,
                                            icon: Icons.restaurant,
                                            enabled: false,
                                          ),
                                        ),
                                        SizedBox(
                                          child: CustomInputField(
                                            hintText: 'Resume',
                                            jsonKey: 'descripcion',
                                            formvalues: formvalues,
                                            isRequired: true,
                                            icon: Icons.list_alt_outlined,
                                          ),
                                        ),
                                        SizedBox(
                                          child: DropdownButton<String>(
                                            menuMaxHeight: 225.8,
                                            value: args.restaurante.categoria,
                                            items: buildLocationsDropdown(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                args.restaurante.categoria =
                                                    value;
                                              }
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: Colors.black,
                                            ),
                                            underline: Container(),
                                            dropdownColor: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                          ),
                                        )
                                      ],
                                    )),
                              )
                            ],
                          );
                        },
                      )),
                  Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      height: (constraint.maxHeight * 0.75) - 10,
                      width: constraint.maxWidth,
                      child: LayoutBuilder(
                        builder: (context, constraint) {
                          return ListView.separated(
                              itemBuilder: (context, index) {
                                return FutureBuilder<Plato?>(
                                    future: getPlatoById(
                                        args.restaurante.platosCreados[index]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Plato? plato = snapshot.data!;

                                        return AnimatedContainer(
                                            padding: const EdgeInsets.all(10),
                                            color: _expaders[plato.id] == 8
                                                ? Colors.transparent
                                                : Colors.grey.shade300,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            width: constraint.maxWidth,
                                            height: constraint.maxHeight /
                                                (_expaders[plato.id] ?? 8),
                                            child: _expaders[plato.id] == 8
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        plato.nombre,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            _expaders[
                                                                plato.id!] = 2;
                                                            setState(() {});
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            size: 30,
                                                          ))
                                                    ],
                                                  )
                                                : LayoutBuilder(builder:
                                                    (context, constraint) {
                                                    return Form(
                                                      key: platoFormkeys[
                                                          plato.id],
                                                      child: ListView(
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topEnd,
                                                            child: IconButton(
                                                              onPressed: () {
                                                                validatePlatoForm(
                                                                    plato,
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .keyboard_arrow_up_rounded,
                                                                size: 30,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            children:
                                                                platoFormvalues[
                                                                            plato.id!] !=
                                                                        null
                                                                    ? [
                                                                        CustomInputField(
                                                                          hintText:
                                                                              'Name',
                                                                          jsonKey:
                                                                              'nombre_plato',
                                                                          formvalues:
                                                                              platoFormvalues[plato.id!]!,
                                                                          isRequired:
                                                                              true,
                                                                          icon:
                                                                              Icons.restaurant_menu,
                                                                        ),
                                                                        CustomInputField(
                                                                          hintText:
                                                                              'Resume',
                                                                          jsonKey:
                                                                              'descripcion_plato',
                                                                          formvalues:
                                                                              platoFormvalues[plato.id!]!,
                                                                          isRequired:
                                                                              true,
                                                                          icon:
                                                                              Icons.list_alt_outlined,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 20),
                                                                              width: constraint.maxWidth / 2,
                                                                              height: 40,
                                                                              child: CustomInputField(
                                                                                hintText: 'Price',
                                                                                jsonKey: 'precio_plato',
                                                                                formvalues: platoFormvalues[plato.id!]!,
                                                                                isRequired: true,
                                                                                icon: Icons.attach_money_rounded,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 20),
                                                                              width: constraint.maxWidth / 2,
                                                                              height: 40,
                                                                              child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  validatePlatoForm(plato, context);
                                                                                },
                                                                                style: const ButtonStyle(
                                                                                  fixedSize: MaterialStatePropertyAll(Size(10, 10)),
                                                                                  backgroundColor: MaterialStatePropertyAll(AppTheme.green),
                                                                                ),
                                                                                child: const Text('Confirm'),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ]
                                                                    : [],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }));
                                      } else {
                                        return LinearProgressIndicator(
                                          minHeight: constraint.maxHeight / 8,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey.shade300),
                                        );
                                      }
                                    });
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemCount: args.restaurante.platosCreados.length);
                        },
                      ))
                ],
              ),
            );
          },
        ));
  }

  Future<http.MultipartFile?> convertImgToMultiPartFile() async {
    if (file == null) return null;

    var stream = http.ByteStream(file!.openRead());
    var lenght = await file!.length();

    var contentType = Utils.getImageContentType(file!.path.split('.').last);

    var multipartFile = http.MultipartFile('image', stream, lenght,
        filename: file!.path.split('/').last, contentType: contentType);
    return multipartFile;
  }

  void validatePlatoForm(Plato plato, BuildContext context) {
    if (platoFormkeys[plato.id]!.currentState!.validate()) {
      _expaders[plato.id!] = 8;
      setState(() {});
    } else {
      final validationError = CustomSnackBar(
        content: const Text(
          'Errors have been found in the form!',
          style: TextStyle(color: AppTheme.primaryColor),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(validationError.build());
    }
  }

  void calculateHalfPrice(List<Plato> platosCrear) {
    double precioMedio = 0;

    for (Plato plato in platosCrear) {
      precioMedio += plato.precio;
    }

    precioMedio = precioMedio / platosCrear.length;

    if (precioMedio >= 10) preciomedio = 1;
    if (precioMedio > 10 && precioMedio <= 15) preciomedio = 2;
    if (precioMedio > 16 && precioMedio <= 20) preciomedio = 3;
    if (precioMedio > 20) preciomedio = 4;
  }

  Future<ImageProvider> getRestaurantImg(String id) async {
    CallService<Restaurante> service =
        CallService(uri: 'restaurante', fromJson: Restaurante.fromJson);
    List<int>? response = await service.getFile('/$id/img');

    if (response == null) return const AssetImage('assets/ComeYPaga.png');
    uploadFile = File.fromRawPath(Uint8List.fromList(response));

    Uint8List img = Uint8List.fromList(response);
    return MemoryImage(img);
  }

  List<DropdownMenuItem<String>> buildLocationsDropdown() {
    List<String> tiposComida = [
      "Other",
      "Italian",
      "Chinese",
      "Japanese",
      "Mexican",
      "Indian",
      "Thai",
      "French",
      "Spanish",
      "Greek",
      "Lebanese",
      "Korean",
      "Vietnamese",
      "Brazilian",
      "Moroccan",
      "Ethiopian",
    ];

    return tiposComida
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList();
  }

  Future<Plato?> getPlatoById(String platosCreado) async {
    CallService<Plato> service =
        CallService(uri: 'plato', fromJson: Plato.fromJson);

    Plato? plato = await service.get({}, '/$platosCreado');

    return plato;
  }

  bool detectErrorsOnForm() {
    bool hasError = false;
    _expaders.forEach((key, value) {
      if (value == 2) {
        hasError = true;
      }
    });

    return hasError;
  }
}
