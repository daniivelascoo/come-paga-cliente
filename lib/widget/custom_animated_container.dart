import 'package:flutter/material.dart';

import '../model/restaurant/plato.dart';
import '../theme/app_theme.dart';
import 'custom_input_field.dart';

class CustomAnimatedContainer extends StatefulWidget {
  final BoxConstraints constraint;
  final Map<String, num> expaders;
  final Plato plato;
  final Map<String, Map<String, dynamic>> platoFormvalues;

  const CustomAnimatedContainer(
      {super.key,
      required this.constraint,
      required this.expaders,
      required this.plato,
      required this.platoFormvalues});

  @override
  State<CustomAnimatedContainer> createState() =>
      _CustomAnimatedContainerState();
}

class _CustomAnimatedContainerState extends State<CustomAnimatedContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        padding: const EdgeInsets.all(10),
        color: widget.expaders[widget.plato.id] == 8
            ? Colors.transparent
            : Colors.grey.shade300,
        duration: const Duration(milliseconds: 300),
        width: widget.constraint.maxWidth,
        height: widget.constraint.maxHeight /
            (widget.expaders[widget.plato.id] ?? 8),
        child: widget.expaders[widget.plato.id] == 8
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.plato.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  IconButton(
                      onPressed: () {
                        widget.expaders[widget.plato.id!] = 2;
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 30,
                      ))
                ],
              )
            : FutureBuilder<void>(
                future: Future.delayed(const Duration(milliseconds: 300)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return LayoutBuilder(builder: (context, constraint) {
                      return Form(
                        child: ListView(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: IconButton(
                                onPressed: () {
                                  widget.expaders[widget.plato.id!] = 8;
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  size: 30,
                                ),
                              ),
                            ),
                            Column(
                              children: widget.platoFormvalues[widget.plato.id!] !=
                                      null
                                  ? [
                                      CustomInputField(
                                        hintText: 'Name',
                                        jsonKey: 'nombre_plato',
                                        formvalues:
                                            widget.platoFormvalues[widget.plato.id!]!,
                                        icon: Icons.restaurant_menu,
                                      ),
                                      CustomInputField(
                                        hintText: 'Resume',
                                        jsonKey: 'descripcion_plato',
                                        formvalues:
                                            widget.platoFormvalues[widget.plato.id!]!,
                                        icon: Icons.list_alt_outlined,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: constraint.maxWidth / 2,
                                            height: 40,
                                            child: CustomInputField(
                                              hintText: 'Price',
                                              jsonKey: 'precio_plato',
                                              formvalues: widget.platoFormvalues[
                                                  widget.plato.id!]!,
                                              isRequired: true,
                                              icon: Icons.attach_money_rounded,
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: constraint.maxWidth / 2,
                                            height: 40,
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              style: const ButtonStyle(
                                                fixedSize:
                                                    MaterialStatePropertyAll(
                                                        Size(10, 10)),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        AppTheme.green),
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
                    });
                  } else {
                    return const SizedBox();
                  }
                }));
  }
}
