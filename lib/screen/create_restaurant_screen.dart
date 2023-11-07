import 'dart:convert';
import 'dart:io';

import 'package:comepaga/exception/image_not_found_error.dart';
import 'package:comepaga/model/restaurant/plato.dart';
import 'package:comepaga/model/restaurant/restaurante.dart';
import 'package:comepaga/screen/args/create_restaurant_screen_args.dart';
import 'package:comepaga/service/call_service.dart';
import 'package:comepaga/theme/app_theme.dart';
import 'package:comepaga/utils/utils.dart';
import 'package:comepaga/widget/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../widget/custom_snack_bar.dart';

class CreateRestaurantScreen extends StatefulWidget {
  const CreateRestaurantScreen({super.key});

  @override
  State<CreateRestaurantScreen> createState() => _CreateRestaurantScreenState();
}

class _CreateRestaurantScreenState extends State<CreateRestaurantScreen> {
  final picker = ImagePicker();
  File? file;
  Widget? image;
  final Map<String, dynamic> formvalues = {};
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String tipoComida = 'Other';
  List<Plato> platosCrear = [];
  num _expander = 18;
  late Widget _expanderChild;
  int precioMedio = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as CreateRestaurantScreenArgs;

    _expanderChild = _expander == 18
        ? LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Add new plate'),
                      IconButton(
                        onPressed: () {
                          _expander = 3.5;
                          setState(() {});
                        },
                        icon: const Icon(Icons.add_circle_outlined),
                        color: AppTheme.green,
                      )
                    ],
                  ),
                ),
              );
            },
          )
        : LayoutBuilder(builder: (context, constraints) {
            final GlobalKey<FormState> platosFormKey = GlobalKey<FormState>();

            return Form(
              key: platosFormKey,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, bottom: 10, right: 40),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomInputField(
                        hintText: 'Name',
                        jsonKey: 'nombre_plato',
                        formvalues: formvalues,
                        isRequired: true,
                        icon: Icons.restaurant_menu,
                        hasNext: true,
                      ),
                      CustomInputField(
                        hintText: 'Resume',
                        jsonKey: 'descripcion_plato',
                        formvalues: formvalues,
                        isRequired: true,
                        icon: Icons.list_alt_outlined,
                        hasNext: true,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.4,
                            child: CustomInputField(
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              hintText: 'Price',
                              jsonKey: 'precio',
                              formvalues: formvalues,
                              isRequired: true,
                              icon: Icons.attach_money,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _expander = 18;
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: AppTheme.primaryColor,
                                size: 25,
                              )),
                          IconButton(
                              onPressed: () {
                                if (!platosFormKey.currentState!.validate()) {
                                  final validationError = CustomSnackBar(
                                    content: const Text(
                                      'Errors have been found in the form!',
                                      style: TextStyle(
                                          color: AppTheme.primaryColor),
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(validationError.build());
                                } else {
                                  platosCrear.add(Plato(
                                      id: null,
                                      nombre: formvalues['nombre_plato'],
                                      descripcion:
                                          formvalues['descripcion_plato'],
                                      disponible: true,
                                      precio:
                                          double.parse(formvalues['precio'])));
                                  _expander = 18;
                                  formvalues['nombre_plato'] = null;
                                  formvalues['descripcion_plato'] = null;
                                  formvalues['precio'] = null;
                                  calculateHalfPrice();
                                  setState(() {});
                                }
                              },
                              icon: const Icon(
                                Icons.add_circle_sharp,
                                color: AppTheme.green,
                                size: 25,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    image = Stack(
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        file == null
            ? const SizedBox()
            : Image.file(
                file!,
                fit: BoxFit.cover,
              ),
        Center(
            child: Text(
          formvalues['nombre'] ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
              overflow: TextOverflow.fade),
        ))
      ],
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!formkey.currentState!.validate()) {
            final validationError = CustomSnackBar(
              content: const Text(
                'Errors have been found in the form!',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(validationError.build());
          } else {
            CallService<Restaurante> service =
                CallService(uri: 'restaurante', fromJson: Restaurante.fromJson);

            convertImgToMultiPartFile().then((value) {
              if (value != null) {
                var res = Restaurante(
                    nombre: formvalues['nombre'],
                    descripcion: formvalues['descripcion'],
                    categoria: tipoComida,
                    valoracionMedia: 0,
                    precioMedio: precioMedio,
                    valoraciones: [],
                    platosCreados: [],
                    platosCrear: platosCrear);

                String body = jsonEncode(res);

                service.postMultiPart('', {'body': body}, value).then((value) {
                  if (value != null) {
                    Navigator.pop(context);
                  }
                });
              }
            }).onError((error, stackTrace) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: ((context) => AlertDialog(
                      content: Text((error as ImageNotFoundException).message),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Ok',
                              style: TextStyle(color: Colors.grey),
                            ))
                      ],
                    )),
              );
            });
          }
        },
        backgroundColor: Colors.grey.shade300.withOpacity(0.65),
        child: const Text('CREATE', style: TextStyle(fontSize: 9),),
      ),
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        
        title: const Center(
          child: Text(
            'Create Restaurant',
            style: TextStyle(color: Colors.black),
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Scrollbar(
                controller: ScrollController(),
                thickness: 4,
                radius: const Radius.circular(20),
                thumbVisibility: true,
                trackVisibility: true,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  padding: const EdgeInsets.only(top: 40),
                  height: constraints.maxHeight * 0.70,
                  width: constraints.maxWidth,
                  child: Form(
                    key: formkey,
                    child: ListView(
                      children: getVistaMain(),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 5),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.5))
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                height: (constraints.maxHeight * 0.30) - 15,
                width: constraints.maxWidth,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          XFile? picked = await picker.pickImage(
                              source: ImageSource.gallery);

                          if (picked != null) {
                            file = File(picked.path);
                            setState(() {});
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              border: file == null
                                  ? Border.all(
                                      color: AppTheme.green, width: 0.5)
                                  : null),
                          height: constraints.maxHeight,
                          width: constraints.maxWidth * 0.5,
                          child: file != null
                              ? image
                              : const Center(
                                  child: Icon(
                                    Icons.add_a_photo_rounded,
                                    color: AppTheme.green,
                                    size: 30,
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6, bottom: 6),
                        padding: const EdgeInsets.only(right: 6),
                        height: constraints.maxHeight,
                        width: constraints.maxWidth * 0.5 - 12,
                        child: ListView(
                          children: [
                            Text(
                              'Food type: $tipoComida',
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: const [
                                Icon(Icons.pedal_bike),
                                SizedBox(width: 10,),
                                Text('30 min')
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              formvalues['descripcion'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('€' * precioMedio)
                          ],
                        ),
                      )
                    ],
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> restaurantInfoVista() {
    return [
      CustomInputField(
        hintText: 'Name',
        jsonKey: 'nombre',
        formvalues: formvalues,
        icon: Icons.restaurant,
        isRequired: true,
        hasNext: true,
        setState: () {
          setState(() {});
        },
      ),
      const SizedBox(
        height: 20,
      ),
      CustomInputField(
        hintText: 'Resume',
        jsonKey: 'descripcion',
        formvalues: formvalues,
        isRequired: true,
        icon: Icons.list_alt_rounded,
        setState: () {
          setState(() {});
        },
      ),
      const SizedBox(
        height: 20,
      ),
      DropdownButton<String>(
        menuMaxHeight: 225.8,
        value: tipoComida,
        items: buildLocationsDropdown(),
        onChanged: (value) {
          if (value != null) tipoComida = value;
          setState(() {});
        },
        icon: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: Colors.black,
        ),
        underline: Container(),
        dropdownColor: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      const Divider(
        thickness: 2,
      )
    ];
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

  List<Widget> crearVistaMenu() {
    List<Widget> res = [];

    for (var e in platosCrear) {
      res.add(Container(
        height: 45,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                e.nombre,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
              ),
              Text('${e.precio.toString()} €')
            ],
          ),
        ),
      ));
      res.add(const Divider(
        indent: 30,
        endIndent: 30,
      ));
    }

    res.add(LayoutBuilder(builder: (context, constraint) {
      return AnimatedContainer(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        duration: const Duration(milliseconds: 300),
        height: MediaQuery.of(context).size.height / _expander,
        child: _expanderChild,
      );
    }));

    res.add(const SizedBox(
      height: 40,
    ));

    return res;
  }

  List<Widget> getVistaMain() {
    List<Widget> res = [];

    res.addAll(restaurantInfoVista());
    res.addAll(crearVistaMenu());

    return res;
  }

  void calculateHalfPrice() {
    double precioMedio = 0;

    for (Plato plato in platosCrear) {
      precioMedio += plato.precio;
    }

    precioMedio = precioMedio / platosCrear.length;

    if (precioMedio >= 10) this.precioMedio = 1;
    if (precioMedio > 10 && precioMedio <= 15) this.precioMedio = 2;
    if (precioMedio > 16 && precioMedio <= 20) this.precioMedio = 3;
    if (precioMedio > 20) this.precioMedio = 4;
  }

  Future<http.MultipartFile?> convertImgToMultiPartFile() async {
    if (file == null) {
      throw ImageNotFoundException("You haven't selected any image.");
    }

    if (file != null) {
      var stream = http.ByteStream(file!.openRead());
      var lenght = await file!.length();

      var contentType = Utils.getImageContentType(file!.path.split('.').last);

      var multipartFile = http.MultipartFile('image', stream, lenght,
          filename: file!.path.split('/').last, contentType: contentType);
      return multipartFile;
    }
  }
}
